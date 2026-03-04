import Foundation

final class InMemorySecretsStore: SecretsStore {
    private var values: [SecretKey: String] = [:]

    func readValue(for key: SecretKey) throws -> String? {
        values[key]
    }

    func writeValue(_ value: String, for key: SecretKey) throws {
        values[key] = value
    }

    func deleteValue(for key: SecretKey) throws {
        values[key] = nil
    }
}
