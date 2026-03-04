import Foundation

protocol PinnedLessonStore {
    func contains(_ lessonID: Lesson.ID) -> Bool
    func toggle(_ lessonID: Lesson.ID)
    func allPinnedIDs() -> Set<Lesson.ID>
}
