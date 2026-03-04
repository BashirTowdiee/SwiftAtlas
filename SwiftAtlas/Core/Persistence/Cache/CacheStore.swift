import Foundation

protocol CacheStore: Sendable {
    func value<Value: Decodable>(for key: CacheKey, as type: Value.Type) throws -> Value?
    func insert<Value: Encodable>(_ value: Value, for key: CacheKey) throws
    func removeValue(for key: CacheKey) throws
    func removeAll() throws
}
