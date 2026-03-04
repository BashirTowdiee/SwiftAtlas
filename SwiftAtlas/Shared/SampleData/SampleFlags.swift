import Foundation

enum SampleFlags {
    static let allEnabled = FeatureFlag.allCases.reduce(into: [FeatureFlag: Bool]()) { partialResult, flag in
        partialResult[flag] = true
    }
}
