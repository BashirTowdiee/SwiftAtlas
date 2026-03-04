import SwiftUI

struct ThemePalette {
  let background: Color
  let surface: Color
  let secondarySurface: Color
  let primaryText: Color
  let secondaryText: Color
  let accent: Color
  let accentSecondary: Color
  let success: Color
  let warning: Color
  let error: Color

  static let light = ThemePalette(
    background: GSColorTokens.ivory,
    surface: .white,
    secondarySurface: Color(red: 0.94, green: 0.91, blue: 0.86),
    primaryText: GSColorTokens.ink,
    secondaryText: Color.black.opacity(0.65),
    accent: GSColorTokens.sunrise,
    accentSecondary: GSColorTokens.coral,
    success: GSColorTokens.mint,
    warning: GSColorTokens.sunrise,
    error: GSColorTokens.coral
  )

  static let dark = ThemePalette(
    background: GSColorTokens.ink,
    surface: GSColorTokens.dusk,
    secondarySurface: Color(red: 0.18, green: 0.19, blue: 0.27),
    primaryText: GSColorTokens.ivory,
    secondaryText: GSColorTokens.mist,
    accent: GSColorTokens.sunrise,
    accentSecondary: GSColorTokens.coral,
    success: GSColorTokens.mint,
    warning: GSColorTokens.sunrise,
    error: Color(red: 0.98, green: 0.52, blue: 0.47)
  )
}
