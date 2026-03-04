import SwiftUI

struct LessonDetailView: View {
    let lessonID: Lesson.ID

    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel = LessonDetailViewModel()

    var body: some View {
        ScrollView {
            GSAsyncStateView(state: viewModel.state, retry: {
                Task { await viewModel.load() }
            }) { model, _ in
                VStack(alignment: .leading, spacing: GSSpacing.large) {
                    GSCard {
                        VStack(alignment: .leading, spacing: GSSpacing.medium) {
                            GSSectionHeader(
                                eyebrow: model.detail.lesson.track.title,
                                title: model.detail.lesson.title,
                                detail: model.detail.lesson.summary
                            )
                            Text(model.detail.lesson.body)
                                .font(GSTypography.body)
                            GSInfoRow(title: "Mentor", value: model.detail.lesson.owner.name)
                            GSInfoRow(title: "Handle", value: model.detail.lesson.owner.handle)
                        }
                    }

                    GSCard {
                        VStack(alignment: .leading, spacing: GSSpacing.small) {
                            GSSectionHeader(eyebrow: "Teaching Points", title: "Why this lesson matters", detail: nil)
                            ForEach(model.detail.teachingPoints, id: \.self) { point in
                                Text("• \(point)")
                            }
                        }
                    }

                    ExerciseListSection(exercises: model.exercises)

                    GSCard {
                        VStack(alignment: .leading, spacing: GSSpacing.small) {
                            GSSectionHeader(eyebrow: "Discussion", title: "Mapped comments", detail: "These are JSONPlaceholder comments mapped into lesson discussion.")
                            ForEach(model.detail.comments.prefix(4)) { comment in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(comment.author)
                                        .font(GSTypography.section)
                                    Text(comment.body)
                                        .font(GSTypography.body)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.bottom, GSSpacing.small)
                            }
                        }
                    }
                }
                .padding(GSSpacing.medium)
            }
        }
        .navigationTitle("Lesson Detail")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("lessonDetail.screen")
        .task {
            await viewModel.bind(container: container, lessonID: lessonID)
        }
    }
}

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            NavigationStack {
                LessonDetailView(lessonID: 1)
            }
        }
    }
}
