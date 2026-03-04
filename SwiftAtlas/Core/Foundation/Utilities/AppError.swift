import Foundation

enum AppError: Error, Equatable, Sendable {
    case network(String)
    case decoding(String)
    case storage(String)
    case security(String)
    case validation(String)
    case unavailable(String)
    case cancelled

    init(error: Error) {
        if error is CancellationError {
            self = .cancelled
        } else {
            self = .unavailable(error.localizedDescription)
        }
    }

    var title: String {
        switch self {
        case .network: "Network Error"
        case .decoding: "Decoding Error"
        case .storage: "Storage Error"
        case .security: "Security Error"
        case .validation: "Validation Error"
        case .unavailable: "Unavailable"
        case .cancelled: "Cancelled"
        }
    }

    var message: String {
        switch self {
        case let .network(message),
            let .decoding(message),
            let .storage(message),
            let .security(message),
            let .validation(message),
            let .unavailable(message):
            message
        case .cancelled:
            "The current task was cancelled before it finished."
        }
    }
}
