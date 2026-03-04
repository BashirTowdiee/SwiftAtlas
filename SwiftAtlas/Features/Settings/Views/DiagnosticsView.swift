import SwiftUI

struct DiagnosticsView: View {
  let snapshot: DiagnosticsSnapshot?

  var body: some View {
    GSCard {
      VStack(alignment: .leading, spacing: GSSpacing.medium) {
        GSSectionHeader(
          eyebrow: "Diagnostics", title: "Build and runtime metadata",
          detail:
            "Diagnostics should be readable from the app shell without digging through implementation details."
        )
        if let snapshot {
          GSInfoRow(title: "Bundle", value: snapshot.metadata.bundleIdentifier)
          GSInfoRow(title: "Version", value: snapshot.metadata.shortVersion)
          GSInfoRow(title: "Build", value: snapshot.metadata.buildNumber)
          GSInfoRow(title: "Reachability", value: snapshot.reachability.rawValue)
          Text(snapshot.activeFlags.joined(separator: ", "))
            .font(GSTypography.caption)
            .foregroundStyle(.secondary)
        } else {
          Text("Diagnostics are loading.")
        }
      }
    }
  }
}
