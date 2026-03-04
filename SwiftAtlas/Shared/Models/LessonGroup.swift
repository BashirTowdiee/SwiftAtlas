import Foundation

struct LessonGroup: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let lessons: [Lesson]
}
