import SwiftUI

struct FeatureFlagsView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(eyebrow: "Flags", title: "Feature overrides", detail: "Flags default in code, then opt into local debug overrides.")
                ForEach(FeatureFlag.allCases) { flag in
                    let isOn = Binding(
                        get: { viewModel.flagValues[flag] ?? flag.defaultValue },
                        set: { viewModel.setFlag(flag, to: $0) }
                    )
                    GSToggleRow(title: flag.title, detail: flag.explanation, isOn: isOn)
                    Button("Reset \(flag.title) to default") {
                        viewModel.clearFlagOverride(flag)
                    }
                    .font(GSTypography.caption)
                }
            }
        }
    }
}
