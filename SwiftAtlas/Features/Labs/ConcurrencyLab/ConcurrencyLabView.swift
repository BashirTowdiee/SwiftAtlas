import SwiftUI

struct ConcurrencyLabView: View {
  @StateObject private var viewModel = ConcurrencyLabViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: GSSpacing.large) {
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.medium) {
            GSSectionHeader(
              eyebrow: "Structured Concurrency", title: "Actors, task groups, and cancellation",
              detail: "The view model is main-actor isolated and the counter is actor-isolated.")
            GSPrimaryButton(title: "Run TaskGroup Demo", systemImage: "square.stack.3d.up.fill") {
              Task { await viewModel.runTaskGroupDemo() }
            }
            GSSecondaryButton(title: "Run Actor Demo") {
              Task { await viewModel.runActorDemo() }
            }
            GSSecondaryButton(title: "Run Cancellation Demo") {
              viewModel.runCancellationDemo()
            }
            GSInfoRow(title: "Actor Count", value: "\(viewModel.actorCount)")
          }
        }
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.small) {
            Text("Task Group")
              .font(GSTypography.title)
            ForEach(viewModel.taskGroupMessages, id: \.self) { line in
              Text(line)
                .font(GSTypography.mono)
            }
          }
        }
        GSCard {
          VStack(alignment: .leading, spacing: GSSpacing.small) {
            Text("Cancellation")
              .font(GSTypography.title)
            ForEach(viewModel.cancellationMessages, id: \.self) { line in
              Text(line)
                .font(GSTypography.mono)
            }
          }
        }
      }
      .padding(GSSpacing.medium)
    }
    .navigationTitle("Concurrency")
  }
}
