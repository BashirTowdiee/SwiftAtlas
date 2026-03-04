import Foundation

struct LessonComment: Identifiable, Hashable, Codable, Sendable {
  let id: Int
  let author: String
  let body: String
}
