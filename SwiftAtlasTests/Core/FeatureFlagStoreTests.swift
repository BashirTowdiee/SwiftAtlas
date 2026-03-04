import Foundation
import Testing

@testable import SwiftAtlas

struct FeatureFlagStoreTests {
  @Test
  func returnsDefaultWhenNoOverrideExists() {
    let defaults = UserDefaults(suiteName: "FeatureFlagStoreTests-\(UUID().uuidString)")!
    let store = UserDefaultsFeatureFlagStore(defaults: defaults)

    #expect(store.value(for: .labsEnabled) == true)
  }

  @Test
  func persistsOverride() {
    let defaults = UserDefaults(suiteName: "FeatureFlagStoreTests-\(UUID().uuidString)")!
    let store = UserDefaultsFeatureFlagStore(defaults: defaults)

    store.setOverride(false, for: .advancedDiagnosticsEnabled)

    #expect(store.value(for: .advancedDiagnosticsEnabled) == false)
  }
}
