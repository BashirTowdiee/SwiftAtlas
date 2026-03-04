import Testing

@testable import SwiftAtlas

struct InMemorySecretsStoreTests {
  @Test
  func writesReadsAndDeletesValues() throws {
    let store = InMemorySecretsStore()

    try store.writeValue("preview-token", for: .demoAPIToken)
    #expect(try store.readValue(for: .demoAPIToken) == "preview-token")

    try store.deleteValue(for: .demoAPIToken)
    #expect(try store.readValue(for: .demoAPIToken) == nil)
  }
}
