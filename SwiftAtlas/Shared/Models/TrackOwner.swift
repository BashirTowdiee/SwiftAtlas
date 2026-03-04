import Foundation

struct TrackOwner: Identifiable, Hashable, Codable, Sendable {
    let id: Int
    let name: String
    let handle: String
    let headline: String
    let email: String
}
