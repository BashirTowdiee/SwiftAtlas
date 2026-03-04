import SwiftUI

@MainActor
final class AppState: ObservableObject {
  @Published var selectedTab: AppTab
  @Published var themeOption: ThemeOption
  @Published var notices: [AppNotice]
  @Published var isDeveloperModeEnabled: Bool
  @Published var reachability: NetworkReachabilityState

  private let defaults: UserDefaults

  init(
    selectedTab: AppTab = .home,
    themeOption: ThemeOption? = nil,
    notices: [AppNotice] = [],
    isDeveloperModeEnabled: Bool = true,
    reachability: NetworkReachabilityState = .online,
    defaults: UserDefaults = .standard
  ) {
    self.selectedTab = selectedTab
    self.defaults = defaults
    self.themeOption =
      themeOption ?? ThemeOption(rawValue: defaults.string(forKey: "app.theme.option") ?? "")
      ?? .system
    self.notices = notices
    self.isDeveloperModeEnabled = isDeveloperModeEnabled
    self.reachability = reachability
  }

  var preferredColorScheme: ColorScheme? {
    themeOption.colorScheme
  }

  func setThemeOption(_ option: ThemeOption) {
    themeOption = option
    defaults.set(option.rawValue, forKey: "app.theme.option")
  }

  func pushNotice(_ notice: AppNotice) {
    notices.append(notice)
  }

  func dismissNotice(id: UUID) {
    notices.removeAll { $0.id == id }
  }

  func clearNotices() {
    notices.removeAll()
  }
}
