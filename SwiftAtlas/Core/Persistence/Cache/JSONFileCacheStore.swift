import Foundation

final class JSONFileCacheStore: CacheStore, @unchecked Sendable {
    private let directoryURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let fileManager: FileManager
    private let lock = NSLock()

    init(directoryURL: URL, fileManager: FileManager = .default) {
        self.directoryURL = directoryURL
        self.fileManager = fileManager
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    func value<Value: Decodable>(for key: CacheKey, as type: Value.Type) throws -> Value? {
        lock.lock()
        defer { lock.unlock() }

        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode(Value.self, from: data)
    }

    func insert<Value: Encodable>(_ value: Value, for key: CacheKey) throws {
        lock.lock()
        defer { lock.unlock() }

        let data = try encoder.encode(value)
        try data.write(to: fileURL(for: key), options: .atomic)
    }

    func removeValue(for key: CacheKey) throws {
        lock.lock()
        defer { lock.unlock() }

        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else {
            return
        }

        try fileManager.removeItem(at: url)
    }

    func removeAll() throws {
        lock.lock()
        defer { lock.unlock() }

        let contents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
        for url in contents {
            try fileManager.removeItem(at: url)
        }
    }

    private func fileURL(for key: CacheKey) -> URL {
        let path = key.rawValue.replacingOccurrences(of: "/", with: "_")
        return directoryURL.appendingPathComponent(path).appendingPathExtension("json")
    }
}
