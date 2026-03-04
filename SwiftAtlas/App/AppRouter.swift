import Foundation

enum AppTab: String, CaseIterable, Hashable, Identifiable, Codable, Sendable {
  case home
  case lessons
  case labs
  case settings

  var id: String { rawValue }

  var title: String {
    switch self {
    case .home: String(localized: "Home")
    case .lessons: String(localized: "Lessons")
    case .labs: String(localized: "Labs")
    case .settings: String(localized: "Settings")
    }
  }

  var systemImage: String {
    switch self {
    case .home: "house.fill"
    case .lessons: "books.vertical.fill"
    case .labs: "flask.fill"
    case .settings: "slider.horizontal.3"
    }
  }
}
