import SwiftUI

struct GSPrimaryButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if let systemImage {
                    Label(title, systemImage: systemImage)
                } else {
                    Text(title)
                }
            }
            .font(GSTypography.section)
            .frame(maxWidth: .infinity)
            .padding(.vertical, GSSpacing.small)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, GSSpacing.medium)
        .padding(.vertical, GSSpacing.small)
        .background(GSColorTokens.sunrise)
        .foregroundStyle(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
