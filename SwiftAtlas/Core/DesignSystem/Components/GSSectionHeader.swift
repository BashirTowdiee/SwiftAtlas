import SwiftUI

struct GSSectionHeader: View {
    let eyebrow: String
    let title: String
    let detail: String?

    var body: some View {
        VStack(alignment: .leading, spacing: GSSpacing.xSmall) {
            Text(eyebrow.uppercased())
                .font(GSTypography.caption)
                .foregroundStyle(.secondary)
            Text(title)
                .font(GSTypography.title)
            if let detail {
                Text(detail)
                    .font(GSTypography.body)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
