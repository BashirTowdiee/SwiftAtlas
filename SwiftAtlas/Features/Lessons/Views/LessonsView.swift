import SwiftUI

struct LessonsView: View {
  @EnvironmentObject private var container: AppContainer
  @StateObject private var viewModel: LessonListViewModel

  init(viewModel: @autoclosure @escaping () -> LessonListViewModel = LessonListViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel())
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: GSSpacing.medium) {
          GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.small) {
              GSSectionHeader(
                eyebrow: "Remote Lessons",
                title: "API-backed learning catalogue",
                detail:
                  "This screen loads JSONPlaceholder data, maps it into lesson models, caches it locally, then lets the view model apply filters and search."
              )
              GSInfoRow(title: "Sync", value: viewModel.lastSyncMessage)
            }
          }

          GSAsyncStateView(
            state: viewModel.loadState,
            retry: {
              Task { await viewModel.load() }
            }
          ) { groups, isStale in
            VStack(alignment: .leading, spacing: GSSpacing.large) {
              if isStale {
                GSBadge(title: "Cached", tone: .warning)
              }
              if groups.isEmpty {
                GSCard {
                  Text("No lessons match the current search and filter state.")
                    .font(GSTypography.body)
                }
              } else {
                ForEach(groups) { group in
                  VStack(alignment: .leading, spacing: GSSpacing.small) {
                    GSSectionHeader(eyebrow: "Group", title: group.title, detail: group.subtitle)
                    ForEach(group.lessons) { lesson in
                      NavigationLink {
                        LessonDetailView(lessonID: lesson.id)
                      } label: {
                        LessonRowView(
                          lesson: lesson,
                          isPinned: viewModel.isPinned(lesson.id),
                          onTogglePin: { viewModel.togglePin(for: lesson.id) }
                        )
                      }
                      .buttonStyle(.plain)
                    }
                  }
                }
              }
            }
          }
        }
        .padding(GSSpacing.medium)
      }
      .background(ThemeResolver.palette(for: colorScheme).background.ignoresSafeArea())
      .navigationTitle("Lessons")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            viewModel.isFilterPresented = true
          } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
          .accessibilityIdentifier("lessons.filterButton")
        }
      }
      .searchable(text: $viewModel.searchQuery, prompt: "Search lessons, tracks, or mentors")
      .sheet(isPresented: $viewModel.isFilterPresented) {
        LessonFilterSheet(viewModel: viewModel)
      }
      .refreshable {
        await viewModel.refresh()
      }
      .task {
        await viewModel.bind(container: container)
      }
      .accessibilityIdentifier("lessons.screen")
    }
  }

  @Environment(\.colorScheme) private var colorScheme
}

struct LessonsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PreviewContainer(
        container: PreviewScenarios.previewContainer(
          appState: .homeDefault,
          lessonRepository: PreviewLessonRepository()
        )
      ) {
        LessonsView()
      }
      .previewDisplayName("Loaded")

      PreviewContainer {
        LessonsView(
          viewModel: LessonListViewModel(
            previewLoadState: .loaded([], isStale: false),
            lastSyncMessage: "Showing 0 search result(s)."
          )
        )
      }
      .previewDisplayName("Empty")

      PreviewContainer {
        LessonsView(viewModel: LessonListViewModel(previewLoadState: .loading))
      }
      .previewDisplayName("Loading")

      PreviewContainer {
        LessonsView(
          viewModel: LessonListViewModel(
            previewLoadState: .failed(.network("Preview network error."))))
      }
      .previewDisplayName("Error")

      PreviewContainer {
        LessonsView(
          viewModel: LessonListViewModel(
            previewLoadState: .loaded(SampleLessons.groups, isStale: true),
            lastSyncMessage: "Cached content is currently visible.",
            baseGroups: SampleLessons.groups
          )
        )
      }
      .previewDisplayName("Stale Cache")
    }
  }
}
