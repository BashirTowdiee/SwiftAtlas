import Foundation

protocol FeatureFlagStore {
  func value(for flag: FeatureFlag) -> Bool
  func setOverride(_ value: Bool?, for flag: FeatureFlag)
}
