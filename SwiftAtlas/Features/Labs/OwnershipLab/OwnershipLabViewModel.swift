import Combine
import Foundation

@MainActor
final class OwnershipLabViewModel: ObservableObject {
  @Published var logs: [String] = []

  private var retainCycleExample: RetainCycleExample?
  private var fixedCycleExample: FixedRetainCycleExample?
  private var closureExample: ClosureCaptureExample?

  func runRetainCycleDemo() {
    logs.removeAll()
    retainCycleExample = RetainCycleExample(
      onTeacherDeinit: { [weak self] in
        Task { @MainActor in self?.logs.append("Teacher deallocated.") }
      },
      onSessionDeinit: { [weak self] in
        Task { @MainActor in self?.logs.append("Session deallocated.") }
      }
    )
    logs.append("Created a strong object ↔ object cycle.")
    retainCycleExample?.releaseExternalReferences()
    logs.append("Released external references. No deinit log means the cycle is still alive.")
  }

  func runFixedCycleDemo() {
    logs.removeAll()
    fixedCycleExample = FixedRetainCycleExample(
      onTeacherDeinit: { [weak self] in
        Task { @MainActor in self?.logs.append("Safe teacher deallocated.") }
      },
      onSessionDeinit: { [weak self] in
        Task { @MainActor in self?.logs.append("Safe session deallocated.") }
      }
    )
    logs.append("Created a weak back-reference example.")
    fixedCycleExample?.releaseExternalReferences()
  }

  func runClosureCaptureDemo(useWeakCapture: Bool) {
    logs.removeAll()
    let coordinator = OwnershipCoordinator(onDeinit: { [weak self] in
      Task { @MainActor in self?.logs.append("Coordinator deallocated.") }
    })
    closureExample = ClosureCaptureExample(
      coordinator: coordinator,
      onDeinit: { [weak self] in
        Task { @MainActor in self?.logs.append("Closure owner deallocated.") }
      }
    )
    if useWeakCapture {
      closureExample?.makeWeakCapture()
      logs.append("Configured closure with [weak self].")
    } else {
      closureExample?.makeStrongCapture()
      logs.append("Configured closure with a strong self capture.")
    }
    closureExample = nil
  }

  func cleanupLeaks() {
    retainCycleExample?.breakCycle()
    retainCycleExample = nil
    fixedCycleExample = nil
    closureExample = nil
    logs.append("Manual cleanup executed.")
  }
}
