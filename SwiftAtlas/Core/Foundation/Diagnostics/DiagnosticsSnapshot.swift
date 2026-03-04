import Foundation

struct DiagnosticsSnapshot: Hashable, Sendable {
    let metadata: BuildMetadata
    let cacheLocation: String
    let theme: String
    let activeFlags: [String]
    let reachability: NetworkReachabilityState
}
