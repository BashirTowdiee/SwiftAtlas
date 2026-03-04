import SwiftUI

struct GSAsyncStateView<Value, Content: View>: View {
  let state: LoadableState<Value>
  let retry: (() -> Void)?
  let content: (Value, Bool) -> Content

  init(
    state: LoadableState<Value>,
    retry: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Value, Bool) -> Content
  ) {
    self.state = state
    self.retry = retry
    self.content = content
  }

  var body: some View {
    switch state {
    case .idle, .loading:
      VStack(spacing: GSSpacing.small) {
        GSSkeletonBlock(height: 20)
        GSSkeletonBlock(height: 18)
        GSSkeletonBlock(height: 18)
      }
    case .failed(let error):
      GSErrorView(error: error, retry: retry)
    case .loaded(let value, let isStale):
      content(value, isStale)
    }
  }
}
