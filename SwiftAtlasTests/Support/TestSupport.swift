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

    init(pinnedIDs: Set<Lesson.ID> = []) {
        self.pinnedIDs = pinnedIDs
    }

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

final class TestHTTPClient: HTTPClient, @unchecked Sendable {
    enum StubError: Error, Sendable {
        case missingResponse(path: String)
    }

    private let responses: [String: Any]

    init(responses: [String: Any] = [:]) {
        self.responses = responses
    }

    func send<Response>(_ request: APIRequest<Response>) async throws -> Response where Response: Decodable {
        if let response = responses[request.path] as? Response {
            return response
        }

        throw StubError.missingResponse(path: request.path)
    }
}

struct TestLessonRepository: LessonRepository {
    var lessonGroups: [LessonGroup]
    var lessonDetail: LessonDetail
    var searchResults: [Lesson]
    var lessonGroupsError: AppError?
    var lessonDetailError: AppError?
    var searchError: AppError?

    @MainActor
    init(
        lessonGroups: [LessonGroup] = SampleLessons.groups,
        lessonDetail: LessonDetail = TestData.lessonDetail(),
        searchResults: [Lesson] = SampleLessons.lessons,
        lessonGroupsError: AppError? = nil,
        lessonDetailError: AppError? = nil,
        searchError: AppError? = nil
    ) {
        self.lessonGroups = lessonGroups
        self.lessonDetail = lessonDetail
        self.searchResults = searchResults
        self.lessonGroupsError = lessonGroupsError
        self.lessonDetailError = lessonDetailError
        self.searchError = searchError
    }

    func fetchLessonGroups(policy: CachePolicy) async throws -> [LessonGroup] {
        if let lessonGroupsError {
            throw lessonGroupsError
        }

        return lessonGroups
    }

    func fetchLessonDetail(id: Lesson.ID, policy: CachePolicy) async throws -> LessonDetail {
        if let lessonDetailError {
            throw lessonDetailError
        }

        return lessonDetail
    }

    func searchLessons(query: String) async throws -> [Lesson] {
        if let searchError {
            throw searchError
        }

        return searchResults
    }
}

struct TestExerciseRepository: ExerciseRepository {
    var exercises: [Exercise]
    var error: AppError?

    @MainActor
    init(
        exercises: [Exercise] = SampleExercises.items,
        error: AppError? = nil
    ) {
        self.exercises = exercises
        self.error = error
    }

    func fetchExercises(for lessonID: Lesson.ID, policy: CachePolicy) async throws -> [Exercise] {
        if let error {
            throw error
        }

        return exercises
    }
}

final class TestCacheStore: CacheStore, @unchecked Sendable {
    private let backingStore: InMemoryCacheStore
    private(set) var removeAllCallCount = 0

    init(backingStore: InMemoryCacheStore = InMemoryCacheStore()) {
        self.backingStore = backingStore
    }

    func value<Value>(for key: CacheKey, as type: Value.Type) throws -> Value? where Value: Decodable {
        try backingStore.value(for: key, as: type)
    }

    func insert<Value>(_ value: Value, for key: CacheKey) throws where Value: Encodable {
        try backingStore.insert(value, for: key)
    }

    func removeValue(for key: CacheKey) throws {
        try backingStore.removeValue(for: key)
    }

    func removeAll() throws {
        removeAllCallCount += 1
        try backingStore.removeAll()
    }
}

enum TestData {
    static func diagnosticsSnapshot(
        cacheLocation: String = "/tmp/tests",
        theme: String = "System",
        activeFlags: [String] = ["Labs"],
        reachability: NetworkReachabilityState = .online
    ) -> DiagnosticsSnapshot {
        DiagnosticsSnapshot(
            metadata: BuildMetadata(bundleIdentifier: "org.example.SwiftAtlasTests", shortVersion: "1.0", buildNumber: "1"),
            cacheLocation: cacheLocation,
            theme: theme,
            activeFlags: activeFlags,
            reachability: reachability
        )
    }

    static func lessonDetail(
        lesson: Lesson = SampleLessons.lessons[0],
        comments: [LessonComment] = [
            LessonComment(id: 1, author: "Preview Mentor", body: "Treat previews as executable examples.")
        ],
        teachingPoints: [String] = [
            "View models should own orchestration.",
            "Repositories should map external data."
        ]
    ) -> LessonDetail {
        LessonDetail(
            lesson: lesson,
            comments: comments,
            relatedLessons: SampleLessons.lessons.filter { $0.id != lesson.id },
            teachingPoints: teachingPoints
        )
    }
}

enum TestContainerFactory {
    @MainActor
    static func makeContainer(
        appState: AppState = AppState(),
        lessonRepository: LessonRepository = PreviewLessonRepository(),
        exerciseRepository: ExerciseRepository = PreviewExerciseRepository(),
        featureFlagStore: TestFeatureFlagStore = TestFeatureFlagStore(),
        secretsStore: SecretsStore = InMemorySecretsStore(),
        cacheStore: CacheStore = InMemoryCacheStore(),
        pinnedLessonStore: PinnedLessonStore = TestPinnedLessonStore(),
        diagnosticsService: DiagnosticsService? = nil
    ) -> AppContainer {
        return AppContainer(
            appState: appState,
            lessonRepository: lessonRepository,
            exerciseRepository: exerciseRepository,
            featureFlagStore: featureFlagStore,
            secretsStore: secretsStore,
            cacheStore: cacheStore,
            pinnedLessonStore: pinnedLessonStore,
            diagnosticsService: diagnosticsService ?? DiagnosticsService(cacheLocation: "/tmp/tests", featureFlagStore: featureFlagStore)
        )
    }
}
