import Foundation

struct PreviewLessonRepository: LessonRepository {
    enum Variant {
        case standard
        case empty
        case failure(AppError)
    }

    private let variant: Variant

    init(variant: Variant = .standard) {
        self.variant = variant
    }

    func fetchLessonGroups(policy: CachePolicy) async throws -> [LessonGroup] {
        switch variant {
        case .standard:
            return SampleLessons.groups
        case .empty:
            return []
        case let .failure(error):
            throw error
        }
    }

    func fetchLessonDetail(id: Lesson.ID, policy: CachePolicy) async throws -> LessonDetail {
        if case let .failure(error) = variant {
            throw error
        }

        let lesson = SampleLessons.lessons.first(where: { $0.id == id }) ?? SampleLessons.lessons[0]
        return LessonDetail(
            lesson: lesson,
            comments: [
                LessonComment(id: 1, author: "Preview Mentor", body: "Treat previews as executable examples."),
                LessonComment(id: 2, author: "Preview Learner", body: "Show loading, empty, error, and dark mode states.")
            ],
            relatedLessons: SampleLessons.lessons.filter { $0.id != lesson.id },
            teachingPoints: [
                "Preview fixtures should be deterministic.",
                "Reusability starts with stable shared models."
            ]
        )
    }

    func searchLessons(query: String) async throws -> [Lesson] {
        if case let .failure(error) = variant {
            throw error
        }

        guard !query.isEmpty else { return SampleLessons.lessons }
        let filtered = SampleLessons.lessons.filter { $0.title.localizedCaseInsensitiveContains(query) }
        if case .empty = variant {
            return []
        }
        return filtered
    }
}

struct PreviewExerciseRepository: ExerciseRepository {
    enum Variant {
        case standard
        case empty
        case failure(AppError)
    }

    private let variant: Variant

    init(variant: Variant = .standard) {
        self.variant = variant
    }

    func fetchExercises(for lessonID: Lesson.ID, policy: CachePolicy) async throws -> [Exercise] {
        switch variant {
        case .standard:
            return SampleExercises.items
        case .empty:
            return []
        case let .failure(error):
            throw error
        }
    }
}

final class PreviewPinnedLessonStore: PinnedLessonStore {
    private var pinnedIDs: Set<Lesson.ID>

    init(pinnedIDs: Set<Lesson.ID> = [1]) {
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
