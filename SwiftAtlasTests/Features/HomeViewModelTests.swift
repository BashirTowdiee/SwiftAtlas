import Foundation
import Testing
@testable import SwiftAtlas

struct HomeViewModelTests {
    @MainActor
    @Test
    func bindPopulatesDiagnosticsAndFlags() {
        let featureFlags = TestFeatureFlagStore(values: [
            .labsEnabled: true,
            .remoteSyncEnabled: false,
            .advancedDiagnosticsEnabled: true,
            .experimentalConcurrencyDemosEnabled: false
        ])
        let appState = AppState(themeOption: .dark, reachability: .usingCachedData)
        let container = TestContainerFactory.makeContainer(appState: appState, featureFlagStore: featureFlags)
        let viewModel = HomeViewModel()

        viewModel.bind(container: container)

        #expect(viewModel.activeFlags == [.labsEnabled, .advancedDiagnosticsEnabled])
        #expect(viewModel.diagnostics?.theme == "Dark")
        #expect(viewModel.diagnostics?.reachability == .usingCachedData)
    }

    @MainActor
    @Test
    func secondBindRefreshesCurrentState() {
        let featureFlags = TestFeatureFlagStore(values: [.labsEnabled: true])
        let appState = AppState(themeOption: .system, reachability: .online)
        let container = TestContainerFactory.makeContainer(appState: appState, featureFlagStore: featureFlags)
        let viewModel = HomeViewModel()

        viewModel.bind(container: container)
        appState.setThemeOption(.light)
        appState.reachability = .refreshing
        featureFlags.setOverride(true, for: .advancedDiagnosticsEnabled)

        viewModel.bind(container: container)

        #expect(viewModel.diagnostics?.theme == "Light")
        #expect(viewModel.diagnostics?.reachability == .refreshing)
        #expect(viewModel.activeFlags.contains(.advancedDiagnosticsEnabled))
    }

    @MainActor
    @Test
    func refreshReflectsContainerChanges() {
        let featureFlags = TestFeatureFlagStore(values: [.labsEnabled: true])
        let appState = AppState(themeOption: .system, reachability: .online)
        let container = TestContainerFactory.makeContainer(appState: appState, featureFlagStore: featureFlags)
        let viewModel = HomeViewModel()

        appState.setThemeOption(.dark)
        appState.reachability = .usingCachedData
        featureFlags.setOverride(false, for: .labsEnabled)
        featureFlags.setOverride(true, for: .experimentalConcurrencyDemosEnabled)

        viewModel.refresh(container: container)

        #expect(viewModel.diagnostics?.theme == "Dark")
        #expect(viewModel.diagnostics?.reachability == .usingCachedData)
        #expect(viewModel.activeFlags == [.remoteSyncEnabled, .advancedDiagnosticsEnabled, .experimentalConcurrencyDemosEnabled])
    }

    @Test
    func architectureHighlightsRemainStableAndNonEmpty() {
        let viewModel = HomeViewModel()

        #expect(viewModel.architectureHighlights.count == 4)
        #expect(viewModel.architectureHighlights.allSatisfy { !$0.isEmpty })
        #expect(viewModel.architectureHighlights.contains("MVVM with strict view, view model, repository boundaries."))
    }
}
