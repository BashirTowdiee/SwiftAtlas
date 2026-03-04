import Foundation

struct DefaultExerciseRepository: ExerciseRepository {
    private let httpClient: HTTPClient
    private let cacheStore: CacheStore

    init(httpClient: HTTPClient, cacheStore: CacheStore) {
        self.httpClient = httpClient
        self.cacheStore = cacheStore
    }

    func fetchExercises(for lessonID: Lesson.ID, policy: CachePolicy) async throws -> [Exercise] {
        switch policy {
        case .cacheOnly:
            return try cacheStore.value(for: .exercises(lessonID), as: [Exercise].self) ?? []
        case .cacheFirst, .staleWhileRevalidate:
            if let cached = try cacheStore.value(for: .exercises(lessonID), as: [Exercise].self), !cached.isEmpty {
                return cached
            }
            return try await refreshExercises(for: lessonID)
        case .remoteOnly:
            return try await refreshExercises(for: lessonID)
        }
    }

    private func refreshExercises(for lessonID: Lesson.ID) async throws -> [Exercise] {
        let todos = try await httpClient.send(JSONPlaceholderAPI.todos())
        let exercises = todos
            .filter { $0.id % 10 == lessonID % 10 }
            .prefix(6)
            .map {
                Exercise(
                    id: $0.id,
                    title: $0.title.capitalized,
                    isComplete: $0.completed,
                    rationale: "This exercise is deterministically mapped from the lesson id so the teaching app stays reproducible."
                )
            }

        let resolved = Array(exercises)
        try cacheStore.insert(resolved, for: .exercises(lessonID))
        return resolved
    }
}
