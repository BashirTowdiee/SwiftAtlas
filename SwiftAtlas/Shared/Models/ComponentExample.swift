import Foundation

struct ComponentExample: Identifiable, Hashable, Codable, Sendable {
  let id: String
  let title: String
  let detail: String
}
