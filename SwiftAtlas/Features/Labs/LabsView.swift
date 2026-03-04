import SwiftUI

struct LabsView: View {
    private let labs: [LabTopic] = [
        LabTopic(id: "components", title: "Components Lab", summary: "Shared buttons, cards, badges, and async state views.", symbol: "square.grid.2x2.fill"),
        LabTopic(id: "theme", title: "Theme Lab", summary: "Semantic colors, typography, spacing, and dark mode.", symbol: "paintpalette.fill"),
        LabTopic(id: "modal", title: "Modal Lab", summary: "Sheet, full screen, alert, and confirmation dialog patterns.", symbol: "rectangle.3.group.fill"),
        LabTopic(id: "ownership", title: "Ownership Lab", summary: "ARC, retain cycles, weak, unowned, and closure capture examples.", symbol: "link.badge.plus"),
        LabTopic(id: "inheritance", title: "Inheritance Lab", summary: "Final-by-default, override control, required initializers, and class vs static.", symbol: "arrow.triangle.branch"),
        LabTopic(id: "access", title: "Access Control Lab", summary: "private, fileprivate, internal, public, open, and special identifiers.", symbol: "key.fill"),
        LabTopic(id: "concurrency", title: "Concurrency Lab", summary: "Task cancellation, actor isolation, task groups, and main-actor UI.", symbol: "bolt.fill")
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(labs) { lab in
                    NavigationLink {
                        destination(for: lab.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Label(lab.title, systemImage: lab.symbol)
                                .font(GSTypography.section)
                            Text(lab.summary)
                                .font(GSTypography.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Labs")
        }
    }

    @ViewBuilder
    private func destination(for id: String) -> some View {
        switch id {
        case "components":
            ComponentsLabView()
        case "theme":
            ThemeLabView()
        case "modal":
            ModalLabView()
        case "ownership":
            OwnershipLabView()
        case "inheritance":
            InheritanceLabView()
        case "access":
            AccessControlLabView()
        default:
            ConcurrencyLabView()
        }
    }
}

struct LabsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            LabsView()
        }
    }
}
