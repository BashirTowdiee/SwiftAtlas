import Foundation

struct DefaultLessonRepository: LessonRepository {
  private let httpClient: HTTPClient
  private let cacheStore: CacheStore

  init(httpClient: HTTPClient, cacheStore: CacheStore) {
    self.httpClient = httpClient
    self.cacheStore = cacheStore
  }

  func fetchLessonGroups(policy: CachePolicy) async throws -> [LessonGroup] {
    switch policy {
    case .cacheOnly:
      return try cacheStore.value(for: .lessonGroups, as: [LessonGroup].self) ?? []
    case .cacheFirst, .staleWhileRevalidate:
      if let cached = try cacheStore.value(for: .lessonGroups, as: [LessonGroup].self),
        !cached.isEmpty
      {
        return cached
      }
      return try await refreshLessonGroups()
    case .remoteOnly:
      return try await refreshLessonGroups()
    }
  }

  func fetchLessonDetail(id: Lesson.ID, policy: CachePolicy) async throws -> LessonDetail {
    switch policy {
    case .cacheOnly:
      if let cached = try cacheStore.value(for: .lessonDetail(id), as: LessonDetail.self) {
        return cached
      }
      throw AppError.unavailable("No cached lesson detail exists yet.")
    case .cacheFirst, .staleWhileRevalidate:
      if let cached = try cacheStore.value(for: .lessonDetail(id), as: LessonDetail.self) {
        return cached
      }
      return try await refreshLessonDetail(id: id)
    case .remoteOnly:
      return try await refreshLessonDetail(id: id)
    }
  }

  func searchLessons(query: String) async throws -> [Lesson] {
    let groups = try await fetchLessonGroups(policy: .cacheFirst)
    let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    guard !normalized.isEmpty else {
      return groups.flatMap(\.lessons)
    }

    return
      groups
      .flatMap(\.lessons)
      .filter { lesson in
        lesson.title.lowercased().contains(normalized)
          || lesson.summary.lowercased().contains(normalized)
          || lesson.track.title.lowercased().contains(normalized)
          || lesson.owner.name.lowercased().contains(normalized)
      }
  }

  private func refreshLessonGroups() async throws -> [LessonGroup] {
    let posts = try await httpClient.send(JSONPlaceholderAPI.posts())
    let users = try await httpClient.send(JSONPlaceholderAPI.users())
    let mapped = mapLessonGroups(posts: posts, users: users)
    try cacheStore.insert(mapped, for: .lessonGroups)
    return mapped
  }

  private func refreshLessonDetail(id: Lesson.ID) async throws -> LessonDetail {
    let resolvedPost = try await httpClient.send(JSONPlaceholderAPI.post(id: id))
    let users = try await httpClient.send(JSONPlaceholderAPI.users())
    let comments = try await httpClient.send(JSONPlaceholderAPI.comments(postID: id))
    let posts = try await httpClient.send(JSONPlaceholderAPI.posts())

    let detail = try mapLessonDetail(
      post: resolvedPost,
      users: users,
      comments: comments,
      posts: posts
    )
    try cacheStore.insert(detail, for: .lessonDetail(id))
    return detail
  }

  private func mapLessonGroups(posts: [PostDTO], users: [UserDTO]) -> [LessonGroup] {
    let lessons: [Lesson] = posts.compactMap { post in
      guard let user = users.first(where: { $0.id == post.userId }) else { return nil }
      return mapLesson(post: post, user: user)
    }

    let grouped = Dictionary(grouping: lessons, by: { $0.track.title })
    return
      grouped
      .map { key, value in
        LessonGroup(
          id: key,
          title: key,
          subtitle: value.first?.owner.name ?? "Mentor",
          lessons: value.sorted { $0.title < $1.title }
        )
      }
      .sorted { $0.title < $1.title }
  }

  private func mapLessonDetail(
    post: PostDTO,
    users: [UserDTO],
    comments: [CommentDTO],
    posts: [PostDTO]
  ) throws -> LessonDetail {
    guard let user = users.first(where: { $0.id == post.userId }) else {
      throw AppError.unavailable("No author metadata was available for lesson \(post.id).")
    }

    let lesson = mapLesson(post: post, user: user)
    let relatedLessons =
      posts
      .filter { $0.userId == post.userId && $0.id != post.id }
      .prefix(3)
      .map { mapLesson(post: $0, user: user) }

    return LessonDetail(
      lesson: lesson,
      comments: comments.map { LessonComment(id: $0.id, author: $0.name, body: $0.body) },
      relatedLessons: Array(relatedLessons),
      teachingPoints: [
        "View models own async orchestration while views stay declarative.",
        "Repositories map API DTOs into domain models before UI code sees them.",
        "Semantic theme tokens keep styling consistent across light and dark mode.",
      ]
    )
  }

  private func mapLesson(post: PostDTO, user: UserDTO) -> Lesson {
    Lesson(
      id: post.id,
      title: post.title.capitalized,
      summary: post.body.split(separator: ".").first.map(String.init) ?? post.body,
      body: post.body,
      track: Track(id: user.id, title: user.company.name, summary: user.company.catchPhrase),
      owner: TrackOwner(
        id: user.id,
        name: user.name,
        handle: "@\(user.username.lowercased())",
        headline: user.company.bs.capitalized,
        email: user.email
      )
    )
  }
}
