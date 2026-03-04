# SwiftAtlas

SwiftAtlas is an iPhone-first SwiftUI reference application built to teach Swift and modern iOS engineering through production-style code. The app is intentionally structured so the codebase itself is the lesson: architecture, state ownership, concurrency, caching, design systems, previews, testing, memory management, and secure storage are all demonstrated in working features rather than in isolated snippets.

The project uses Apple frameworks only, follows MVVM with explicit boundaries, and favors readable, teachable code over shortcuts or abstraction for its own sake.

## Quality Bar

- Every repository and view model should have deterministic unit tests.
- Every non-trivial screen should include multiple previews that demonstrate meaningful states.
- User-visible strings should be represented in `Localizable.xcstrings`.
- UI tests should cover at least one critical journey for each top-level area of the app.

## Goals

- Teach Swift and iOS app architecture through a real application.
- Provide a clean MVVM reference with explicit separation between views, view models, repositories, and shared infrastructure.
- Demonstrate modern SwiftUI patterns for local state, global state, navigation, reusable components, previews, and testing.
- Show production-grade concerns such as networking, caching, diagnostics, feature flags, secrets storage, ARC, retain cycles, and structured concurrency.
- Keep the codebase approachable enough to study file by file.

## Product Overview

The app is organized around four tabs:

- `Home`: architecture summary, app purpose, high-level diagnostics, and quick links into the learning areas.
- `Lessons`: API-backed content demonstrating lists, grouping, filtering, detail flows, refresh, caching, and pinned state.
- `Labs`: focused demos for components, theming, modals, ownership, inheritance, access control, and concurrency.
- `Settings`: theme override, feature flags, diagnostics, cache management, and Keychain-backed secret storage.

## Teaching Areas Covered

This repository is designed to act as a practical reference for the following topics:

- MVVM and project structure
- SwiftUI state ownership
- Global app state versus feature-local state
- Dependency injection through a container
- Design tokens, theme resolution, dark mode, and reusable components
- Networking with `URLSession` and app-owned request/response types
- DTO-to-domain mapping
- In-memory and disk-backed caching
- Search, list rendering, grouping, and modal presentation
- Keychain-backed secret storage
- Memory management, ARC, strong/weak/unowned references, and retain cycles
- Inheritance, subclassing, override control, `final`, and protocol-first tradeoffs
- Access control and special identifiers
- Structured concurrency, `Task`, `async let`, cancellation, and actor-based isolation
- Sample data, previews, deterministic test fixtures, unit tests, and UI tests

## Architecture

SwiftAtlas uses a layered MVVM structure:

```text
View -> ViewModel -> Repository / Service -> Infrastructure
```

The core rule is that SwiftUI views render and bind state, but they do not contain business logic. View models orchestrate feature behavior. Repositories and services perform data access, mapping, persistence, and side effects. Shared infrastructure stays behind stable interfaces.

### State Ownership

- Feature-local state lives in feature view models.
- App-wide state lives in `AppState`.
- Dependencies are resolved through `AppContainer`.
- Shared mutable infrastructure is kept explicit rather than hidden behind global singletons.

### Container

The app container wires together the main runtime dependencies:

- `AppState`
- `LessonRepository`
- `ExerciseRepository`
- `FeatureFlagStore`
- `SecretsStore`
- `CacheStore`
- `PinnedLessonStore`
- `DiagnosticsService`

See [AppContainer.swift](SwiftAtlas/App/AppContainer.swift).

### App Entry

The app starts in [SwiftAtlasApp.swift](SwiftAtlas/App/SwiftAtlasApp.swift), builds a live container, and injects it into the SwiftUI environment. The tab shell lives in [AppScene.swift](SwiftAtlas/App/AppScene.swift).

## Project Structure

```text
SwiftAtlas/
  App/
  Core/
    Architecture/
    DesignSystem/
    Foundation/
    Networking/
    Persistence/
  Features/
    Home/
    Lessons/
    Labs/
    Settings/
  Shared/
    Models/
    PreviewSupport/
    SampleData/
    Services/
  Resources/

SwiftAtlasTests/
SwiftAtlasUITests/
```

### App Layer

- [SwiftAtlasApp.swift](SwiftAtlas/App/SwiftAtlasApp.swift): app entry point
- [AppScene.swift](SwiftAtlas/App/AppScene.swift): root tab UI
- [AppState.swift](SwiftAtlas/App/AppState.swift): global app state
- [AppRouter.swift](SwiftAtlas/App/AppRouter.swift): app tab metadata

### Core Layer

- `Architecture`: feature flags and loadable state
- `DesignSystem`: tokens, theme resolution, and reusable UI components
- `Foundation`: app errors, diagnostics, build metadata
- `Networking`: requests, endpoints, DTOs, and HTTP client
- `Persistence`: cache stores and secret storage

### Features Layer

- `Home`: top-level educational dashboard
- `Lessons`: remote data flow, search, grouping, pinned lessons, detail views
- `Labs`: focused technical demonstrations
- `Settings`: app configuration and diagnostics

### Shared Layer

- domain models owned by the app
- preview containers and fake repositories
- deterministic sample data
- small cross-feature services such as pinned lessons

## Domain Model

The app maps JSONPlaceholder into app-owned domain types so the UI is never coupled directly to transport models.

### Remote Source

The app uses JSONPlaceholder as a read-only demo backend:

- `users` -> track owners and mentor metadata
- `posts` -> lessons
- `todos` -> exercises
- `comments` -> lesson discussions/examples

### App-Owned Models

The main domain types live under [Shared/Models](SwiftAtlas/Shared/Models):

- `Track`
- `TrackOwner`
- `Lesson`
- `LessonGroup`
- `LessonDetail`
- `LessonComment`
- `Exercise`
- `LabTopic`
- `ComponentExample`
- `AppNotice`
- `NetworkReachabilityState`

This is a deliberate teaching choice: transport models are implementation details, domain models are application language.

## Design System

The app has a small design system rather than ad hoc view styling.

### Tokens

Tokens live under [Core/DesignSystem/Tokens](SwiftAtlas/Core/DesignSystem/Tokens):

- `GSColorTokens`
- `GSSpacing`
- `GSTypography`

These provide semantic building blocks so feature views do not hardcode styling decisions repeatedly.

### Theme

Theme support lives under [Core/DesignSystem/Theme](SwiftAtlas/Core/DesignSystem/Theme):

- `ThemeOption`
- `ThemePalette`
- `ThemeResolver`

Supported theme modes:

- `system`
- `light`
- `dark`

The selected theme is stored in app state and is applied globally using `preferredColorScheme`.

### Reusable Components

Reusable components live under [Core/DesignSystem/Components](SwiftAtlas/Core/DesignSystem/Components):

- `GSCard`
- `GSSectionHeader`
- `GSPrimaryButton`
- `GSSecondaryButton`
- `GSAsyncStateView`
- `GSBadge`
- `GSInfoRow`
- `GSErrorView`
- `GSSkeletonBlock`
- `GSToggleRow`

These are intentionally simple enough to study and reuse, but structured enough to model good boundaries and semantic styling.

## Data Flow, Networking, And Caching

The Lessons feature is the main end-to-end example of the app’s data layer.

### Networking

Networking infrastructure lives under [Core/Networking](SwiftAtlas/Core/Networking):

- `APIRequest`
- `HTTPClient`
- `URLSessionHTTPClient`
- `JSONPlaceholderAPI`
- JSONPlaceholder DTO types

The app uses `URLSession` behind an `HTTPClient` protocol so production code, previews, and tests can swap implementations cleanly.

### Repository Mapping

The repository layer maps DTOs into domain types before they reach views. See [DefaultLessonRepository.swift](SwiftAtlas/Features/Lessons/Repositories/DefaultLessonRepository.swift).

Notable patterns shown there:

- `async let` for parallel network requests
- cache-first reads for fast initial rendering
- detail fetch composition
- DTO-to-domain mapping
- separation between remote payloads and feature models

### Cache Policies

Caching support lives under [Core/Persistence/Cache](SwiftAtlas/Core/Persistence/Cache):

- `CachePolicy`
- `CacheKey`
- `CacheStore`
- `InMemoryCacheStore`
- `JSONFileCacheStore`

Supported policies:

- `remoteOnly`
- `cacheOnly`
- `cacheFirst`
- `staleWhileRevalidate`

The repository layer uses these policies to decide whether to serve cached data, fetch remotely, or do both in sequence.

## Secrets Storage

Secrets are handled through a dedicated abstraction:

- [SecretsStore.swift](SwiftAtlas/Core/Persistence/Secrets/SecretsStore.swift)
- [KeychainSecretsStore.swift](SwiftAtlas/Core/Persistence/Secrets/KeychainSecretsStore.swift)
- [InMemorySecretsStore.swift](SwiftAtlas/Core/Persistence/Secrets/InMemorySecretsStore.swift)

The Settings feature includes a demo token flow so the project can teach:

- why secrets should not go into `UserDefaults`
- how to hide security implementation details behind a protocol
- how to test secret storage with an in-memory fake

## Feature Flags

Feature flags live under [Core/Architecture/FeatureFlag](SwiftAtlas/Core/Architecture/FeatureFlag):

- `FeatureFlag`
- `FeatureFlagStore`
- `UserDefaultsFeatureFlagStore`

This supports:

- default values in code
- local overrides
- testable flag lookups
- settings-driven toggles

## Lessons Feature

The Lessons feature is the strongest example of the app’s main architectural path.

Key files:

- [LessonListViewModel.swift](SwiftAtlas/Features/Lessons/ViewModels/LessonListViewModel.swift)
- [LessonDetailViewModel.swift](SwiftAtlas/Features/Lessons/ViewModels/LessonDetailViewModel.swift)
- [LessonsView.swift](SwiftAtlas/Features/Lessons/Views/LessonsView.swift)
- [LessonDetailView.swift](SwiftAtlas/Features/Lessons/Views/LessonDetailView.swift)

Concepts demonstrated:

- loading and empty states
- grouped list rendering
- pull-to-refresh
- search
- pinned items
- detail fetch and mapping
- exercise grouping
- cache-backed reads

## Labs Feature

The Labs tab contains explicit teaching demos that are valuable even if they are not part of the core content product flow.

### Components And Theme Labs

- [ComponentsLabView.swift](SwiftAtlas/Features/Labs/ComponentsLab/ComponentsLabView.swift)
- [ThemeLabView.swift](SwiftAtlas/Features/Labs/ComponentsLab/ThemeLabView.swift)
- [ModalLabView.swift](SwiftAtlas/Features/Labs/ComponentsLab/ModalLabView.swift)

These demonstrate reusable UI, semantic styling, and presentation APIs.

### Ownership And ARC Labs

- [OwnershipLabView.swift](SwiftAtlas/Features/Labs/OwnershipLab/OwnershipLabView.swift)
- [OwnershipLabViewModel.swift](SwiftAtlas/Features/Labs/OwnershipLab/OwnershipLabViewModel.swift)
- [OwnershipModels.swift](SwiftAtlas/Features/Labs/OwnershipLab/OwnershipModels.swift)

These files demonstrate:

- ARC fundamentals
- strong references
- `weak` references
- `unowned` references
- object-to-object retain cycles
- object-to-closure retain cycles
- deallocation visibility

### Inheritance Lab

- [FormatterExamples.swift](SwiftAtlas/Features/Labs/InheritanceLab/FormatterExamples.swift)
- [InheritanceLabView.swift](SwiftAtlas/Features/Labs/InheritanceLab/InheritanceLabView.swift)

This covers `final`, `override`, `required init`, `private(set)`, `class` vs `static`, and protocol-first alternatives.

### Access Control Lab

- [AccessControlExamples.swift](SwiftAtlas/Features/Labs/AccessControlLab/AccessControlExamples.swift)
- [AccessControlLabView.swift](SwiftAtlas/Features/Labs/AccessControlLab/AccessControlLabView.swift)

This covers:

- `private`
- `fileprivate`
- `internal`
- `public`
- `open`
- `self`
- `Self`
- `super`
- `#function`
- `#fileID`
- `#line`
- `#column`

### Concurrency Lab

- [ConcurrencyLabView.swift](SwiftAtlas/Features/Labs/ConcurrencyLab/ConcurrencyLabView.swift)
- [ConcurrencyLabViewModel.swift](SwiftAtlas/Features/Labs/ConcurrencyLab/ConcurrencyLabViewModel.swift)
- [ConcurrencyDemoCounter.swift](SwiftAtlas/Features/Labs/ConcurrencyLab/ConcurrencyDemoCounter.swift)

This demonstrates:

- `Task`
- cancellation-aware work
- actor-based mutation
- `@MainActor` UI coordination
- explicit async orchestration

## Settings Feature

The Settings flow is where most app-wide controls live.

Key files:

- [SettingsViewModel.swift](SwiftAtlas/Features/Settings/ViewModels/SettingsViewModel.swift)
- [AppearanceSettingsView.swift](SwiftAtlas/Features/Settings/Views/AppearanceSettingsView.swift)
- [FeatureFlagsView.swift](SwiftAtlas/Features/Settings/Views/FeatureFlagsView.swift)
- [SecretsDemoView.swift](SwiftAtlas/Features/Settings/Views/SecretsDemoView.swift)
- [CacheInspectorView.swift](SwiftAtlas/Features/Settings/Views/CacheInspectorView.swift)
- [DiagnosticsView.swift](SwiftAtlas/Features/Settings/Views/DiagnosticsView.swift)

This feature demonstrates:

- persisted theme changes
- feature flag toggles
- Keychain-backed secret handling
- cache clearing
- diagnostics snapshots
- app-level notices

## Previews And Sample Data

Preview support lives under [Shared/PreviewSupport](SwiftAtlas/Shared/PreviewSupport) and [Shared/SampleData](SwiftAtlas/Shared/SampleData).

Key ideas:

- deterministic sample data
- preview containers with fake dependencies
- feature-level preview wiring without touching live infrastructure
- reproducible visual states for teaching and regression catching

Important preview support files:

- `PreviewContainer`
- `PreviewAppContainer`
- `PreviewRepositories`
- `PreviewScenarios`
- `SampleLessons`
- `SampleExercises`
- `SampleFlags`
- `SampleThemeState`

## Testing

The project uses a mix of the modern `Testing` framework and UI tests.

### Unit And Integration Tests

Unit and integration coverage currently includes:

- repository mapping
- lesson view model behavior
- feature flag logic
- in-memory secrets storage
- ownership/ARC behavior
- concurrency lab behavior

See:

- [LessonRepositoryTests.swift](SwiftAtlasTests/Features/LessonRepositoryTests.swift)
- [LessonListViewModelTests.swift](SwiftAtlasTests/Features/LessonListViewModelTests.swift)
- [FeatureFlagStoreTests.swift](SwiftAtlasTests/Core/FeatureFlagStoreTests.swift)
- [InMemorySecretsStoreTests.swift](SwiftAtlasTests/Core/InMemorySecretsStoreTests.swift)
- [OwnershipLabTests.swift](SwiftAtlasTests/Core/OwnershipLabTests.swift)
- [ConcurrencyLabTests.swift](SwiftAtlasTests/Core/ConcurrencyLabTests.swift)

### UI Tests

UI tests live under [SwiftAtlasUITests](SwiftAtlasUITests).

Current UI coverage includes:

- app launch
- basic flow validation

See:

- [SwiftAtlasLaunchTests.swift](SwiftAtlasUITests/Flows/SwiftAtlasLaunchTests.swift)
- [SwiftAtlasUITests.swift](SwiftAtlasUITests/Flows/SwiftAtlasUITests.swift)

## Build And Run

### Requirements

- Xcode with iOS SDK support
- iOS simulator runtime or a physical device
- macOS environment capable of running `xcodebuild`

### Open In Xcode

Open [SwiftAtlas.xcodeproj](SwiftAtlas.xcodeproj) and run the `SwiftAtlas` scheme on an iPhone simulator or device.

### Command Line Build

```sh
xcodebuild -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlas \
  -destination 'generic/platform=iOS' \
  -derivedDataPath /tmp/SwiftAtlasDerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### Command Line Tests

Unit and UI tests can be run from Xcode or the command line. Example:

```sh
xcodebuild -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlasTests \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test
```

```sh
xcodebuild -project SwiftAtlas.xcodeproj \
  -scheme SwiftAtlasUITests \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test
```

Note: in restricted environments, simulator-backed test execution may fail if CoreSimulator services are unavailable even when the project itself builds cleanly.

## Conventions

The repo rules are captured in [AGENTS.md](AGENTS.md). The most important conventions are:

- MVVM boundaries are strict.
- Views stay thin.
- Domain models are app-owned.
- `final` is the default for classes.
- Shared mutable state must be explicit.
- Theme tokens should be used instead of hardcoded styling.
- Every meaningful change should consider previews and tests.

## How To Study This Codebase

If you are using the project to learn Swift or iOS engineering, this order works well:

1. Start with [SwiftAtlasApp.swift](SwiftAtlas/App/SwiftAtlasApp.swift), [AppScene.swift](SwiftAtlas/App/AppScene.swift), and [AppContainer.swift](SwiftAtlas/App/AppContainer.swift).
2. Read the shared domain models in [Shared/Models](SwiftAtlas/Shared/Models).
3. Follow the Lessons feature from view to view model to repository.
4. Inspect the design system components and theme tokens.
5. Study the Labs feature for focused language and runtime concepts.
6. Read the tests to see how the architecture is exercised in isolation.

## Why This Repo Exists

There are many sample projects that show isolated APIs, but fewer that show how those APIs fit together in a disciplined, readable application. SwiftAtlas exists to fill that gap. It is meant to be a durable teaching codebase you can browse when you want a concrete answer to questions like:

- How should I structure an MVVM SwiftUI app?
- Where should state live?
- How do I map network DTOs into domain models?
- How should I handle cache layers and feature flags?
- What does good preview infrastructure look like?
- How do I reason about `weak`, `unowned`, retain cycles, and `final` in real code?
- How should I organize tests in a modern Swift codebase?

## Status

The project is already organized as a working iOS app with app, unit-test, and UI-test targets. The architecture and teaching coverage are in place, and the codebase is designed to support continued expansion without changing its core structure.
