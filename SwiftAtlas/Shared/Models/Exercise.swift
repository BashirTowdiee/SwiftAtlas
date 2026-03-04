import Foundation

struct Exercise: Identifiable, Hashable, Codable, Sendable {
  let id: Int
  let title: String
  let isComplete: Bool
  let rationale: String
}
