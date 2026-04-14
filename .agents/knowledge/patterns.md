# Patterns

This document absorbs the implementation-oriented knowledge that previously lived in the retired monolithic guidance file. It keeps the reusable patterns, but normalizes them to the current repository state.

## TypeScript Native Contract Patterns

### Fabric Components

- Define Fabric native components with `codegenNativeComponent<Props>()`.
- Import codegen types such as `Double`, `Int32`, `WithDefault`, `DirectEventHandler`, and `Readonly` shapes from `react-native/Libraries/Types/CodegenTypes` as needed.
- Extend `ViewProps` for native component props.
- In larger spec files, redeclare composite types locally when the codegen TypeScript parser requires it. The comment in `src/spec/RNCNaverMapViewNativeComponent.ts` is the current reference.
- Representative files:
  - `src/spec/RNCNaverMapViewNativeComponent.ts`
  - `src/spec/RNCNaverMapMarkerNativeComponent.ts`
  - `src/spec/RNCNaverMapPathNativeComponent.ts`

Example skeleton:

```typescript
import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  coord: Readonly<{
    latitude: Double;
    longitude: Double;
  }>;
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  width?: Double;
  height?: Double;
  alpha?: Double;
  isHidden?: WithDefault<boolean, false>;
  tintColor?: Int32;
}

export default codegenNativeComponent<Props>('RNCNaverMapMarker');
```

### Native Commands

- Define imperative APIs with `codegenNativeCommands<NativeCommands>()`.
- The first parameter should be the native component ref, typically `React.ElementRef<ComponentType>`.
- Keep `supportedCommands` exactly aligned with the commands handled on iOS and Android.
- Use Promise-returning commands for query-style APIs such as coordinate conversions, and void commands for fire-and-forget mutations.
- Representative file: `src/spec/RNCNaverMapViewNativeComponent.ts`

Example skeleton:

```typescript
interface NativeCommands {
  screenToCoordinate: (
    ref: React.ElementRef<ComponentType>,
    x: Double,
    y: Double
  ) => Promise<
    Readonly<{
      isValid: boolean;
      latitude: Double;
      longitude: Double;
    }>
  >;
  animateCameraTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double,
    duration?: Int32
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['screenToCoordinate', 'animateCameraTo'],
});
```

### TurboModules

- The native utility contract is defined in `src/spec/NativeRNCNaverMapUtil.ts` with `TurboModuleRegistry.getEnforcing()`.
- On iOS, `ios/Module/RNCNaverMapUtil.mm` provides `RCT_EXPORT_MODULE()` and `getTurboModule` under `RCT_NEW_ARCH_ENABLED`.
- The public utility wrapper in `src/util/NaverMapUtil.ts` is currently a placeholder. If utility APIs become active again, keep the wrapper, the spec, and the native module implementation in sync.

## JSDoc Patterns

- Keep JSDoc on public APIs, especially components, props, and imperative methods.
- The most useful tags in this repo are `@param`, `@returns`, `@example`, `@default`, `@internal`, and `@platform`.
- Existing component files already use `@default` heavily. Preserve that style when you add or change public options.
- JSDoc is for API clarity. The user-facing docs site still lives in hand-authored MDX under `docs/content/docs/`.
- Older guidance mentioned auto-generated docs from JSDoc, but the current repo clearly contains hand-authored MDX docs as the main docs-site content. Keep JSDoc strong for API clarity, but do not assume the docs site is fully generated from it.

Example skeleton:

```typescript
/**
 * Animates the camera to a specific coordinate.
 *
 * @param latitude - The target latitude
 * @param longitude - The target longitude
 * @param duration - Animation duration in milliseconds
 * @default 300
 * @example
 * mapRef.current?.animateCameraTo(37.5665, 126.978, 500);
 */
animateCameraTo: (
  latitude: number,
  longitude: number,
  duration?: number
) => void;
```

## TypeScript Color Handling

- React-facing color props should accept `ColorValue`.
- Before handing colors to native code, convert them with `processColor(...)`.
- Native spec fields should use `Int32` for color values.
- Handle null or undefined carefully instead of assuming a color is always present.
- Representative files:
  - `src/component/NaverMapView.tsx`
  - `src/component/NaverMapMarkerOverlay.tsx`
  - `src/component/NaverMapPathOverlay.tsx`

Example skeleton:

```typescript
import { processColor, type ColorValue } from 'react-native';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  tintColor?: Int32;
  outlineColor?: Int32;
}

const nativeProps = {
  tintColor: processColor(props.tintColor) as Int32,
  outlineColor: processColor(props.outlineColor) as Int32,
};
```

## iOS Implementation Patterns

### Fabric View Lifecycle

- Fabric component views extend `RCTViewComponentView`.
- Initialize default props in `initWithFrame:`.
- Implement `updateProps:oldProps:` and compare previous and next props before mutating native state.
- Cast component props with `std::static_pointer_cast`.
- Representative files:
  - `ios/RNCNaverMapView.mm`
  - `ios/Overlay/Path/RNCNaverMapPath.mm`

Example skeleton:

```objc
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapPathProps>();
    _props = defaultProps;
    _inner = [NMFPath new];
  }
  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPathProps const>(props);

  if (prev.width != next.width) _inner.width = next.width;

  [super updateProps:props oldProps:oldProps];
}
```

### Commands

- Implement imperative commands as instance methods on the component view.
- Route command dispatch through `handleCommand:args:` and the generated handler function.
- Keep method parameters aligned with the TypeScript command contract.
- Representative file: `ios/RNCNaverMapView.mm`

Example skeleton:

```objc
- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing {
  NMFCameraUpdate* update =
      [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)];
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  [self.map moveCamera:update];
}

- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}
```

### Event Emission

- Access the event emitter through `_eventEmitter`.
- Cast it to the component-specific emitter type with `std::static_pointer_cast`.
- Null-check the emitter before calling any event method.
- This null-guard pattern is mandatory for overlay tap and lifecycle callbacks.

Example skeleton:

```objc
- (std::shared_ptr<RNCNaverMapPathEventEmitter const>)emitter {
  if (!_eventEmitter) return nullptr;
  return std::static_pointer_cast<RNCNaverMapPathEventEmitter const>(_eventEmitter);
}
```

### Native Module Interop

- `RNCNaverMapUtil.mm` still contains TurboModule interop for the utility module.
- Some iOS files also include `RCTBridge` access for image loading helpers.
- Keep that interop tightly scoped to current module and image-loading needs. Do not extend it into Bridge-era UI fallback paths.

## Android Implementation Patterns

### ViewManagers And Delegates

- Extend generated spec classes such as `RNCNaverMapViewManagerSpec` and `RNCNaverMapMarkerManagerSpec`.
- Use the generated manager delegate path and keep `getDelegate()` behavior aligned with generated code.
- Use `ViewGroupManager` for components that own children and `SimpleViewManager` for simpler surfaces.
- Representative files:
  - `android/src/main/java/com/mjstudio/reactnativenavermap/mapview/RNCNaverMapViewManager.kt`
  - `android/src/main/java/com/mjstudio/reactnativenavermap/overlay/*/*Manager.kt`

### Commands

- Handle commands through `receiveCommand(view, commandId, args)`.
- Keep string command IDs aligned with the `supportedCommands` list from the TypeScript spec.
- Parse `ReadableArray` arguments conservatively and fall back safely when a value is absent.

Example skeleton:

```kotlin
override fun receiveCommand(
  view: RNCNaverMapView,
  commandId: String,
  args: ReadableArray?
) {
  when (commandId) {
    "animateCameraTo" -> {
      val latitude = args?.getDouble(0) ?: return
      val longitude = args?.getDouble(1) ?: return
      val duration = args?.getInt(2) ?: 300
      view.animateCameraTo(latitude, longitude, duration)
    }
  }
}
```

### Events

- Register direct events through shared helpers such as `registerDirectEvent(...)`.
- Emit native events through the shared event classes and helper path instead of open-coding `RCTEventEmitter` logic in every component.
- Under the hood, the Android path still flows through `ReactContext`, `Arguments.createMap()`, and `RCTEventEmitter`-compatible event delivery.
- Representative helpers:
  - `android/src/main/java/com/mjstudio/reactnativenavermap/util/ViewEventEmitter.kt`
  - `android/src/main/java/com/mjstudio/reactnativenavermap/util/DirectEventUtils.kt`

Example skeleton:

```kotlin
private fun emitTapEvent(view: View) {
  val reactContext = view.context as ReactContext
  val event = Arguments.createMap().apply {
    putDouble("latitude", marker.position.latitude)
    putDouble("longitude", marker.position.longitude)
  }

  reactContext
    .getJSModule(RCTEventEmitter::class.java)
    .receiveEvent(view.id, "onTapOverlay", event)
}
```

### Package Registration

- `android/src/main/java/com/mjstudio/reactnativenavermap/RNCNaverMapPackage.kt` is the package registration point.
- The package implements `ReactPackage`.
- `createViewManagers()` currently registers the map view plus all overlay managers.
- `createNativeModules()` currently returns `emptyList()`.

Example skeleton:

```kotlin
class RNCNaverMapPackage : ReactPackage {
  override fun createViewManagers(
    reactContext: ReactApplicationContext
  ): List<ViewManager<*, *>> = listOf(
    RNCNaverMapViewManager(),
    RNCNaverMapMarkerManager()
  )

  override fun createNativeModules(
    reactContext: ReactApplicationContext
  ): List<NativeModule> = emptyList()
}
```

## Native Image Handling

### Supported Image Shapes

The native image pipeline supports these image forms:

- `symbol`
- `rnAssetUri`
- `httpUri`
- `assetName`
- custom view rendered into an image

### Shared Rules

- Prefer a stable `reuseIdentifier` when an image should participate in native caching.
- Cancel pending image work during teardown.
- Keep image-loading behavior symmetric across iOS and Android where possible.

### iOS

- Use `nmap::getImage(...)` from `ios/Util/Image/ImageUtil.h`.
- Network and asset-backed images derive cache keys from `reuseIdentifier` when available.
- Marker and ground overlays store cancellers and clear them on cleanup.
- Custom marker views are rasterized with `UIGraphicsImageRenderer`.

Example skeleton:

```objc
_imageCanceller = nmap::getImage([self bridge], imageStruct, ^(NMFOverlayImage* image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.inner.iconImage = image;
    self.inner.alpha = 1;
  });
});
```

### Android

- Use `getOverlayImage(...)` from `android/src/main/java/com/mjstudio/reactnativenavermap/util/image/GetOverlayImage.kt`.
- The Android path uses Fresco and `DraweeHolder`.
- Cache keys also derive from `reuseIdentifier` when available.
- Custom marker views are rendered into `Bitmap` objects and must recycle those bitmaps during teardown.

Example skeleton:

```kotlin
getOverlayImage(imageHolder, context, imageMap) { overlayImage ->
  overlay.icon = overlayImage ?: OverlayImage.fromBitmap(createBitmap(1, 1))
  overlay.alpha = 1f
}
```

## Corrected Legacy Notes

- Older guidance about docs should now be read together with the actual docs site structure under `docs/content/docs/` and `docs/src/`.
- Older references to reusable `/pattern-use ...` names are now represented directly in this knowledge base instead of living behind a separate shortcut layer.
- The current source of truth for commands and build scripts is the repo itself. When an older note conflicts with `package.json`, `lefthook.yml`, or the native source, prefer the current code and keep this document updated.

## Related Documents

- JS/spec guidance: `areas/source-surface.md`
- Native platform guidance: `areas/native-platforms.md`
- Package and docs-site guidance: `areas/supporting-packages.md`
