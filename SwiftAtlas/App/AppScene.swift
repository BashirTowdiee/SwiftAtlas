import SwiftUI

struct AppScene: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
                }
                .tag(AppTab.home)

            LessonsView()
                .tabItem {
                    Label(AppTab.lessons.title, systemImage: AppTab.lessons.systemImage)
                }
                .tag(AppTab.lessons)

            LabsView()
                .tabItem {
                    Label(AppTab.labs.title, systemImage: AppTab.labs.systemImage)
                }
                .tag(AppTab.labs)

            SettingsView()
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage)
                }
                .tag(AppTab.settings)
        }
        .overlay(alignment: .top) {
            if let notice = appState.notices.last {
                GSBadge(title: notice.message, tone: notice.tone)
                    .padding(.top, 8)
            }
        }
    }
}
