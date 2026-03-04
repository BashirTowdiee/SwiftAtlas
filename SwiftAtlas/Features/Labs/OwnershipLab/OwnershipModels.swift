import Foundation

final class Teacher {
    let name: String
    var session: LessonSession?
    private let onDeinit: @Sendable () -> Void

    init(name: String, onDeinit: @escaping @Sendable () -> Void) {
        self.name = name
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}

final class LessonSession {
    let title: String
    var teacher: Teacher?
    private let onDeinit: @Sendable () -> Void

    init(title: String, onDeinit: @escaping @Sendable () -> Void) {
        self.title = title
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}

final class SafeLessonSession {
    let title: String
    weak var teacher: Teacher?
    private let onDeinit: @Sendable () -> Void

    init(title: String, onDeinit: @escaping @Sendable () -> Void) {
        self.title = title
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}

final class RetainCycleExample {
    var teacher: Teacher?
    var session: LessonSession?

    init(onTeacherDeinit: @escaping @Sendable () -> Void, onSessionDeinit: @escaping @Sendable () -> Void) {
        let teacher = Teacher(name: "Cycle Teacher", onDeinit: onTeacherDeinit)
        let session = LessonSession(title: "Cycle Session", onDeinit: onSessionDeinit)
        teacher.session = session
        session.teacher = teacher
        self.teacher = teacher
        self.session = session
    }

    func releaseExternalReferences() {
        teacher = nil
        session = nil
    }

    func breakCycle() {
        teacher?.session = nil
        session?.teacher = nil
        teacher = nil
        session = nil
    }
}

final class FixedRetainCycleExample {
    var teacher: Teacher?
    var session: SafeLessonSession?

    init(onTeacherDeinit: @escaping @Sendable () -> Void, onSessionDeinit: @escaping @Sendable () -> Void) {
        let teacher = Teacher(name: "Safe Teacher", onDeinit: onTeacherDeinit)
        let session = SafeLessonSession(title: "Safe Session", onDeinit: onSessionDeinit)
        teacher.session = nil
        session.teacher = teacher
        self.teacher = teacher
        self.session = session
    }

    func releaseExternalReferences() {
        teacher = nil
        session = nil
    }
}

final class OwnershipCoordinator {
    var onComplete: (() -> Void)?
    private let onDeinit: @Sendable () -> Void

    init(onDeinit: @escaping @Sendable () -> Void) {
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}

final class ClosureCaptureExample {
    let coordinator: OwnershipCoordinator
    private let onDeinit: @Sendable () -> Void

    init(coordinator: OwnershipCoordinator, onDeinit: @escaping @Sendable () -> Void) {
        self.coordinator = coordinator
        self.onDeinit = onDeinit
    }

    func makeStrongCapture() {
        coordinator.onComplete = {
            _ = self.coordinator
        }
    }

    func makeWeakCapture() {
        coordinator.onComplete = { [weak self] in
            _ = self?.coordinator
        }
    }

    deinit {
        onDeinit()
    }
}
