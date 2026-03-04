import Combine
import Foundation

final class AppContainer: ObservableObject {
    let appState: AppState
    let lessonRepository: LessonRepository
    let exerciseRepository: ExerciseRepository
    let featureFlagStore: FeatureFlagStore
    let secretsStore: SecretsStore
    let cacheStore: CacheStore
    let pinnedLessonStore: PinnedLessonStore
    let diagnosticsService: DiagnosticsService

    init(
        appState: AppState,
        lessonRepository: LessonRepository,
        exerciseRepository: ExerciseRepository,
        featureFlagStore: FeatureFlagStore,
        secretsStore: SecretsStore,
        cacheStore: CacheStore,
        pinnedLessonStore: PinnedLessonStore,
        diagnosticsService: DiagnosticsService
    ) {
        self.appState = appState
        self.lessonRepository = lessonRepository
        self.exerciseRepository = exerciseRepository
        self.featureFlagStore = featureFlagStore
        self.secretsStore = secretsStore
        self.cacheStore = cacheStore
        self.pinnedLessonStore = pinnedLessonStore
        self.diagnosticsService = diagnosticsService
    }
}
