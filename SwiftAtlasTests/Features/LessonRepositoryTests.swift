import Foundation
import Testing
@testable import SwiftAtlas

struct LessonRepositoryTests {
    @Test
    func mapsRemotePayloadsIntoLessonGroups() async throws {
        let encoder = JSONEncoder()
        let payloads: [String: Data] = [
            "/posts": try encoder.encode([
                PostDTO(userId: 1, id: 1, title: "mvvm foundations", body: "Map transport models into domain language."),
                PostDTO(userId: 1, id: 2, title: "cache policies", body: "Cache first keeps first render fast.")
            ]),
            "/users": try encoder.encode([
                UserDTO(id: 1, name: "Ava Metrics", username: "Ava", email: "ava@example.com", company: .init(name: "Architecture", catchPhrase: "Design stable boundaries", bs: "teaching mentor"))
            ])
        ]
        let repository = DefaultLessonRepository(httpClient: FakeHTTPClient(payloads: payloads), cacheStore: InMemoryCacheStore())

        let groups = try await repository.fetchLessonGroups(policy: .remoteOnly)

        #expect(groups.count == 1)
        #expect(groups.first?.title == "Architecture")
        #expect(groups.first?.lessons.count == 2)
    }
}
