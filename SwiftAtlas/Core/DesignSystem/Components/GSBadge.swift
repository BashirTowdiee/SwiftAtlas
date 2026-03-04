import SwiftUI

struct GSBadge: View {
  let title: String
  let tone: AppNotice.Tone

  var body: some View {
    Text(LocalizedStringKey(title))
      .font(GSTypography.caption)
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(backgroundColor.opacity(0.18))
      .foregroundStyle(backgroundColor)
      .clipShape(Capsule())
  }

  private var backgroundColor: Color {
    switch tone {
    case .info: GSColorTokens.sunrise
    case .success: GSColorTokens.mint
    case .warning: GSColorTokens.coral
    case .error: .red
    }
  }
}
