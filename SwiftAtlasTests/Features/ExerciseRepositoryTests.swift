import Foundation
import Testing

@testable import SwiftAtlas

struct ExerciseRepositoryTests {
  @Test
  func remoteTodosMapIntoExercises() async throws {
    let repository = DefaultExerciseRepository(
      httpClient: TestHTTPClient(responses: [
        "/todos": [
          TodoDTO(userId: 1, id: 1, title: "first task", completed: false),
          TodoDTO(userId: 1, id: 11, title: "second task", completed: true),
          TodoDTO(userId: 2, id: 2, title: "other lesson", completed: false),
        ]
      ]),
      cacheStore: InMemoryCacheStore()
    )

    let exercises = try await repository.fetchExercises(for: 1, policy: .remoteOnly)

    #expect(exercises.map(\.id) == [1, 11])
    #expect(exercises.map(\.title) == ["First Task", "Second Task"])
    #expect(exercises[1].isComplete == true)
  }

  @Test
  func cacheFirstReturnsCachedExercisesWithoutRemoteCall() async throws {
    let cacheStore = InMemoryCacheStore()
    let cached = [
      Exercise(id: 1, title: "Cached", isComplete: false, rationale: "Cached rationale")
    ]
    try cacheStore.insert(cached, for: .exercises(1))
    let repository = DefaultExerciseRepository(
      httpClient: TestHTTPClient(),
      cacheStore: cacheStore
    )

    let exercises = try await repository.fetchExercises(for: 1, policy: .cacheFirst)

    #expect(exercises == cached)
  }

  @Test
  func cacheOnlyReturnsEmptyArrayWhenNoCacheExists() async throws {
    let repository = DefaultExerciseRepository(
      httpClient: TestHTTPClient(),
      cacheStore: InMemoryCacheStore()
    )

    let exercises = try await repository.fetchExercises(for: 99, policy: .cacheOnly)

    #expect(exercises.isEmpty)
  }

  @Test
  func remoteFetchWritesExercisesIntoCache() async throws {
    let cacheStore = InMemoryCacheStore()
    let repository = DefaultExerciseRepository(
      httpClient: TestHTTPClient(responses: [
        "/todos": [
          TodoDTO(userId: 1, id: 3, title: "write cache", completed: false),
          TodoDTO(userId: 1, id: 13, title: "cache again", completed: true),
        ]
      ]),
      cacheStore: cacheStore
    )

    _ = try await repository.fetchExercises(for: 3, policy: .remoteOnly)
    let cached = try cacheStore.value(for: .exercises(3), as: [Exercise].self)

    #expect(cached?.map(\.id) == [3, 13])
  }
}
