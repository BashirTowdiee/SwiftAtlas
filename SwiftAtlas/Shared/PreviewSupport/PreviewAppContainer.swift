import Foundation

enum PreviewAppContainer {
    static func makeLiveContainer() -> AppContainer {
        let appState = AppState()
        let featureFlagStore = UserDefaultsFeatureFlagStore()
        let cacheDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SwiftAtlasCache", isDirectory: true)
        let cacheStore = JSONFileCacheStore(directoryURL: cacheDirectory)
        let httpClient = URLSessionHTTPClient()
        let diagnosticsService = DiagnosticsService(cacheLocation: cacheDirectory.path, featureFlagStore: featureFlagStore)

        return AppContainer(
            appState: appState,
            lessonRepository: DefaultLessonRepository(httpClient: httpClient, cacheStore: cacheStore),
            exerciseRepository: DefaultExerciseRepository(httpClient: httpClient, cacheStore: cacheStore),
            featureFlagStore: featureFlagStore,
            secretsStore: KeychainSecretsStore(),
            cacheStore: cacheStore,
            pinnedLessonStore: UserDefaultsPinnedLessonStore(),
            diagnosticsService: diagnosticsService
        )
    }

    static func makePreviewContainer() -> AppContainer {
        let appState = AppState(themeOption: .dark, notices: [AppNotice(tone: .info, message: "Preview mode uses deterministic fixtures.")])
        let featureFlagStore = UserDefaultsFeatureFlagStore(defaults: .standard)
        FeatureFlag.allCases.forEach { featureFlagStore.setOverride(true, for: $0) }
        let cacheStore = InMemoryCacheStore()
        let previewRepository = PreviewLessonRepository()
        let diagnosticsService = DiagnosticsService(cacheLocation: "/tmp/SwiftAtlasPreview", featureFlagStore: featureFlagStore)

        return AppContainer(
            appState: appState,
            lessonRepository: previewRepository,
            exerciseRepository: PreviewExerciseRepository(),
            featureFlagStore: featureFlagStore,
            secretsStore: InMemorySecretsStore(),
            cacheStore: cacheStore,
            pinnedLessonStore: UserDefaultsPinnedLessonStore(defaults: .standard),
            diagnosticsService: diagnosticsService
        )
    }
}
