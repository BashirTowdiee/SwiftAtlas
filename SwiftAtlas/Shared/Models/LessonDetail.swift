import Foundation

struct LessonDetail: Hashable, Codable, Sendable {
    let lesson: Lesson
    let comments: [LessonComment]
    let relatedLessons: [Lesson]
    let teachingPoints: [String]
}
