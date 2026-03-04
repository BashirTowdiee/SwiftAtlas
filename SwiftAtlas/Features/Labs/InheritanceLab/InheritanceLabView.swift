import SwiftUI

struct InheritanceLabView: View {
    private let base = BaseFormatter(prefix: "Base:")
    private let lesson = LessonFormatter(prefix: "Lesson:")
    private let markdown = MarkdownFormatter(prefix: "Markdown:")
    private let debug = DebugFormatter(prefix: "Debug:")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GSSpacing.large) {
                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.small) {
                        GSSectionHeader(eyebrow: "Inheritance", title: "Override control", detail: "Classes are final by default in this repo. Inheritance appears only when it teaches something specific.")
                        Text(base.format("plain output"))
                        Text(lesson.format("capitalized output"))
                        Text(markdown.format("markdown output"))
                        Text(debug.format("instrumented output"))
                    }
                }
                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.small) {
                        Text("Guidance")
                            .font(GSTypography.title)
                        Text("• Prefer protocols or composition for extension points.")
                        Text("• Use `required init` when subclasses must preserve initialization contracts.")
                        Text("• Use `class` members only when overriding is intentional; otherwise prefer `static`.")
                    }
                }
            }
            .padding(GSSpacing.medium)
        }
        .navigationTitle("Inheritance")
    }
}
