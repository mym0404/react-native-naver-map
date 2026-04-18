# Native Platforms

## Shared Expectations

`ios/` and `android/` implement the Fabric-native behavior described by `src/spec/`.

- Keep command names aligned with the TypeScript spec and `supportedCommands`.
- Review cross-platform parity before treating behavior as platform-specific.
- Edit source implementations, not generated interfaces or build output.
- Existing bridge interop for modules or image loading is narrowly scoped. Do not use it to reintroduce Bridge-era UI fallback behavior.

## Android

### Area Map

- [android/src/main/java/com/mjstudio/reactnativenavermap/](../../../android/src/main/java/com/mjstudio/reactnativenavermap/): runtime managers, views, overlays, events, utilities
- [android/src/newarch/](../../../android/src/newarch/): generated manager specs and interfaces
- [android/build.gradle](../../../android/build.gradle): Android library build configuration

### Working Rules

- Keep manager implementations aligned with the generated spec classes in `android/src/newarch/`.
- Register direct events through shared helpers such as `registerDirectEvent(...)` instead of open-coding event maps.
- Route imperative commands through `receiveCommand(view, commandId, args)` and keep string IDs aligned with the TypeScript spec.
- Preserve the existing manager and delegate style for overlays and map views.
- `RNCNaverMapPackage.kt` is the package registration point and currently returns `emptyList()` from `createNativeModules()`.
- Use [android/src/main/java/com/mjstudio/reactnativenavermap/util/image/GetOverlayImage.kt](../../../android/src/main/java/com/mjstudio/reactnativenavermap/util/image/GetOverlayImage.kt) for native overlay image loading and keep cleanup symmetric with the current bitmap lifecycle.

## iOS

### Area Map

- [ios/RNCNaverMapView.mm](../../../ios/RNCNaverMapView.mm) and [ios/RNCNaverMapViewImpl.mm](../../../ios/RNCNaverMapViewImpl.mm): map commands, camera behavior, view implementation
- [ios/Overlay/](../../../ios/Overlay/): overlay implementations
- [ios/Module/](../../../ios/Module/): native module utilities
- [ios/Util/](../../../ios/Util/): shared helpers for color, image, easing, and utility code

### Working Rules

- Follow Fabric lifecycle methods such as `initWithFrame:` and `updateProps:oldProps:`.
- Compare previous and next props before mutating native state in `updateProps`.
- Route imperative commands through `handleCommand:args:` and the generated command handler.
- Cast and null-check event emitters before emission.
- Keep async image loaders cancellable and clean them up on teardown.
- `ios/Module/RNCNaverMapUtil.mm` still exposes TurboModule interop under `RCT_NEW_ARCH_ENABLED`; keep that scoped to module responsibilities rather than UI fallback paths.
- Use [ios/Util/Image/ImageUtil.h](../../../ios/Util/Image/ImageUtil.h) as the shared image-loading entrypoint.

## Verification

- `pnpm codegen && pnpm run t`: after spec or native contract changes
- `pnpm ci:android` or `pnpm turbo:android`: after Android-native edits that need a build-path check
- `pnpm ci:ios` or `pnpm turbo:ios`: after iOS-native edits that need a build-path check
- `pnpm install && pnpm pod`: after React Native native dependency changes that affect CocoaPods state

## Related Documents

- Repo shape and invariants: [../architecture.md](../architecture.md)
- TypeScript surface guidance: [source-surface.md](source-surface.md)
- Repo-specific implementation idioms: [../patterns.md](../patterns.md)
