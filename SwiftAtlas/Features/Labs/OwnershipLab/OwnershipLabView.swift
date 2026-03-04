import SwiftUI

struct OwnershipLabView: View {
    @StateObject private var viewModel = OwnershipLabViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GSSpacing.large) {
                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.medium) {
                        GSSectionHeader(eyebrow: "ARC", title: "Retain cycles", detail: "Run each demo, then inspect the log. Missing deinit messages point at a retained object graph.")
                        GSPrimaryButton(title: "Run Object Cycle", systemImage: "link") {
                            viewModel.runRetainCycleDemo()
                        }
                        GSSecondaryButton(title: "Run Weak Back Reference") {
                            viewModel.runFixedCycleDemo()
                        }
                        GSSecondaryButton(title: "Run Strong Closure Capture") {
                            viewModel.runClosureCaptureDemo(useWeakCapture: false)
                        }
                        GSSecondaryButton(title: "Run Weak Closure Capture") {
                            viewModel.runClosureCaptureDemo(useWeakCapture: true)
                        }
                        GSSecondaryButton(title: "Cleanup") {
                            viewModel.cleanupLeaks()
                        }
                    }
                }

                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.small) {
                        Text("Runtime Log")
                            .font(GSTypography.title)
                        ForEach(Array(viewModel.logs.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(GSTypography.mono)
                        }
                    }
                }
            }
            .padding(GSSpacing.medium)
        }
        .navigationTitle("Ownership")
    }
}
