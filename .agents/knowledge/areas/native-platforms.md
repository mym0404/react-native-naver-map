# Native Platforms

## Scope

`ios/` and `android/` implement the Fabric-native behavior described by `src/spec/`.

## Shared Expectations

- Keep native command names aligned with the TypeScript spec.
- Review cross-platform parity before treating behavior as platform-specific.
- Prefer existing event and manager patterns over one-off command or emission paths.
- Edit source implementations, not generated interfaces or build output.
- Existing module or image-loading bridge interop should stay tightly scoped to its current native responsibilities. Do not treat that as permission to reintroduce Bridge-era UI fallback behavior.

## Android

### Structure

- `android/src/main/java/com/mjstudio/reactnativenavermap/`: runtime managers, wrappers, overlays, events, utilities
- `android/src/newarch/`: generated manager specs and interfaces
- `android/build.gradle`: Android library build config
- `android/gradle/`: Gradle wrapper and config

### Where To Look

- `android/src/main/java/com/mjstudio/reactnativenavermap/RNCNaverMapPackage.kt`: package registration
- `android/src/main/java/com/mjstudio/reactnativenavermap/mapview/*`: map view behavior and lifecycle
- `android/src/main/java/com/mjstudio/reactnativenavermap/overlay/*`: overlay-specific managers and views
- `android/src/main/java/com/mjstudio/reactnativenavermap/util/ViewEventEmitter.kt`, `util/DirectEventUtils.kt`: event helper path
- `android/src/main/java/com/mjstudio/reactnativenavermap/util/image/*`: native image handling
- `android/src/main/java/com/mjstudio/reactnativenavermap/`: runtime managers, wrappers, and utilities
- `android/src/newarch/`: generated spec interfaces
- `android/build.gradle`: Android library build config

### Conventions

- Keep manager implementations aligned with generated spec interfaces.
- Use shared event utilities for event dispatch.
- Register direct events through the shared helper path instead of open-coding event maps.
- Preserve lifecycle handling patterns in wrappers and attached views.
- Maintain naming parity with TypeScript spec command and event definitions.
- Keep overlay managers consistent with the existing manager and delegate style.
- Use `receiveCommand(view, commandId, args)` for imperative commands and keep string IDs aligned with `supportedCommands`.
- `RNCNaverMapPackage.kt` is the current registration point for view managers. `createNativeModules()` currently returns `emptyList()`.

### Validation

- Spec change: `pnpm codegen`
- Baseline repo check: `pnpm run t`
- Android-focused build: `pnpm ci:android` or `pnpm turbo:android`

## iOS

### Structure

- `ios/RNCNaverMapView*.{h,mm}`: main map Fabric view and command surface
- `ios/Overlay/*`: overlay implementations
- `ios/Module/`: native module utilities
- `ios/Util/`: shared helpers for color, image, easing, and supporting utilities

### Where To Look

- `ios/RNCNaverMapView.mm`, `ios/RNCNaverMapViewImpl.mm`: map commands, camera behavior, and view implementation
- `ios/Overlay/*`: overlay implementations
- `ios/Module/RNCNaverMapUtil.mm`: native utility module
- `ios/Util/Image/ImageUtil.h`, `ios/Util/FnUtil.h`, `ios/Util/EasingAnimationUtil.h`: shared helpers

### Conventions

- Follow Fabric component lifecycle methods such as `initWithFrame` and `updateProps`.
- Compare previous and next props before mutating native state in `updateProps`.
- Cast and null-check event emitters before emission.
- Route imperative commands through `handleCommand:args:` and the generated command handler.
- Clean up async image loaders and cancelers on teardown.
- Keep overlay implementation patterns consistent across overlay folders.
- `RNCNaverMapUtil.mm` still exposes `RCT_EXPORT_MODULE()` and `getTurboModule` under `RCT_NEW_ARCH_ENABLED`; keep that scoped to module interop rather than UI fallback behavior.
- Marker and pattern image loading flows through `nmap::getImage(...)`, which uses `reuseIdentifier`-backed cache keys where available.

### Validation

- Spec change: `pnpm codegen`
- Baseline repo check: `pnpm run t`
- Pod state change: `pnpm pod` or `pnpm pod:update`

## Anti-Patterns

- Bridge-era fallback logic in v2.x code paths
- Manual command routing that drifts from codegen specs
- Native-only behavior changes without TypeScript-spec review
- Event emission outside established helper paths
- Event emission on iOS without emitter validity checks
- Editing generated interfaces or build output as source

## Related Documents

- Repo-wide architecture constraints: `../architecture.md`
- JS/spec contract guidance: `source-surface.md`
- Implementation patterns and examples: `../patterns.md`
