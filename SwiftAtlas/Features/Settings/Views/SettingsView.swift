import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: @autoclosure @escaping () -> SettingsViewModel = SettingsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: GSSpacing.large) {
                    AppearanceSettingsView(appState: appState)
                    FeatureFlagsView(viewModel: viewModel)
                    SecretsDemoView(viewModel: viewModel)
                    CacheInspectorView(viewModel: viewModel)
                    DiagnosticsView(snapshot: viewModel.diagnostics)
                }
                .padding(GSSpacing.medium)
            }
            .navigationTitle("Settings")
            .task {
                viewModel.bind(container: container)
            }
            .accessibilityIdentifier("settings.screen")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewContainer(
                container: PreviewScenarios.previewContainer(appState: .settingsCustom)
            ) {
                SettingsView()
            }
            .previewDisplayName("Configured")

            PreviewContainer(
                container: PreviewScenarios.previewContainer(
                    appState: .settingsCustom,
                    secretsStore: {
                        let store = InMemorySecretsStore()
                        try? store.writeValue("preview-token", for: .demoAPIToken)
                        return store
                    }()
                )
            ) {
                SettingsView()
            }
            .previewDisplayName("Saved Secret")

            PreviewContainer(
                container: PreviewScenarios.previewContainer(
                    appState: .settingsCustom,
                    flags: .allDisabled
                )
            ) {
                SettingsView()
            }
            .previewDisplayName("Flags Disabled")

            PreviewContainer {
                SettingsView(
                    viewModel: SettingsViewModel(
                        previewSecretStatus: String(localized: "Diagnostics are loading.")
                    )
                )
            }
            .previewDisplayName("Loading")

            PreviewContainer {
                SettingsView()
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
