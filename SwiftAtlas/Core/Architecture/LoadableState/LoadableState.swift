import Foundation

enum LoadableState<Value> {
    case idle
    case loading
    case loaded(Value, isStale: Bool = false)
    case failed(AppError)

    var value: Value? {
        switch self {
        case let .loaded(value, _): value
        default: nil
        }
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
