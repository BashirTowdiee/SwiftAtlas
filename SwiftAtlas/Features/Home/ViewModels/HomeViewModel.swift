import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var diagnostics: DiagnosticsSnapshot?
    @Published var activeFlags: [FeatureFlag] = []

    private var hasBound = false

    func bind(container: AppContainer) {
        guard !hasBound else {
            refresh(container: container)
            return
        }
        hasBound = true
        refresh(container: container)
    }

    func refresh(container: AppContainer) {
        activeFlags = FeatureFlag.allCases.filter { container.featureFlagStore.value(for: $0) }
        diagnostics = container.diagnosticsService.makeSnapshot(
            theme: container.appState.themeOption,
            reachability: container.appState.reachability
        )
    }

    var architectureHighlights: [String] {
        [
            "MVVM with strict view, view model, repository boundaries.",
            "App-owned domain models isolate JSONPlaceholder DTOs.",
            "Structured concurrency and explicit cache policies are taught through real flows.",
            "Preview fixtures and tests are first-class parts of the architecture."
        ]
    }
}
