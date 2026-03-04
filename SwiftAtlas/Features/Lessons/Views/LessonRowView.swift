import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    let isPinned: Bool
    let onTogglePin: () -> Void

    var body: some View {
        GSCard {
            VStack(alignment: .leading, spacing: GSSpacing.small) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: GSSpacing.xSmall) {
                        Text(lesson.title)
                            .font(GSTypography.title)
                        Text(lesson.summary)
                            .font(GSTypography.body)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(action: onTogglePin) {
                        Image(systemName: isPinned ? "pin.fill" : "pin")
                            .foregroundStyle(GSColorTokens.coral)
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    GSBadge(title: lesson.track.title, tone: .info)
                    Text(lesson.owner.name)
                        .font(GSTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
