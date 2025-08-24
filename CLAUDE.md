# Project Architecture

This is a React Native library that provides Naver Map components with native implementations for both iOS and Android platforms.

## Core Structure
- **TypeScript React Native Library** using New Architecture (Fabric) exclusively in v2.x
- **Native Modules**: iOS (Objective-C++) and Android (Kotlin) implementations
- **Code Generation**: Uses React Native's codegen for type-safe native interfaces
- **Expo Support**: Includes config plugin for Expo projects

## Key Directories
- `src/` - TypeScript source code
  - `component/` - React components (NaverMapView, overlays)
  - `types/` - TypeScript type definitions
  - `spec/` - React Native codegen specifications
  - `util/` - Utility functions
- `ios/` - iOS native implementation (Objective-C++)
- `android/` - Android native implementation (Kotlin)
- `example/` - Example React Native app for testing
- `expo-config-plugin/` - Expo configuration plugin

## Native SDK Dependencies
- **iOS**: NMapsMap (Naver Maps iOS SDK)
  - [iOS SDK Guide](https://navermaps.github.io/ios-map-sdk/guide-ko/)
- **Android**: Naver Maps Android SDK
  - [Android SDK Guide](https://navermaps.github.io/android-map-sdk/guide-ko/)

## Component Architecture
The library provides React components that wrap native map views:
- `NaverMapView` - Main map component
- Various overlay components (Marker, Circle, Polygon, Path, etc.)
- Each component uses React Native's Fabric architecture for direct native rendering

# Native Module Codegen Integration

## TypeScript

### Native Component Specifications
Define Fabric components using `codegenNativeComponent`:

```typescript
// src/spec/RNCNaverMapViewNativeComponent.ts
import { codegenNativeComponent, type HostComponent, type ViewProps } from 'react-native';
import type { DirectEventHandler, Double, Int32, WithDefault } from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  mapType?: WithDefault<'Basic' | 'Satellite' | 'Hybrid', 'Basic'>;
  initialCamera?: Readonly<{
    latitude: Double;
    longitude: Double;
    zoom?: Double;
  }>;
  onCameraChanged?: DirectEventHandler<Readonly<{
    latitude: Double;
    longitude: Double;
    zoom: Double;
  }>>;
}

export default codegenNativeComponent<Props>('RNCNaverMapView');
```

### Commands Specification
Define imperative methods using `codegenNativeCommands`:

```typescript
interface NaverMapNativeCommands {
  screenToCoordinate: (ref: React.ElementRef<ComponentType>, x: Double, y: Double) => Promise<{
    latitude: Double;
    longitude: Double;
  }>;
  animateCameraTo: (ref: React.ElementRef<ComponentType>, latitude: Double, longitude: Double, zoom?: Double) => void;
}

export const Commands: NaverMapNativeCommands = codegenNativeCommands<NaverMapNativeCommands>({
  supportedCommands: ['screenToCoordinate', 'animateCameraTo']
});
```

### TurboModule Specification
Define native modules using TurboModule interface:

```typescript
// src/spec/NativeRNCNaverMapUtil.ts
import { type TurboModule, TurboModuleRegistry } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  setGlobalZIndex(type: string, zIndex: Double): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCNaverMapUtil');
```

### Codegen Types
Key types for codegen specifications:
- `Double` - 64-bit floating point
- `Int32` - 32-bit integer
- `WithDefault<T, Default>` - Type with default value
- `DirectEventHandler<T>` - Event callback type
- `Readonly<T>` - Immutable object type

## iOS

### Fabric Component Implementation
Extend `RCTViewComponentView` for native components:

```objc
// ios/RNCNaverMapView.h
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>

@interface RNCNaverMapView : RCTViewComponentView
- (std::shared_ptr<facebook::react::RNCNaverMapViewEventEmitter const>)emitter;
@end

// ios/RNCNaverMapView.mm
@implementation RNCNaverMapView {
  RNCNaverMapViewImpl* _view;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapViewProps>();
    _props = defaultProps;
    _view = [[RNCNaverMapViewImpl alloc] init];
    self.contentView = _view;
  }
  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
  const auto &oldViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);

  if (oldViewProps.mapType != newViewProps.mapType) {
    // Update native map type
  }

  [super updateProps:props oldProps:oldProps];
}
```

### Commands Implementation
Handle imperative commands through `handleCommand`:

```objc
- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}

void RCTRNCNaverMapViewHandleCommand(RNCNaverMapView *componentView, NSString const *commandName, NSArray const *args) {
  if ([commandName isEqualToString:@"screenToCoordinate"]) {
    double x = [args[0] doubleValue];
    double y = [args[1] doubleValue];
    // Convert screen coordinates to lat/lng and resolve promise
  }
}
```

### Event Emission
Emit events using generated event emitters:

```objc
- (void)onCameraChanged:(NMFCameraPosition *)position {
  if (auto emitter = [self emitter]) {
    facebook::react::RNCNaverMapViewEventEmitter::OnCameraChanged event;
    event.latitude = position.target.latitude;
    event.longitude = position.target.longitude;
    event.zoom = position.zoom;
    emitter->onCameraChanged(event);
  }
}
```

### TurboModule Implementation
Conditional Bridge/TurboModule support:

```objc
// ios/Module/RNCNaverMapUtil.h
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapSpec.h"
@interface RNCNaverMapUtil : NSObject <NativeRNCNaverMapUtilSpec>
#else
#import <React/RCTBridgeModule.h>
@interface RNCNaverMapUtil : NSObject <RCTBridgeModule>
#endif

// ios/Module/RNCNaverMapUtil.mm
@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

- (void)setGlobalZIndex:(NSString *)type zIndex:(double)zIndex {
  // Implementation
}

@end
```

## Android

### ViewManager with Codegen
Extend generated spec classes using delegate pattern:

```kotlin
// android/src/newarch/RNCNaverMapViewManagerSpec.kt
abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(), RNCNaverMapViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T> = RNCNaverMapViewManagerDelegate(this)
  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}

// android/src/main/java/.../RNCNaverMapViewManager.kt
class RNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {

  override fun getName(): String = "RNCNaverMapView"

  override fun createViewInstance(reactContext: ThemedReactContext): RNCNaverMapViewWrapper {
    return RNCNaverMapViewWrapper(reactContext)
  }

  @ReactProp(name = "mapType", defaultValue = "Basic")
  override fun setMapType(view: RNCNaverMapViewWrapper?, value: String?) {
    view?.setMapType(value)
  }

  @ReactProp(name = "initialCamera")
  override fun setInitialCamera(view: RNCNaverMapViewWrapper?, value: ReadableMap?) {
    value?.let { view?.setInitialCamera(it) }
  }
}
```

### Commands Implementation
Handle commands through generated interface:

```kotlin
override fun receiveCommand(root: RNCNaverMapViewWrapper, commandId: String, args: ReadableArray?) {
  when (commandId) {
    "screenToCoordinate" -> {
      val x = args?.getDouble(0) ?: 0.0
      val y = args?.getDouble(1) ?: 0.0
      // Convert and resolve promise
    }
    "animateCameraTo" -> {
      val latitude = args?.getDouble(0) ?: 0.0
      val longitude = args?.getDouble(1) ?: 0.0
      root.animateCameraTo(latitude, longitude)
    }
  }
}
```

### Event Emission
Emit events using ReactContext:

```kotlin
private fun emitCameraChangeEvent(view: RNCNaverMapViewWrapper, position: CameraPosition) {
  val event = Arguments.createMap().apply {
    putDouble("latitude", position.target.latitude)
    putDouble("longitude", position.target.longitude)
    putDouble("zoom", position.zoom)
  }

  (view.context as ReactContext)
    .getJSModule(RCTEventEmitter::class.java)
    .receiveEvent(view.id, "onCameraChanged", event)
}
```

### Package Registration
Register modules in ReactPackage:

```kotlin
class RNCNaverMapPackage : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return listOf(RNCNaverMapUtilModule(reactContext))
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return listOf(RNCNaverMapViewManager())
  }
}
```

### Build System
- **TypeScript**: Strict configuration with path mappings
- **React Native Builder Bob**: Builds CommonJS, ES modules, and TypeScript declarations
- **Biome**: Linting and formatting for JavaScript/TypeScript
- **Lefthook**: Git hooks for pre-commit validation
- **Native Linting**: ClangFormat for iOS, Ktlint for Android

### Development Workflow
1. Make changes to TypeScript source in `src/`
2. Run `yarn codegen` to regenerate native interfaces if needed
3. Test in example app with `yarn dev` then `yarn android`/`yarn ios`
4. Run `yarn lint` to validate all code
5. Use `yarn prepack` to build the full package

### Testing Setup
To test the library, you need to configure API keys:
- Android: `example/android/app/src/main/res/values/secret.xml`
- iOS: `example/ios/Secret.xcconfig`

## Development Notes

- The library requires React Native 0.74+ and New Architecture enabled
- New Architecture (Fabric) is mandatory in v2.x - no Bridge support
- Uses Conventional Commits for commit messages
- Documentation is auto-generated with TypeDoc from JSDoc comments
- All native code changes require both iOS and Android implementations
- Codegen runs automatically on build - regenerate with `yarn codegen` if specs change
