# @mj-studio/react-native-naver-map

## 2.11.0

### Minor Changes

- 2a7f5fc: Add SDK-wide authentication failure subscriptions with native error codes and messages, preserving existing native listeners and delegates.
- 0601b14: Add custom images and caption styling for aggregate cluster markers.
- a77f14b: Add `onTapCluster` with the group index and actual native cluster member identifiers, while preserving the SDK's default zoom behavior.
- 2745daf: Add custom React view content for info windows.
- 90dee8d: Add `onLongTapMap` with geographic and map-local screen coordinates.
- 35d2ddd: Add `onMapLoaded` for the native map instance's initial data load.
- 680783e: Add `onMapRendered` with native frame rendering status.
- c3c680e: Add map snapshots with optional native SDK controls.

### Patch Changes

- 506761c: Convert Android screenToCoordinate inputs from DP to pixels before calling the native projection.

## 2.10.0

### Minor Changes

- c25a775: Add the `onTapSymbol` event for map symbols on Android and iOS.

## 2.9.1

### Patch Changes

- ca8b0ab: Fix Android builds across React Native Java/Kotlin shadow-node APIs and Android Gradle Plugin Kotlin configurations.
