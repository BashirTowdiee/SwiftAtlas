import SwiftUI

struct CacheInspectorView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(eyebrow: "Caching", title: "Cache inspector", detail: "The cache is intentionally simple: JSON files for persistence and explicit policy choices in repositories.")
                if let diagnostics = viewModel.diagnostics {
                    GSInfoRow(title: "Cache Path", value: diagnostics.cacheLocation)
                }
                GSSecondaryButton(title: "Clear Cache") {
                    viewModel.clearCache()
                }
            }
        }
    }
}
