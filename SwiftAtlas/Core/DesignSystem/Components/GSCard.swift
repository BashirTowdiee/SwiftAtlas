import SwiftUI

struct GSCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let palette = ThemeResolver.palette(for: colorScheme)
        content
            .padding(GSSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(palette.primaryText.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: palette.primaryText.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}
