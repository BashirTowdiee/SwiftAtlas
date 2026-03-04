import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SettingsViewModel()

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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            SettingsView()
        }
    }
}
