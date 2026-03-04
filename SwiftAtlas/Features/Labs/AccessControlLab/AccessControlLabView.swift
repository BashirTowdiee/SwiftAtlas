import SwiftUI

struct AccessControlLabView: View {
  private let examples = AccessControlGuide().examples()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: GSSpacing.medium) {
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.small) {
            GSSectionHeader(
              eyebrow: "Access Control", title: "Visibility and special identifiers",
              detail:
                "The examples here are backed by real Swift declarations, not text-only notes.")
            ForEach(examples, id: \.self) { example in
              Text(example)
                .font(GSTypography.body)
            }
          }
        }
      }
      .padding(GSSpacing.medium)
    }
    .navigationTitle("Access Control")
  }
}
