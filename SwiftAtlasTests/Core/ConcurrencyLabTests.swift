import Foundation
import Testing
@testable import SwiftAtlas

struct ConcurrencyLabTests {
    @MainActor
    @Test
    func taskGroupAndActorDemosProduceExpectedState() async {
        let viewModel = ConcurrencyLabViewModel()

        await viewModel.runTaskGroupDemo()
        await viewModel.runActorDemo()

        #expect(viewModel.taskGroupMessages.count == 3)
        #expect(viewModel.actorCount == 3)
    }

    @MainActor
    @Test
    func cancellationDemoRecordsCancellation() async throws {
        let viewModel = ConcurrencyLabViewModel()

        viewModel.runCancellationDemo()
        try await Task.sleep(for: .milliseconds(400))

        #expect(viewModel.cancellationMessages.contains { $0.contains("cancel") || $0.contains("Sleep threw") })
    }
}
