import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: GSSpacing.large) {
                    heroCard
                    learningPathCard
                    architectureCard
                    diagnosticsCard
                }
                .padding(GSSpacing.medium)
            }
            .navigationTitle("Swift Atlas")
            .background(ThemeResolver.palette(for: colorScheme).background.ignoresSafeArea())
            .task {
                viewModel.bind(container: container)
            }
        }
    }

    @Environment(\.colorScheme) private var colorScheme

    private var heroCard: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                Text("Learn Swift by reading code that treats architecture as part of the lesson.")
                    .font(GSTypography.hero)
                Text("Every tab demonstrates a different layer of a serious SwiftUI app: app shell, design system, data flow, caching, memory ownership, and concurrency.")
                    .font(GSTypography.body)
                    .foregroundStyle(.secondary)
                HStack(spacing: GSSpacing.small) {
                    GSPrimaryButton(title: "Open Lessons", systemImage: "books.vertical.fill") {
                        appState.selectedTab = .lessons
                    }
                    GSSecondaryButton(title: "Open Labs") {
                        appState.selectedTab = .labs
                    }
                }
            }
        }
    }

    private var learningPathCard: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(
                    eyebrow: "Learning Path",
                    title: "What this app teaches",
                    detail: "The project is organized so the folder tree mirrors the ideas you are trying to learn."
                )
                ForEach([
                    "MVVM, folder structure, global vs local state",
                    "Theme tokens, components, lists, groups, modals",
                    "Data fetching, caching, previews, tests, and feature flags",
                    "ARC, retain cycles, inheritance, access control, and concurrency"
                ], id: \.self) { item in
                    Label(item, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(GSColorTokens.mint)
                }
            }
        }
    }

    private var architectureCard: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(
                    eyebrow: "Architecture",
                    title: "Reference rules you can copy",
                    detail: "These are deliberately opinionated so the code reads like a standard, not a sketch."
                )
                ForEach(viewModel.architectureHighlights, id: \.self) { point in
                    Text("• \(point)")
                        .font(GSTypography.body)
                }
            }
        }
    }

    private var diagnosticsCard: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.medium) {
                GSSectionHeader(
                    eyebrow: "Diagnostics",
                    title: "App-wide state summary",
                    detail: "Home surfaces the shared state that the whole app cares about."
                )
                GSInfoRow(title: "Theme", value: container.appState.themeOption.title)
                GSInfoRow(title: "Reachability", value: container.appState.reachability.rawValue.capitalized)
                GSInfoRow(title: "Enabled Flags", value: "\(viewModel.activeFlags.count)")
                if let diagnostics = viewModel.diagnostics {
                    GSInfoRow(title: "Bundle", value: diagnostics.metadata.bundleIdentifier)
                    GSInfoRow(title: "Version", value: "\(diagnostics.metadata.shortVersion) (\(diagnostics.metadata.buildNumber))")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            HomeView()
        }
    }
}
