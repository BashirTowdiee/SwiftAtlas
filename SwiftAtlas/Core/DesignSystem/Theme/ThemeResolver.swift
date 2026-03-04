import SwiftUI

enum ThemeResolver {
  static func palette(for colorScheme: ColorScheme) -> ThemePalette {
    colorScheme == .dark ? .dark : .light
  }
}
