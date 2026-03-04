import Foundation

enum CachePolicy: String, CaseIterable, Codable, Sendable {
  case remoteOnly
  case cacheOnly
  case cacheFirst
  case staleWhileRevalidate
}
