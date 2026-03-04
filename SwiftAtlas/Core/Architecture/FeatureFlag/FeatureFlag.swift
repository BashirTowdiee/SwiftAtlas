import Foundation

enum FeatureFlag: String, CaseIterable, Identifiable, Codable, Sendable {
    case labsEnabled
    case remoteSyncEnabled
    case advancedDiagnosticsEnabled
    case experimentalConcurrencyDemosEnabled

    var id: String { rawValue }

    var title: String {
        switch self {
        case .labsEnabled: "Labs"
        case .remoteSyncEnabled: "Remote Sync"
        case .advancedDiagnosticsEnabled: "Advanced Diagnostics"
        case .experimentalConcurrencyDemosEnabled: "Concurrency Demos"
        }
    }

    var explanation: String {
        switch self {
        case .labsEnabled: "Shows the teaching labs tab and the deeper language demos."
        case .remoteSyncEnabled: "Allows background refreshes against JSONPlaceholder."
        case .advancedDiagnosticsEnabled: "Shows richer cache and bundle diagnostics in Settings."
        case .experimentalConcurrencyDemosEnabled: "Enables cancellable and task-group concurrency demos."
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
