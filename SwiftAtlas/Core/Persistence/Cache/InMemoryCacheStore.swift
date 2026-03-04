import Foundation

final class InMemoryCacheStore: CacheStore, @unchecked Sendable {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSLock()

    func value<Value: Decodable>(for key: CacheKey, as type: Value.Type) throws -> Value? {
        lock.lock()
        defer { lock.unlock() }

        guard let data = storage[key.rawValue] else {
            return nil
        }
        return try decoder.decode(Value.self, from: data)
    }

    func insert<Value: Encodable>(_ value: Value, for key: CacheKey) throws {
        lock.lock()
        defer { lock.unlock() }

        storage[key.rawValue] = try encoder.encode(value)
    }

    func removeValue(for key: CacheKey) throws {
        lock.lock()
        defer { lock.unlock() }

        storage.removeValue(forKey: key.rawValue)
    }

    func removeAll() throws {
        lock.lock()
        defer { lock.unlock() }

        storage.removeAll()
    }
}
