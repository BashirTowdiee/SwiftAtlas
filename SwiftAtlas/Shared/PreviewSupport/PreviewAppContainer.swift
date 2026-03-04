import Foundation

enum PreviewAppContainer {
  static func makeLiveContainer() -> AppContainer {
    let appState = AppState()
    let featureFlagStore = UserDefaultsFeatureFlagStore()
    let cacheDirectory = FileManager.default.urls(
      for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("SwiftAtlasCache", isDirectory: true)
    let cacheStore = JSONFileCacheStore(directoryURL: cacheDirectory)
    let httpClient = URLSessionHTTPClient()
    let diagnosticsService = DiagnosticsService(
      cacheLocation: cacheDirectory.path, featureFlagStore: featureFlagStore)

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

  static func makePreviewContainer(
    appState: AppState = AppState(
      themeOption: .dark,
      notices: [AppNotice(tone: .info, message: "Preview mode uses deterministic fixtures.")]
    ),
    featureFlags: [FeatureFlag: Bool] = SampleFlags.allEnabled,
    lessonRepository: LessonRepository = PreviewLessonRepository(),
    exerciseRepository: ExerciseRepository = PreviewExerciseRepository(),
    secretsStore: SecretsStore = InMemorySecretsStore(),
    cacheStore: CacheStore = InMemoryCacheStore(),
    pinnedLessonStore: PinnedLessonStore = PreviewPinnedLessonStore()
  ) -> AppContainer {
    let defaults = UserDefaults(suiteName: "SwiftAtlas.preview.\(UUID().uuidString)") ?? .standard
    let featureFlagStore = UserDefaultsFeatureFlagStore(defaults: defaults)
    FeatureFlag.allCases.forEach { flag in
      featureFlagStore.setOverride(featureFlags[flag], for: flag)
    }
    let diagnosticsService = DiagnosticsService(
      cacheLocation: "/tmp/SwiftAtlasPreview", featureFlagStore: featureFlagStore)

    return AppContainer(
      appState: appState,
      lessonRepository: lessonRepository,
      exerciseRepository: exerciseRepository,
      featureFlagStore: featureFlagStore,
      secretsStore: secretsStore,
      cacheStore: cacheStore,
      pinnedLessonStore: pinnedLessonStore,
      diagnosticsService: diagnosticsService
    )
  }
}
