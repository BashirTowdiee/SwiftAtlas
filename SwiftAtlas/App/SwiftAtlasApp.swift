import SwiftUI

@main
struct SwiftAtlasApp: App {
  @StateObject private var container = PreviewAppContainer.makeLiveContainer()

  var body: some Scene {
    WindowGroup {
      AppScene()
        .environmentObject(container)
        .environmentObject(container.appState)
        .preferredColorScheme(container.appState.preferredColorScheme)
    }
  }
}
