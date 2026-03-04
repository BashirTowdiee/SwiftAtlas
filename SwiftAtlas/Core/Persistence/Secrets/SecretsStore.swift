import Foundation

protocol SecretsStore {
    func readValue(for key: SecretKey) throws -> String?
    func writeValue(_ value: String, for key: SecretKey) throws
    func deleteValue(for key: SecretKey) throws
}
