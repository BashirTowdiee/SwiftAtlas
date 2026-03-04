import SwiftUI

struct LabsView: View {
  private let labs: [LabTopic] = [
    LabTopic(
      id: "components", title: String(localized: "Components Lab"),
      summary: String(localized: "Shared buttons, cards, badges, and async state views."),
      symbol: "square.grid.2x2.fill"),
    LabTopic(
      id: "theme", title: String(localized: "Theme Lab"),
      summary: String(localized: "Semantic colors, typography, spacing, and dark mode."),
      symbol: "paintpalette.fill"),
    LabTopic(
      id: "modal", title: String(localized: "Modal Lab"),
      summary: String(localized: "Sheet, full screen, alert, and confirmation dialog patterns."),
      symbol: "rectangle.3.group.fill"),
    LabTopic(
      id: "ownership", title: String(localized: "Ownership Lab"),
      summary: String(
        localized: "ARC, retain cycles, weak, unowned, and closure capture examples."),
      symbol: "link.badge.plus"),
    LabTopic(
      id: "inheritance", title: String(localized: "Inheritance Lab"),
      summary: String(
        localized: "Final-by-default, override control, required initializers, and class vs static."
      ), symbol: "arrow.triangle.branch"),
    LabTopic(
      id: "access", title: String(localized: "Access Control Lab"),
      summary: String(
        localized: "private, fileprivate, internal, public, open, and special identifiers."),
      symbol: "key.fill"),
    LabTopic(
      id: "concurrency", title: String(localized: "Concurrency Lab"),
      summary: String(
        localized: "Task cancellation, actor isolation, task groups, and main-actor UI."),
      symbol: "bolt.fill"),
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
          .accessibilityIdentifier("labs.row.\(lab.id)")
        }
      }
      .navigationTitle("Labs")
      .accessibilityIdentifier("labs.screen")
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
    Group {
      PreviewContainer {
        LabsView()
      }
      .previewDisplayName("Default")

      PreviewContainer {
        LabsView()
          .environment(\.dynamicTypeSize, .accessibility3)
      }
      .previewDisplayName("Accessibility")

      PreviewContainer {
        LabsView()
      }
      .preferredColorScheme(.dark)
      .previewDisplayName("Dark Mode")
    }
  }
}
