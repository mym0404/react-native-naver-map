# Patterns

## TypeScript Contract Patterns

- Define Fabric components with `codegenNativeComponent<Props>()` and use React Native codegen types from `react-native/Libraries/Types/CodegenTypes`.
- Keep `supportedCommands` exactly aligned with wrapper methods and native command handlers.
- `src/spec/RNCNaverMapViewNativeComponent.ts` is the current reference for codegen parser limitations. When imported composite aliases fail there, redeclare the shape locally instead of weakening types.
- `src/spec/NativeRNCNaverMapUtil.ts` is the TurboModule contract. If the utility API becomes active again, update that spec, [src/util/NaverMapUtil.ts](../../src/util/NaverMapUtil.ts), [ios/Module/RNCNaverMapUtil.mm](../../ios/Module/RNCNaverMapUtil.mm), and the matching Android implementation together.
- Public API files should keep useful JSDoc, especially `@param`, `@returns`, `@example`, `@default`, `@internal`, and `@platform`.
- React-facing color props should accept `ColorValue` and convert to native integers with `processColor(...)` before crossing the bridge-less boundary.

## iOS Patterns

- Fabric component views initialize default props in `initWithFrame:` and compare previous versus next props inside `updateProps:oldProps:`.
- Imperative map commands route through `handleCommand:args:` and the generated handler functions.
- Event emission should cast `_eventEmitter` to the component-specific emitter type and null-check before use.
- Async image loading uses shared helpers under [ios/Util/Image/](../../ios/Util/Image/) and should keep cancellers alive until cleanup.
- Bridge interop that still exists on iOS is for module or image-loading support only, not UI fallback behavior.

## Android Patterns

- View managers extend the generated spec classes under [android/src/newarch/](../../android/src/newarch/) and keep delegate behavior aligned with generated code.
- Register direct events through shared helpers such as [DirectEventUtils.kt](../../android/src/main/java/com/mjstudio/reactnativenavermap/util/DirectEventUtils.kt).
- Imperative commands flow through `receiveCommand(view, commandId, args)` and should parse `ReadableArray` defensively.
- Emit native events through the shared event classes and helper path instead of open-coding event maps in each manager.
- Overlay image loading goes through [GetOverlayImage.kt](../../android/src/main/java/com/mjstudio/reactnativenavermap/util/image/GetOverlayImage.kt); custom-view bitmap rendering must clean up allocated bitmaps.

## Native Image Pipeline

- Supported image forms include symbol names, React Native asset URIs, HTTP URIs, asset names, and custom rendered views.
- Prefer a stable `reuseIdentifier` when an image should participate in native caching.
- Cancel pending image work during teardown.
- Keep image-loading behavior symmetric across iOS and Android unless a platform limitation is explicit.

## Related Documents

- TypeScript surface guidance: [areas/source-surface.md](areas/source-surface.md)
- Native implementation guidance: [areas/native-platforms.md](areas/native-platforms.md)
- Supporting packages and scripts: [areas/supporting-packages.md](areas/supporting-packages.md)
