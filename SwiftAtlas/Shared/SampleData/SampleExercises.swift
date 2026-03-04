import Foundation

enum SampleExercises {
    static let items: [Exercise] = [
        Exercise(id: 1, title: "Sketch a feature boundary", isComplete: false, rationale: "Identify view, view model, repository, and domain types."),
        Exercise(id: 2, title: "Prove a task cancels cleanly", isComplete: true, rationale: "Cancellation is part of correct async behavior."),
        Exercise(id: 3, title: "Refactor a retain cycle", isComplete: false, rationale: "Demonstrate closure capture reasoning with weak references.")
    ]
}
