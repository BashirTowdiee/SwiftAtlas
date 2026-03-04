import Combine
import Foundation

@MainActor
final class ConcurrencyLabViewModel: ObservableObject {
    @Published var taskGroupMessages: [String] = []
    @Published var cancellationMessages: [String] = []
    @Published var actorCount = 0

    private let counter = ConcurrencyDemoCounter()
    private var demoTask: Task<Void, Never>?

    func runTaskGroupDemo() async {
        taskGroupMessages.removeAll()
        let values = await withTaskGroup(of: String.self, returning: [String].self) { group in
            for index in 1...3 {
                group.addTask {
                    try? await Task.sleep(for: .milliseconds(100 * index))
                    return "TaskGroup child \(index) finished."
                }
            }

            var results: [String] = []
            for await value in group {
                results.append(value)
            }
            return results.sorted()
        }
        taskGroupMessages = values
    }

    func runActorDemo() async {
        actorCount = await counter.increment()
        actorCount = await counter.increment()
        actorCount = await counter.increment()
    }

    func runCancellationDemo() {
        cancellationMessages.removeAll()
        demoTask?.cancel()
        demoTask = Task { [weak self] in
            guard let self else { return }
            self.cancellationMessages.append("Started a cancellable task.")
            do {
                try await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else {
                    self.cancellationMessages.append("Task noticed cancellation before finishing.")
                    return
                }
                self.cancellationMessages.append("Task completed without cancellation.")
            } catch {
                self.cancellationMessages.append("Sleep threw because the task was cancelled.")
            }
        }

        Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(200))
            self?.demoTask?.cancel()
        }
    }
}
