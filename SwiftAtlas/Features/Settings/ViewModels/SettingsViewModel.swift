import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
  @Published var secretDraft = ""
  @Published var secretStatus = String(localized: "No demo token saved.")
  @Published var diagnostics: DiagnosticsSnapshot?
  @Published var flagValues: [FeatureFlag: Bool] = [:]

  private var featureFlagStore: FeatureFlagStore?
  private var secretsStore: SecretsStore?
  private var cacheStore: CacheStore?
  private var diagnosticsService: DiagnosticsService?
  private weak var appState: AppState?
  private let usesPreviewState: Bool

  init(usesPreviewState: Bool = false) {
    self.usesPreviewState = usesPreviewState
  }

  init(
    previewSecretDraft: String = "",
    previewSecretStatus: String = String(localized: "No demo token saved."),
    previewDiagnostics: DiagnosticsSnapshot? = nil,
    previewFlagValues: [FeatureFlag: Bool] = [:]
  ) {
    secretDraft = previewSecretDraft
    secretStatus = previewSecretStatus
    diagnostics = previewDiagnostics
    flagValues = previewFlagValues
    usesPreviewState = true
  }

  func bind(container: AppContainer) {
    guard !usesPreviewState else { return }
    featureFlagStore = container.featureFlagStore
    secretsStore = container.secretsStore
    cacheStore = container.cacheStore
    diagnosticsService = container.diagnosticsService
    appState = container.appState
    reload()
  }

  func reload() {
    guard let featureFlagStore, let diagnosticsService, let appState else { return }

    flagValues = FeatureFlag.allCases.reduce(into: [FeatureFlag: Bool]()) { partialResult, flag in
      partialResult[flag] = featureFlagStore.value(for: flag)
    }
    diagnostics = diagnosticsService.makeSnapshot(
      theme: appState.themeOption, reachability: appState.reachability)

    do {
      if let saved = try secretsStore?.readValue(for: .demoAPIToken), !saved.isEmpty {
        secretStatus = String(format: String(localized: "Stored token: %@"), saved)
      } else {
        secretStatus = String(localized: "No demo token saved.")
      }
    } catch {
      secretStatus = String(
        format: String(localized: "Unable to read token: %@"), error.localizedDescription)
    }
  }

  func setFlag(_ flag: FeatureFlag, to newValue: Bool) {
    featureFlagStore?.setOverride(newValue, for: flag)
    flagValues[flag] = newValue
    reload()
  }

  func clearFlagOverride(_ flag: FeatureFlag) {
    featureFlagStore?.setOverride(nil, for: flag)
    reload()
  }

  func saveSecret() {
    guard !secretDraft.isEmpty else {
      secretStatus = String(localized: "Enter a token before saving.")
      return
    }

    do {
      try secretsStore?.writeValue(secretDraft, for: .demoAPIToken)
      secretStatus = String(format: String(localized: "Stored token: %@"), secretDraft)
    } catch {
      secretStatus = String(
        format: String(localized: "Failed to save token: %@"), error.localizedDescription)
    }
  }

  func deleteSecret() {
    do {
      try secretsStore?.deleteValue(for: .demoAPIToken)
      secretStatus = String(localized: "No demo token saved.")
      secretDraft = ""
    } catch {
      secretStatus = String(
        format: String(localized: "Failed to delete token: %@"), error.localizedDescription)
    }
  }

  func clearCache() {
    do {
      try cacheStore?.removeAll()
      appState?.pushNotice(
        AppNotice(tone: .success, message: String(localized: "Cleared cached lesson data.")))
    } catch {
      appState?.pushNotice(
        AppNotice(
          tone: .error,
          message: String(
            format: String(localized: "Cache clear failed: %@"), error.localizedDescription)))
    }
    reload()
  }
}
