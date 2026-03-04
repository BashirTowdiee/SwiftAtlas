import Foundation

enum FeatureFlag: String, CaseIterable, Identifiable, Codable, Sendable {
    case labsEnabled
    case remoteSyncEnabled
    case advancedDiagnosticsEnabled
    case experimentalConcurrencyDemosEnabled

    var id: String { rawValue }

    var title: String {
        switch self {
        case .labsEnabled: String(localized: "Labs")
        case .remoteSyncEnabled: String(localized: "Remote Sync")
        case .advancedDiagnosticsEnabled: String(localized: "Advanced Diagnostics")
        case .experimentalConcurrencyDemosEnabled: String(localized: "Concurrency Demos")
        }
    }

    var explanation: String {
        switch self {
        case .labsEnabled: String(localized: "Shows the teaching labs tab and the deeper language demos.")
        case .remoteSyncEnabled: String(localized: "Allows background refreshes against JSONPlaceholder.")
        case .advancedDiagnosticsEnabled: String(localized: "Shows richer cache and bundle diagnostics in Settings.")
        case .experimentalConcurrencyDemosEnabled: String(localized: "Enables cancellable and task-group concurrency demos.")
        }
    }

    var defaultValue: Bool {
        switch self {
        case .labsEnabled: true
        case .remoteSyncEnabled: true
        case .advancedDiagnosticsEnabled: true
        case .experimentalConcurrencyDemosEnabled: true
        }
    }
}
