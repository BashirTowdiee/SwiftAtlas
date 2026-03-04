# SwiftAtlas Runbook

## Purpose

This runbook is the day-to-day operating guide for working on `SwiftAtlas`.
Use it for local setup, common development commands, debugging flow, and release-adjacent checks.

## Repository Basics

- App target: `SwiftAtlas`
- Unit test target: `SwiftAtlasTests`
- UI test target: `SwiftAtlasUITests`
- Xcode project: `SwiftAtlas.xcodeproj`
- Shared schemes:
  - `SwiftAtlas`
  - `SwiftAtlasTests`
  - `SwiftAtlasUITests`

## Prerequisites

- macOS with Xcode installed
- Xcode command line tools available
- `xcodebuild`, `xcrun`, and `swift-format` accessible through Xcode

Verify tooling:

```bash
xcodebuild -version
xcrun --find swift-format
```

## Open The Project

Open in Xcode:

```bash
open SwiftAtlas.xcodeproj
```

## Formatting

Formatter config lives in [`.swift-format`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/.swift-format).

Format the repo:

```bash
bash scripts/format.sh
```

Notes:

- The script resolves `swift-format` from `PATH` first, then falls back to `xcrun`.
- It skips `.build`, `DerivedData`, and `Pods`.

## Build Commands

### Build The App From Xcode

- Open `SwiftAtlas.xcodeproj`
- Select the `SwiftAtlas` scheme
- Choose an iPhone simulator
- Build with `Cmd+B`

### Build From CLI

Generic iOS build:

```bash
xcodebuild \
  -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlas \
  -destination 'generic/platform=iOS' \
  -derivedDataPath /tmp/SwiftAtlasDerivedData \
  build
```

Notes:

- This may fail on machines without signing configured for the app target.
- In this repo, test-only builds are easier to run headlessly than full signed app builds.

## Test Commands

### Unit Test Build Verification

Compile tests without requiring code signing:

```bash
xcodebuild \
  -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlasTests \
  -destination 'generic/platform=iOS' \
  -derivedDataPath /tmp/SwiftAtlasTestsDerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build-for-testing
```

This is the best headless smoke check for source-level correctness.

### Run Unit Tests In Xcode

- Select the `SwiftAtlasTests` scheme
- Choose an iPhone simulator
- Run with `Cmd+U`

### Run UI Tests In Xcode

- Select the `SwiftAtlasUITests` scheme
- Choose an iPhone simulator
- Run with `Cmd+U`

Notes:

- UI tests require CoreSimulator to be working.
- If simulator services are unavailable, CLI UI-test runs will fail before execution.

## Runtime Architecture Reference

### App Entry

- [`SwiftAtlasApp.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/App/SwiftAtlasApp.swift)
- [`AppScene.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/App/AppScene.swift)
- [`AppContainer.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/App/AppContainer.swift)
- [`AppState.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/App/AppState.swift)

### Main Feature Areas

- Home: high-level app summary and navigation entry points
- Lessons: networking, caching, filtering, detail flow
- Labs: isolated learning demos
- Settings: theme, flags, diagnostics, secrets, cache actions

### Preview Infrastructure

- [`PreviewAppContainer.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/Shared/PreviewSupport/PreviewAppContainer.swift)
- [`PreviewRepositories.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/Shared/PreviewSupport/PreviewRepositories.swift)
- [`PreviewScenarios.swift`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/SwiftAtlas/Shared/PreviewSupport/PreviewScenarios.swift)

## Common Debugging Paths

### Build Or Test Failures

Check:

- active Xcode scheme
- selected simulator/runtime
- signing configuration for the app target
- whether `DerivedData` is stale

Useful cleanup:

```bash
rm -rf /tmp/SwiftAtlasDerivedData /tmp/SwiftAtlasTestsDerivedData
```

### Formatting Issues

If formatting fails:

- verify `xcrun --find swift-format`
- verify the script is executable
- verify [`.swift-format`](/Users/bashirtowdiee/Development/playground/Native-iOS/SwiftAtlas/.swift-format) is valid JSON

### UI Test Failures

Check:

- accessibility identifiers on touched screens
- simulator boot status
- whether the change altered labels or navigation timing

Current stable UI hooks include:

- `home.screen`
- `home.openLessons`
- `home.openLabs`
- `lessons.screen`
- `lessons.filterButton`
- `lessons.filterSheet`
- `lessonDetail.screen`
- `settings.screen`
- `settings.themePicker`
- `settings.secretField`
- `settings.clearCache`
- `labs.screen`

## Data And Persistence Notes

- Lessons and exercises use JSONPlaceholder-backed repository flows.
- Cache behavior is demonstrated through `CachePolicy`.
- Secrets are stored through the `SecretsStore` abstraction.
- Preview and test paths use deterministic in-memory or fake implementations where possible.

## Quality Expectations

Before merging changes:

- format Swift files
- run a unit test build
- update or add previews for non-trivial UI changes
- update or add tests for repository/view-model changes
- ensure user-visible strings are covered by `Localizable.xcstrings`

## Known Constraints

- Full app CLI builds may require a configured development team.
- UI tests depend on a functioning CoreSimulator environment.
- Headless environments may compile successfully while still being unable to launch simulator-backed tests.

## Recommended Pre-PR Checklist

```bash
bash scripts/format.sh

xcodebuild \
  -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlasTests \
  -destination 'generic/platform=iOS' \
  -derivedDataPath /tmp/SwiftAtlasTestsDerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build-for-testing
```
