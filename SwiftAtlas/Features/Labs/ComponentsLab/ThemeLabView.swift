import SwiftUI

struct ThemeLabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        let palette = ThemeResolver.palette(for: colorScheme)
        ScrollView {
            VStack(alignment: .leading, spacing: GSSpacing.large) {
                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.medium) {
                        GSSectionHeader(eyebrow: "Theme", title: "Semantic token mapping", detail: "Feature views never hardcode palette values; they ask the theme layer for meaning.")
                        GSInfoRow(title: "Current Override", value: appState.themeOption.title)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: GSSpacing.small) {
                            colorSwatch(title: "Background", color: palette.background)
                            colorSwatch(title: "Surface", color: palette.surface)
                            colorSwatch(title: "Accent", color: palette.accent)
                            colorSwatch(title: "Accent 2", color: palette.accentSecondary)
                            colorSwatch(title: "Success", color: palette.success)
                            colorSwatch(title: "Error", color: palette.error)
                        }
                    }
                }
            }
            .padding(GSSpacing.medium)
        }
        .navigationTitle("Theme")
    }

    @Environment(\.colorScheme) private var colorScheme

    private func colorSwatch(title: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(color)
                .frame(height: 100)
            Text(title)
                .font(GSTypography.section)
        }
    }
}
