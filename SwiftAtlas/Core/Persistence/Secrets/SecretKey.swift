import Foundation

enum SecretKey: String, CaseIterable, Identifiable, Sendable {
    case demoAPIToken = "demo.api.token"

    var id: String { rawValue }
}
