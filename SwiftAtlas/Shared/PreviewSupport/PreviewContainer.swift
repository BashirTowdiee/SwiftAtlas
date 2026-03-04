import SwiftUI

struct PreviewContainer<Content: View>: View {
    private let container: AppContainer
    private let content: Content

    init(
        container: AppContainer = PreviewAppContainer.makePreviewContainer(),
        @ViewBuilder content: () -> Content
    ) {
        self.container = container
        self.content = content()
    }

    var body: some View {
        content
            .environmentObject(container)
            .environmentObject(container.appState)
            .preferredColorScheme(container.appState.preferredColorScheme)
    }
}
