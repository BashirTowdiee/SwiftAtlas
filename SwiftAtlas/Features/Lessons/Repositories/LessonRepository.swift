import Foundation

protocol LessonRepository: Sendable {
    func fetchLessonGroups(policy: CachePolicy) async throws -> [LessonGroup]
    func fetchLessonDetail(id: Lesson.ID, policy: CachePolicy) async throws -> LessonDetail
    func searchLessons(query: String) async throws -> [Lesson]
}
