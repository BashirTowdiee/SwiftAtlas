import SwiftUI

struct ComponentsLabView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: GSSpacing.large) {
        GSSectionHeader(
          eyebrow: "Components", title: "Reusable surfaces",
          detail: "These components are intentionally simple so their composition remains visible.")
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.medium) {
            Text("Buttons")
              .font(GSTypography.title)
            GSPrimaryButton(title: "Primary Action", systemImage: "sparkles") {}
            GSSecondaryButton(title: "Secondary Action") {}
          }
        }
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.medium) {
            Text("Status")
              .font(GSTypography.title)
            HStack {
              GSBadge(title: "Info", tone: .info)
              GSBadge(title: "Success", tone: .success)
              GSBadge(title: "Warning", tone: .warning)
              GSBadge(title: "Error", tone: .error)
            }
            GSErrorView(
              error: .network("The component accepts an `AppError` and optionally a retry action."),
              retry: nil)
          }
        }
      }
      .padding(GSSpacing.medium)
    }
    .navigationTitle("Components")
  }
}
