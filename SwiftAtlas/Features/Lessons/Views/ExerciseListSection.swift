import SwiftUI

struct ExerciseListSection: View {
    let exercises: [Exercise]

    var body: some View {
        VStack(alignment: .leading, spacing: GSSpacing.small) {
            GSSectionHeader(
                eyebrow: "Exercises",
                title: "Practice the lesson",
                detail: "Exercises are deterministic fixtures mapped from the remote lesson id so the app stays predictable."
            )
            ForEach(exercises) { exercise in
                GSCard {
                    VStack(alignment: .leading, spacing: GSSpacing.xSmall) {
                        HStack {
                            Text(exercise.title)
                                .font(GSTypography.section)
                            Spacer()
                            GSBadge(title: exercise.isComplete ? "Done" : "Open", tone: exercise.isComplete ? .success : .warning)
                        }
                        Text(exercise.rationale)
                            .font(GSTypography.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
