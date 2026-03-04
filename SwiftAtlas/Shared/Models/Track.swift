import Foundation

struct Track: Identifiable, Hashable, Codable, Sendable {
    let id: Int
    let title: String
    let summary: String
}
