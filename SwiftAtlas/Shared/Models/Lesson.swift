import Foundation

struct Lesson: Identifiable, Hashable, Codable, Sendable {
  typealias ID = Int

  let id: ID
  let title: String
  let summary: String
  let body: String
  let track: Track
  let owner: TrackOwner
}
