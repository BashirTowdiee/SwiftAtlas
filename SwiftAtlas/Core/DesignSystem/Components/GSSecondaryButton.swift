import SwiftUI

struct GSSecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(.plain)
            .font(GSTypography.section)
            .padding(.horizontal, GSSpacing.medium)
            .padding(.vertical, GSSpacing.small)
            .background(Color.secondary.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
