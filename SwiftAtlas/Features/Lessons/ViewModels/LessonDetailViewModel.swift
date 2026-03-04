import Combine
import Foundation

@MainActor
final class LessonDetailViewModel: ObservableObject {
    @Published var state: LoadableState<LessonDetailScreenModel> = .idle

    private var lessonRepository: LessonRepository?
    private var exerciseRepository: ExerciseRepository?
    private var lessonID: Lesson.ID?
    private var hasLoaded = false

    func bind(container: AppContainer, lessonID: Lesson.ID) async {
        lessonRepository = container.lessonRepository
        exerciseRepository = container.exerciseRepository
        self.lessonID = lessonID

        guard !hasLoaded else { return }
        hasLoaded = true
        await load()
    }

    func load() async {
        guard let lessonID, let lessonRepository, let exerciseRepository else { return }
        state = .loading

        do {
            let detail = try await lessonRepository.fetchLessonDetail(id: lessonID, policy: .staleWhileRevalidate)
            let exercises = try await exerciseRepository.fetchExercises(for: lessonID, policy: .staleWhileRevalidate)
            state = .loaded(LessonDetailScreenModel(detail: detail, exercises: exercises))
        } catch {
            state = .failed(AppError(error: error))
        }
    }
}
