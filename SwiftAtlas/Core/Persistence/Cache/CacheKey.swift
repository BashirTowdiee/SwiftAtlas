import Foundation

struct CacheKey: Hashable, Codable, Sendable {
    let rawValue: String

    static let lessonGroups = CacheKey(rawValue: "lessons/groups")

    static func lessonDetail(_ id: Int) -> CacheKey {
        CacheKey(rawValue: "lessons/detail/\(id)")
    }

    static func exercises(_ lessonID: Int) -> CacheKey {
        CacheKey(rawValue: "lessons/exercises/\(lessonID)")
    }
}
