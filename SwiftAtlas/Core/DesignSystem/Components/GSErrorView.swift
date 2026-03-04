import SwiftUI

struct GSErrorView: View {
  let error: AppError
  let retry: (() -> Void)?

  var body: some View {
    GSCard {
      VStack(alignment: .leading, spacing: GSSpacing.medium) {
        Label {
          Text(LocalizedStringKey(error.title))
        } icon: {
          Image(systemName: "exclamationmark.triangle.fill")
        }
        .font(GSTypography.title)
        .foregroundStyle(.red)
        Text(error.message)
          .font(GSTypography.body)
        if let retry {
          GSPrimaryButton(title: "Retry", systemImage: "arrow.clockwise", action: retry)
        }
      }
    }
  }
}
