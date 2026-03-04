import Foundation

struct LabTopic: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let summary: String
    let symbol: String
}
