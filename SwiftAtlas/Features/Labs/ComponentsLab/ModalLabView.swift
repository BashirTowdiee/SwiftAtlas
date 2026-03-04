import SwiftUI

struct ModalLabView: View {
  @State private var isSheetPresented = false
  @State private var isFullScreenPresented = false
  @State private var isAlertPresented = false
  @State private var isDialogPresented = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: GSSpacing.medium) {
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.medium) {
            GSSectionHeader(
              eyebrow: "Modals", title: "Presentation rules",
              detail: "Choose the smallest presentation mechanism that matches the task.")
            GSPrimaryButton(
              title: "Show Sheet", systemImage: "rectangle.portrait.bottomhalf.inset.filled"
            ) {
              isSheetPresented = true
            }
            GSSecondaryButton(title: "Show Full Screen") {
              isFullScreenPresented = true
            }
            GSSecondaryButton(title: "Show Alert") {
              isAlertPresented = true
            }
            GSSecondaryButton(title: "Show Confirmation Dialog") {
              isDialogPresented = true
            }
          }
        }
      }
      .padding(GSSpacing.medium)
    }
    .navigationTitle("Modals")
    .sheet(isPresented: $isSheetPresented) {
      NavigationStack {
        Text("Sheets are a good fit for filters, editors, and focused secondary tasks.")
          .padding()
          .navigationTitle("Sheet")
      }
    }
    .fullScreenCover(isPresented: $isFullScreenPresented) {
      ZStack {
        ThemeResolver.palette(for: colorScheme).background.ignoresSafeArea()
        VStack(spacing: 20) {
          Text("Full-screen cover")
            .font(GSTypography.hero)
          GSPrimaryButton(title: "Dismiss", systemImage: "xmark") {
            isFullScreenPresented = false
          }
        }
        .padding()
      }
    }
    .alert("Alerts are for short, blocking decisions.", isPresented: $isAlertPresented) {
      Button("OK", role: .cancel) {}
    }
    .confirmationDialog("Choose a presentation explanation", isPresented: $isDialogPresented) {
      Button("Document the choice in code") {}
      Button("Keep the flow lightweight") {}
    }
  }

  @Environment(\.colorScheme) private var colorScheme
}
