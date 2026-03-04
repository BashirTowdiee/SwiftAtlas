import Foundation
import Testing
@testable import SwiftAtlas

struct LessonDetailViewModelTests {
    @MainActor
    @Test
    func successfulLoadPopulatesScreenModel() async {
        let detail = TestData.lessonDetail(
            comments: [
                LessonComment(id: 1, author: "Mentor", body: "First comment"),
                LessonComment(id: 2, author: "Learner", body: "Second comment")
            ],
            teachingPoints: [
                "Point A",
                "Point B"
            ]
        )
        let exercises = [
            Exercise(id: 10, title: "Exercise A", isComplete: false, rationale: "Reason A"),
            Exercise(id: 11, title: "Exercise B", isComplete: true, rationale: "Reason B")
        ]
        let container = TestContainerFactory.makeContainer(
            lessonRepository: TestLessonRepository(lessonDetail: detail),
            exerciseRepository: TestExerciseRepository(exercises: exercises)
        )
        let viewModel = LessonDetailViewModel()

        await viewModel.bind(container: container, lessonID: 1)

        guard case let .loaded(model, isStale) = viewModel.state else {
            Issue.record("Expected loaded lesson detail state.")
            return
        }

        #expect(isStale == false)
        #expect(model.detail.comments.count == 2)
        #expect(model.detail.teachingPoints == ["Point A", "Point B"])
        #expect(model.exercises == exercises)
    }

    @MainActor
    @Test
    func failedLoadUsesReadableAppError() async {
        let container = TestContainerFactory.makeContainer(
            lessonRepository: TestLessonRepository(lessonDetailError: AppError.network("Request timed out")),
            exerciseRepository: TestExerciseRepository()
        )
        let viewModel = LessonDetailViewModel()

        await viewModel.bind(container: container, lessonID: 1)

        guard case let .failed(error) = viewModel.state else {
            Issue.record("Expected failure state.")
            return
        }

        #expect(error.title == "Unavailable")
        #expect(error.message.isEmpty == false)
    }

    @MainActor
    @Test
    func refreshReplacesStateAfterRepositoryChange() async {
        let initialDetail = TestData.lessonDetail(teachingPoints: ["Initial"])
        let updatedDetail = TestData.lessonDetail(teachingPoints: ["Updated"])
        var repository = TestLessonRepository(lessonDetail: initialDetail)
        let container = TestContainerFactory.makeContainer(
            lessonRepository: repository,
            exerciseRepository: TestExerciseRepository(exercises: [Exercise(id: 1, title: "One", isComplete: false, rationale: "R")])
        )
        let viewModel = LessonDetailViewModel()

        await viewModel.bind(container: container, lessonID: 1)
        repository.lessonDetail = updatedDetail
        let refreshedContainer = TestContainerFactory.makeContainer(
            lessonRepository: repository,
            exerciseRepository: TestExerciseRepository(exercises: [Exercise(id: 1, title: "One", isComplete: false, rationale: "R")])
        )
        await viewModel.bind(container: refreshedContainer, lessonID: 1)
        await viewModel.load()

        guard case let .loaded(model, _) = viewModel.state else {
            Issue.record("Expected refreshed loaded state.")
            return
        }

        #expect(model.detail.teachingPoints == ["Updated"])
    }
}
