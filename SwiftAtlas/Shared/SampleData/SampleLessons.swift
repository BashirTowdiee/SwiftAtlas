import Foundation

enum SampleLessons {
    static let owners = [
        TrackOwner(id: 1, name: "Ava Metrics", handle: "@avametrics", headline: "Architecture mentor", email: "ava@example.com"),
        TrackOwner(id: 2, name: "Noah Signals", handle: "@noahsignals", headline: "Concurrency mentor", email: "noah@example.com")
    ]

    static let tracks = [
        Track(id: 1, title: "Architecture", summary: "MVVM, app state, data flow, and boundaries."),
        Track(id: 2, title: "Runtime", summary: "Concurrency, memory ownership, and structured tasks.")
    ]

    static let lessons: [Lesson] = [
        Lesson(id: 1, title: "Build a disciplined MVVM surface", summary: "A feature should expose a small observable state surface.", body: "Value types are easiest to reason about. Repositories map foreign data into app-owned models. Views should be declarative.", track: tracks[0], owner: owners[0]),
        Lesson(id: 2, title: "Use repositories as translation boundaries", summary: "Never let DTOs leak into rendering code.", body: "Transport types should stop at the data layer. Your app models should read like product language.", track: tracks[0], owner: owners[0]),
        Lesson(id: 3, title: "Control tasks and cancellation", summary: "Structured concurrency is easiest to debug.", body: "Search should cancel stale tasks. UI-facing state belongs on the main actor.", track: tracks[1], owner: owners[1])
    ]

    static let groups: [LessonGroup] = [
        LessonGroup(id: "Architecture", title: "Architecture", subtitle: "Ava Metrics", lessons: Array(lessons.prefix(2))),
        LessonGroup(id: "Runtime", title: "Runtime", subtitle: "Noah Signals", lessons: [lessons[2]])
    ]
}
