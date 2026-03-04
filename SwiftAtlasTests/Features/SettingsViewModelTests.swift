import Foundation
import Testing
@testable import SwiftAtlas

struct SettingsViewModelTests {
    @MainActor
    @Test
    func bindLoadsDiagnosticsFlagsAndSecretStatus() throws {
        let featureFlags = TestFeatureFlagStore(values: [.labsEnabled: true, .remoteSyncEnabled: false])
        let secretsStore = InMemorySecretsStore()
        try secretsStore.writeValue("preview-token", for: .demoAPIToken)
        let appState = AppState(themeOption: .dark, reachability: .refreshing)
        let container = TestContainerFactory.makeContainer(
            appState: appState,
            featureFlagStore: featureFlags,
            secretsStore: secretsStore
        )
        let viewModel = SettingsViewModel()

        viewModel.bind(container: container)

        #expect(viewModel.secretStatus == "Stored token: preview-token")
        #expect(viewModel.flagValues[.labsEnabled] == true)
        #expect(viewModel.flagValues[.remoteSyncEnabled] == false)
        #expect(viewModel.diagnostics?.theme == "Dark")
        #expect(viewModel.diagnostics?.reachability == .refreshing)
    }

    @MainActor
    @Test
    func saveAndDeleteSecretUpdateStatus() {
        let container = TestContainerFactory.makeContainer()
        let viewModel = SettingsViewModel()
        viewModel.bind(container: container)

        viewModel.secretDraft = "new-secret"
        viewModel.saveSecret()
        #expect(viewModel.secretStatus == "Stored token: new-secret")

        viewModel.deleteSecret()
        #expect(viewModel.secretStatus == "No demo token saved.")
        #expect(viewModel.secretDraft.isEmpty)
    }

    @MainActor
    @Test
    func clearCachePushesSuccessNotice() throws {
        let cacheStore = TestCacheStore()
        try cacheStore.insert([SampleLessons.groups[0]], for: .lessonGroups)
        let appState = AppState()
        let container = TestContainerFactory.makeContainer(appState: appState, cacheStore: cacheStore)
        let viewModel = SettingsViewModel()
        viewModel.bind(container: container)

        viewModel.clearCache()

        #expect(cacheStore.removeAllCallCount == 1)
        #expect(appState.notices.last?.tone == .success)
        #expect(appState.notices.last?.message == "Cleared cached lesson data.")
    }

    @MainActor
    @Test
    func featureFlagsRoundTripThroughStore() {
        let featureFlags = TestFeatureFlagStore(values: [.advancedDiagnosticsEnabled: false])
        let container = TestContainerFactory.makeContainer(featureFlagStore: featureFlags)
        let viewModel = SettingsViewModel()
        viewModel.bind(container: container)

        viewModel.setFlag(.advancedDiagnosticsEnabled, to: true)
        #expect(featureFlags.value(for: .advancedDiagnosticsEnabled) == true)
        #expect(viewModel.flagValues[.advancedDiagnosticsEnabled] == true)

        viewModel.clearFlagOverride(.advancedDiagnosticsEnabled)
        #expect(featureFlags.value(for: .advancedDiagnosticsEnabled) == FeatureFlag.advancedDiagnosticsEnabled.defaultValue)
        #expect(viewModel.flagValues[.advancedDiagnosticsEnabled] == FeatureFlag.advancedDiagnosticsEnabled.defaultValue)
    }
}
