import SwiftUI

struct GSSkeletonBlock: View {
  var height: CGFloat = 18

  var body: some View {
    RoundedRectangle(cornerRadius: 10, style: .continuous)
      .fill(Color.secondary.opacity(0.15))
      .frame(maxWidth: .infinity)
      .frame(height: height)
      .redacted(reason: .placeholder)
  }
}
