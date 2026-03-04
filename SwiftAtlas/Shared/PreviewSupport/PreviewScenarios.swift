import Foundation

enum PreviewScenarios {
  enum FlagVariant {
    case allEnabled
    case diagnosticsHeavy
    case allDisabled

    var values: [FeatureFlag: Bool] {
      switch self {
      case .allEnabled:
        return FeatureFlag.allCases.reduce(into: [:]) { result, flag in
          result[flag] = true
        }
      case .diagnosticsHeavy:
        return [
          .labsEnabled: true,
          .remoteSyncEnabled: false,
          .advancedDiagnosticsEnabled: true,
          .experimentalConcurrencyDemosEnabled: true,
        ]
      case .allDisabled:
        return FeatureFlag.allCases.reduce(into: [:]) { result, flag in
          result[flag] = false
        }
      }
    }
  }

  enum AppStateVariant {
    case homeDefault
    case diagnosticsHeavy
    case settingsCustom

    var appState: AppState {
      switch self {
      case .homeDefault:
        return AppState(
          selectedTab: .home,
          themeOption: .system,
          notices: [AppNotice(tone: .info, message: "Preview mode uses deterministic fixtures.")],
          reachability: .online
        )
      case .diagnosticsHeavy:
        return AppState(
          selectedTab: .home,
          themeOption: .dark,
          notices: [AppNotice(tone: .info, message: "Preview mode uses deterministic fixtures.")],
          reachability: .usingCachedData
        )
      case .settingsCustom:
        return AppState(
          selectedTab: .settings,
          themeOption: .light,
          notices: [
            AppNotice(tone: .success, message: "Preview settings reflect a non-default state.")
          ],
          isDeveloperModeEnabled: false,
          reachability: .refreshing
        )
      }
    }
  }

  enum LessonsVariant {
    case loaded
    case empty
    case loading
    case error
    case stale
  }

  static let longLessonTitle =
    "Use semantic tokens to keep your view tree small, legible, and adaptable across dark mode, dynamic type, and future redesigns."

  static func previewContainer(
    appState: AppStateVariant = .homeDefault,
    flags: FlagVariant = .allEnabled,
    lessonRepository: LessonRepository = PreviewLessonRepository(),
    exerciseRepository: ExerciseRepository = PreviewExerciseRepository(),
    secretsStore: SecretsStore = InMemorySecretsStore(),
    cacheStore: CacheStore = InMemoryCacheStore(),
    pinnedLessonStore: PinnedLessonStore = PreviewPinnedLessonStore()
  ) -> AppContainer {
    PreviewAppContainer.makePreviewContainer(
      appState: appState.appState,
      featureFlags: flags.values,
      lessonRepository: lessonRepository,
      exerciseRepository: exerciseRepository,
      secretsStore: secretsStore,
      cacheStore: cacheStore,
      pinnedLessonStore: pinnedLessonStore
    )
  }
}
