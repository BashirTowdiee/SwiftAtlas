import Foundation

final class UserDefaultsPinnedLessonStore: PinnedLessonStore {
  private let defaults: UserDefaults
  private let key = "lessons.pinned.ids"

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func contains(_ lessonID: Lesson.ID) -> Bool {
    allPinnedIDs().contains(lessonID)
  }

  func toggle(_ lessonID: Lesson.ID) {
    var current = allPinnedIDs()
    if current.contains(lessonID) {
      current.remove(lessonID)
    } else {
      current.insert(lessonID)
    }
    defaults.set(Array(current).sorted(), forKey: key)
  }

  func allPinnedIDs() -> Set<Lesson.ID> {
    Set(defaults.array(forKey: key) as? [Int] ?? [])
  }
}
