import Foundation

struct AppNotice: Identifiable, Hashable, Codable, Sendable {
  enum Tone: String, Codable, Sendable {
    case info
    case success
    case warning
    case error
  }

  let id: UUID
  let tone: Tone
  let message: String

  init(id: UUID = UUID(), tone: Tone, message: String) {
    self.id = id
    self.tone = tone
    self.message = message
  }
}
