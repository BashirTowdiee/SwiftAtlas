import Foundation

enum NetworkReachabilityState: String, Codable, Sendable {
    case online
    case refreshing
    case usingCachedData
}
