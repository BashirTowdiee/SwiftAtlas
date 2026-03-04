import Foundation

final class UserDefaultsFeatureFlagStore: FeatureFlagStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func value(for flag: FeatureFlag) -> Bool {
        guard defaults.object(forKey: key(for: flag)) != nil else {
            return flag.defaultValue
        }
        return defaults.bool(forKey: key(for: flag))
    }

    func setOverride(_ value: Bool?, for flag: FeatureFlag) {
        let key = key(for: flag)
        guard let value else {
            defaults.removeObject(forKey: key)
            return
        }
        defaults.set(value, forKey: key)
    }

    private func key(for flag: FeatureFlag) -> String {
        "feature.flag.\(flag.rawValue)"
    }
}
