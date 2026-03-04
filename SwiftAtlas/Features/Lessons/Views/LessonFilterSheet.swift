import SwiftUI

struct LessonFilterSheet: View {
    @ObservedObject var viewModel: LessonListViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Track") {
                    Picker("Track", selection: $viewModel.selectedTrackID) {
                        Text("All tracks").tag(Int?.none)
                        ForEach(viewModel.availableTracks) { track in
                            Text(track.title).tag(Int?.some(track.id))
                        }
                    }
                }

                Section("Display") {
                    Toggle("Pinned only", isOn: $viewModel.showPinnedOnly)
                }
            }
            .navigationTitle("Filters")
            .accessibilityIdentifier("lessons.filterSheet")
        }
    }
}
