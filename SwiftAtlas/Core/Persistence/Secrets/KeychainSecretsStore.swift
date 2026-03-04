import Foundation
import Security

final class KeychainSecretsStore: SecretsStore {
    private let service = "org.example.SwiftAtlas"

    func readValue(for key: SecretKey) throws -> String? {
        let query = baseQuery(for: key)
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        switch status {
        case errSecSuccess:
            guard let data = item as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            throw AppError.security("Unable to read the secret from the Keychain. Status: \(status)")
        }
    }

    func writeValue(_ value: String, for key: SecretKey) throws {
        let data = Data(value.utf8)
        var query = baseQuery(for: key)
        let attributes = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        switch updateStatus {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            query[kSecValueData as String] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw AppError.security("Unable to save the secret to the Keychain. Status: \(addStatus)")
            }
        default:
            throw AppError.security("Unable to update the Keychain value. Status: \(updateStatus)")
        }
    }

    func deleteValue(for key: SecretKey) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AppError.security("Unable to delete the Keychain value. Status: \(status)")
        }
    }

    private func baseQuery(for key: SecretKey) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
    }
}
