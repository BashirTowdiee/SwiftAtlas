import SwiftUI

struct GSToggleRow: View {
  let title: String
  let detail: String
  @Binding var isOn: Bool

  var body: some View {
    Toggle(isOn: $isOn) {
      VStack(alignment: .leading, spacing: 4) {
        Text(LocalizedStringKey(title))
          .font(GSTypography.section)
        Text(LocalizedStringKey(detail))
          .font(GSTypography.caption)
          .foregroundStyle(.secondary)
      }
    }
    .toggleStyle(.switch)
  }
}
