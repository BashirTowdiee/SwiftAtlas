import Foundation

struct BuildMetadata: Hashable, Sendable {
    let bundleIdentifier: String
    let shortVersion: String
    let buildNumber: String

    static var current: BuildMetadata {
        BuildMetadata(
            bundleIdentifier: Bundle.main.bundleIdentifier ?? "org.example.SwiftAtlas",
            shortVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0",
            buildNumber: Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
        )
    }
}
