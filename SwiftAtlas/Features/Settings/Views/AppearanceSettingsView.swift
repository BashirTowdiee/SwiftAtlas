import SwiftUI

struct AppearanceSettingsView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(eyebrow: "Appearance", title: "Theme override", detail: "Use the app state to resolve system, light, and dark modes globally.")
                Picker("Theme", selection: Binding(get: {
                    appState.themeOption
                }, set: { newValue in
                    appState.setThemeOption(newValue)
                })) {
                    ForEach(ThemeOption.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}
