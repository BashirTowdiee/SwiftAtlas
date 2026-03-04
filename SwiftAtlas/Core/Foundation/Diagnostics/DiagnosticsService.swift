import Foundation

struct DiagnosticsService: Sendable {
    let cacheLocation: String
    let featureFlagStore: FeatureFlagStore

    func makeSnapshot(theme: ThemeOption, reachability: NetworkReachabilityState) -> DiagnosticsSnapshot {
        DiagnosticsSnapshot(
            metadata: .current,
            cacheLocation: cacheLocation,
            theme: theme.title,
            activeFlags: FeatureFlag.allCases.filter { featureFlagStore.value(for: $0) }.map(\.title),
            reachability: reachability
        )
    }
}
