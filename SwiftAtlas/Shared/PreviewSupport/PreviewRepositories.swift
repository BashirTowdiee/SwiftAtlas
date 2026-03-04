import Foundation

struct PreviewLessonRepository: LessonRepository {
    func fetchLessonGroups(policy: CachePolicy) async throws -> [LessonGroup] {
        SampleLessons.groups
    }

    func fetchLessonDetail(id: Lesson.ID, policy: CachePolicy) async throws -> LessonDetail {
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
        guard !query.isEmpty else { return SampleLessons.lessons }
        return SampleLessons.lessons.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}

struct PreviewExerciseRepository: ExerciseRepository {
    func fetchExercises(for lessonID: Lesson.ID, policy: CachePolicy) async throws -> [Exercise] {
        SampleExercises.items
    }
}
