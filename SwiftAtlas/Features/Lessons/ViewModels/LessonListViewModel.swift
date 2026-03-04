import Combine
import Foundation

@MainActor
final class LessonListViewModel: ObservableObject {
  @Published var loadState: LoadableState<[LessonGroup]> = .idle
  @Published var searchQuery = "" {
    didSet {
      scheduleSearch()
    }
  }
  @Published var selectedTrackID: Int?
  @Published var showPinnedOnly = false
  @Published var isFilterPresented = false
  @Published var lastSyncMessage = String(localized: "Waiting for first load.")

  private var lessonRepository: LessonRepository?
  private var pinnedLessonStore: PinnedLessonStore?
  private weak var appState: AppState?
  private var searchTask: Task<Void, Never>?
  private var refreshTask: Task<Void, Never>?
  private var baseGroups: [LessonGroup] = []
  private var hasBound = false

  init() {}

  init(
    previewLoadState: LoadableState<[LessonGroup]>,
    searchQuery: String = "",
    selectedTrackID: Int? = nil,
    showPinnedOnly: Bool = false,
    isFilterPresented: Bool = false,
    lastSyncMessage: String = String(localized: "Waiting for first load."),
    baseGroups: [LessonGroup] = []
  ) {
    loadState = previewLoadState
    self.searchQuery = searchQuery
    self.selectedTrackID = selectedTrackID
    self.showPinnedOnly = showPinnedOnly
    self.isFilterPresented = isFilterPresented
    self.lastSyncMessage = lastSyncMessage
    self.baseGroups = baseGroups
    hasBound = true
  }

  func bind(container: AppContainer) async {
    lessonRepository = container.lessonRepository
    pinnedLessonStore = container.pinnedLessonStore
    appState = container.appState

    guard !hasBound else { return }
    hasBound = true
    await load()
  }

  var availableTracks: [Track] {
    Array(Set(baseGroups.flatMap { $0.lessons.map(\.track) })).sorted { $0.title < $1.title }
  }

  func load() async {
    guard let repository = lessonRepository else { return }

    loadState = .loading
    do {
      let groups = try await repository.fetchLessonGroups(policy: .cacheFirst)
      baseGroups = groups
      applyCurrentFilters(isStale: false)
      appState?.reachability = .refreshing
      lastSyncMessage = String(
        localized: "Loaded cached or remote data, now checking for fresher content.")
      await refreshInBackground()
    } catch {
      loadState = .failed(AppError(error: error))
      appState?.reachability = .usingCachedData
    }
  }

  func refresh() async {
    guard let repository = lessonRepository else { return }

    do {
      let groups = try await repository.fetchLessonGroups(policy: .remoteOnly)
      baseGroups = groups
      applyCurrentFilters(isStale: false)
      appState?.reachability = .online
      lastSyncMessage = String(localized: "Remote content refreshed successfully.")
    } catch {
      if !baseGroups.isEmpty {
        applyCurrentFilters(isStale: true)
        appState?.pushNotice(
          AppNotice(
            tone: .warning,
            message: String(localized: "Remote refresh failed. Showing cached lesson content.")))
        appState?.reachability = .usingCachedData
        lastSyncMessage = String(
          localized: "Remote refresh failed, but cached data is still available.")
      } else {
        loadState = .failed(AppError(error: error))
      }
    }
  }

  func togglePin(for lessonID: Lesson.ID) {
    pinnedLessonStore?.toggle(lessonID)
    applyCurrentFilters(isStale: false)
  }

  func isPinned(_ lessonID: Lesson.ID) -> Bool {
    pinnedLessonStore?.contains(lessonID) ?? false
  }

  private func refreshInBackground() async {
    refreshTask?.cancel()
    refreshTask = Task { [weak self] in
      await self?.refresh()
    }
    await refreshTask?.value
  }

  private func scheduleSearch() {
    searchTask?.cancel()
    searchTask = Task { [weak self] in
      try? await Task.sleep(for: .milliseconds(250))
      guard !Task.isCancelled else { return }
      await self?.performSearch()
    }
  }

  private func performSearch() async {
    guard let repository = lessonRepository else { return }
    let normalized = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !normalized.isEmpty else {
      applyCurrentFilters(isStale: false)
      return
    }

    do {
      let results = try await repository.searchLessons(query: normalized)
      let grouped = Dictionary(grouping: results, by: \.track.title)
        .map { title, lessons in
          LessonGroup(
            id: "search-\(title)",
            title: title,
            subtitle: String(format: String(localized: "%lld result(s)"), lessons.count),
            lessons: lessons.sorted { $0.title < $1.title }
          )
        }
        .sorted { $0.title < $1.title }
      loadState = .loaded(filtered(groups: grouped), isStale: false)
      lastSyncMessage = String(
        format: String(localized: "Showing %lld search result(s) for \"%@\"."),
        results.count,
        normalized
      )
    } catch {
      loadState = .failed(AppError(error: error))
    }
  }

  private func applyCurrentFilters(isStale: Bool) {
    loadState = .loaded(filtered(groups: baseGroups), isStale: isStale)
  }

  private func filtered(groups: [LessonGroup]) -> [LessonGroup] {
    groups.compactMap { group in
      let lessons = group.lessons.filter { lesson in
        let matchesTrack = selectedTrackID == nil || lesson.track.id == selectedTrackID
        let matchesPinned = !showPinnedOnly || isPinned(lesson.id)
        return matchesTrack && matchesPinned
      }

      guard !lessons.isEmpty else { return nil }
      return LessonGroup(
        id: group.id, title: group.title, subtitle: group.subtitle, lessons: lessons)
    }
  }
}
