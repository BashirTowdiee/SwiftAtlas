import Foundation

protocol ExerciseRepository: Sendable {
  func fetchExercises(for lessonID: Lesson.ID, policy: CachePolicy) async throws -> [Exercise]
}
