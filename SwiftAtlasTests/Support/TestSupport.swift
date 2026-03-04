import Foundation
@testable import SwiftAtlas

final class TestFeatureFlagStore: FeatureFlagStore {
    private var values: [FeatureFlag: Bool]

    init(values: [FeatureFlag: Bool] = [:]) {
        self.values = values
    }

    func value(for flag: FeatureFlag) -> Bool {
        values[flag] ?? flag.defaultValue
    }

    func setOverride(_ value: Bool?, for flag: FeatureFlag) {
        values[flag] = value
    }
}

final class TestPinnedLessonStore: PinnedLessonStore {
    private var pinnedIDs: Set<Lesson.ID> = []

    func contains(_ lessonID: Lesson.ID) -> Bool {
        pinnedIDs.contains(lessonID)
    }

    func toggle(_ lessonID: Lesson.ID) {
        if pinnedIDs.contains(lessonID) {
            pinnedIDs.remove(lessonID)
        } else {
            pinnedIDs.insert(lessonID)
        }
    }

    func allPinnedIDs() -> Set<Lesson.ID> {
        pinnedIDs
    }
}

enum TestContainerFactory {
    @MainActor
    static func makeContainer() -> AppContainer {
        let appState = AppState()
        let featureFlags = TestFeatureFlagStore()
        let cacheStore = InMemoryCacheStore()
        return AppContainer(
            appState: appState,
            lessonRepository: PreviewLessonRepository(),
            exerciseRepository: PreviewExerciseRepository(),
            featureFlagStore: featureFlags,
            secretsStore: InMemorySecretsStore(),
            cacheStore: cacheStore,
            pinnedLessonStore: TestPinnedLessonStore(),
            diagnosticsService: DiagnosticsService(cacheLocation: "/tmp/tests", featureFlagStore: featureFlags)
        )
    }
}
