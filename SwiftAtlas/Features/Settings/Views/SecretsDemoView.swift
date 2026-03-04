import SwiftUI

struct SecretsDemoView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(eyebrow: "Secrets", title: "Keychain demo", detail: "Use this screen to learn why secrets do not belong in UserDefaults or source control.")
                TextField("Enter a demo token", text: $viewModel.secretDraft)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.secretStatus)
                    .font(GSTypography.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    GSPrimaryButton(title: "Save", systemImage: "key.fill") {
                        viewModel.saveSecret()
                    }
                    GSSecondaryButton(title: "Delete") {
                        viewModel.deleteSecret()
                    }
                }
            }
        }
    }
}
