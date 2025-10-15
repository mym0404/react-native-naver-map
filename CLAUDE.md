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

## Essential Development Commands

Key npm scripts for library development workflow.

**Type Checking & Linting:**
```bash
pnpm run t              # Run all checks via Lefthook
pnpm format             # Format code using Lefthook formatters
```

**Development Server:**
```bash
pnpm dev                # Start Metro bundler for example app
pnpm ios                # Run example app on iOS simulator
pnpm android            # Run example app on Android emulator
pnpm studio             # Open Android Studio for example project
pnpm xcode              # Open Xcode workspace for example project
```

**Code Generation:**
```bash
pnpm codegen            # Generate codegen for both platforms
pnpm codegen:ios        # Generate iOS codegen only
pnpm codegen:android    # Generate Android codegen only
```

**Native Dependencies:**
```bash
pnpm pod                # Install iOS dependencies (bundle + pod install)
pnpm pod:update         # Update iOS dependencies (bundle + pod update)
```

**Build & Release:**
```bash
pnpm build              # Full build: Expo plugin + docs + library
pnpm prepack            # Runs before npm pack (same as build)
pnpm build:expo-config-plugin  # Build Expo config plugin only
pnpm build:docs         # Build documentation site
pnpm release            # Execute release script
```

**CI/CD:**
```bash
pnpm ci:ios             # Build iOS for CI (optimized xcodebuild)
pnpm ci:android         # Build Android for CI (gradlew assembleDebug)
pnpm turbo:ios          # Cached iOS CI build (uses .turbo/ios)
pnpm turbo:android      # Cached Android CI build (uses .turbo/android)
```

**Documentation:**
```bash
pnpm docs:dev           # Start docs development server
```

**Rules:**
- Use `pnpm run t` to run all checks (Lefthook manages checks)
- Run `pnpm codegen` after modifying spec files
- Use `pnpm pod` after changing iOS native dependencies

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
- Define Fabric components using `codegenNativeComponent`
- Use codegen types: `WithDefault`, `DirectEventHandler`, `Double`, `Int32`, `Readonly`
- Pattern reference: `/pattern-use fabric-native-component`

### Commands Specification
- Define imperative methods using `codegenNativeCommands`
- Support async methods that return Promises
- Pattern reference: `/pattern-use codegen-native-commands`

### TurboModule Specification
- Define native modules using TurboModule interface
- Use `TurboModuleRegistry.getEnforcing()` for module access
- Pattern reference: `/pattern-use turbo-module-spec`

### Codegen Types
- `Double` - 64-bit floating point
- `Int32` - 32-bit integer
- `WithDefault<T, Default>` - Type with default value
- `DirectEventHandler<T>` - Event callback type
- `Readonly<T>` - Immutable object type

## iOS

### Fabric Component Implementation
- Extend `RCTViewComponentView` for native components
- Implement `initWithFrame`, `updateProps` methods
- Pattern reference: `/pattern-use ios-fabric-component`

### Commands Implementation
- Handle imperative commands through `handleCommand`
- Use generated command handler functions
- Pattern reference: `/pattern-use ios-command-handling`

### Event Emission
- Emit events using generated event emitters
- Access emitter through component view
- Pattern reference: `/pattern-use ios-event-emission`

### TurboModule Implementation
- Conditional Bridge/TurboModule support with preprocessor macros
- Implement both legacy and new arch interfaces
- Pattern reference: `/pattern-use ios-turbo-module`

## Android

### ViewManager with Codegen
- Extend generated spec classes using delegate pattern
- Use ViewGroupManager or SimpleViewManager based on component type
- Pattern reference: `/pattern-use android-view-manager-spec`

### Commands Implementation
- Handle commands through generated interface
- Use `receiveCommand` with command ID matching
- Pattern reference: `/pattern-use android-command-handling`

### Event Emission
- Emit events using ReactContext and RCTEventEmitter
- Create event data with Arguments.createMap()
- Pattern reference: `/pattern-use android-event-emission`

### Package Registration
- Register modules in ReactPackage implementation
- Pattern reference: `/pattern-use android-package-registration`

### Build System
- **TypeScript**: Strict configuration with path mappings
- **React Native Builder Bob**: Builds CommonJS, ES modules, and TypeScript declarations
- **Biome**: Linting and formatting for JavaScript/TypeScript
- **Lefthook**: Git hooks for pre-commit validation
- **Native Linting**: ClangFormat for iOS, Ktlint for Android

### Development Workflow
1. Make changes to TypeScript source in `src/`
2. Run `pnpm codegen` to regenerate native interfaces if needed
3. Test in example app with `pnpm dev` then `pnpm android`/`pnpm ios`
4. Run `pnpm lint` to validate all code
5. Use `pnpm prepack` to build the full package

### Testing Setup
To test the library, you need to configure API keys:
- Android: `example/android/app/src/main/res/values/secret.xml`
- iOS: `example/ios/Secret.xcconfig`

## Development Notes

- The library requires React Native 0.74+ and New Architecture enabled
- New Architecture (Fabric) is mandatory in v2.x - no Bridge support
- Uses Conventional Commits for commit messages
- Documentation is auto-generated from JSDoc comments
- All native code changes require both iOS and Android implementations
- Codegen runs automatically on build - regenerate with `pnpm codegen` if specs change

# JSDoc Documentation

- Write JSDoc documentation for all public APIs
- Key tags: `@param`, `@returns`, `@example`, `@default`, `@internal`, `@platform`
- Pattern reference: `/pattern-use jsdoc`

# Package Scripts

## Development Scripts
- `pnpm dev` - Start development server for example app
- `pnpm ios` - Run example app on iOS simulator
- `pnpm android` - Run example app on Android emulator
- `pnpm studio` - Open Android Studio for the example project
- `pnpm xcode` - Open Xcode workspace for the example project

## Code Quality & Testing
- `pnpm typecheck` - Run TypeScript type checking without emitting files
- `pnpm run t` - Run all linting checks (uses Lefthook)
- `pnpm format` - Format code using configured formatters (Biome)

## Build & Release
- `pnpm prepack` - Full build process: Expo plugin + docs + library build
- `pnpm build:expo-config-plugin` - Build Expo configuration plugin
- `pnpm build:docs` - Generate documentation
- `pnpm clean` - Clean all build directories
- `pnpm release` - Execute release script

## Native Development
- `pnpm codegen` - Generate native codegen artifacts for both platforms
- `pnpm codegen:android` - Generate Android codegen artifacts only
- `pnpm codegen:ios` - Generate iOS codegen artifacts only
- `pnpm pod` - Install iOS dependencies via CocoaPods
- `pnpm pod:update` - Update iOS dependencies via CocoaPods

## CI/CD & Turbo Scripts
- `pnpm ci:ios` - Build iOS project for CI (xcodebuild with optimized settings)
- `pnpm ci:android` - Build Android project for CI (gradlew assembleDebug)
- `pnpm turbo:ios` - Run iOS CI build with Turbo cache (cached in .turbo/ios)
- `pnpm turbo:android` - Run Android CI build with Turbo cache (cached in .turbo/android)

**Turbo Scripts Usage:**
- Turbo scripts provide cached builds for faster development iteration
- `turbo:ios` and `turbo:android` use single-package mode with platform-specific cache directories
- Cache helps avoid repeated builds when no source changes occur
- Useful for CI/CD pipelines and local development optimization

# Coding Patterns and Guidelines

[GUIDE LIST]

### Fabric Native Component Definition (TypeScript)

Defines React Native Fabric components using `codegenNativeComponent` with type-safe props interface.

**Rules:**
- Import types from `react-native/Libraries/Types/CodegenTypes`
- Use codegen types: `Double`, `Int32`, `WithDefault<T, Default>`, `DirectEventHandler<T>`, `Readonly<T>`
- Extend `ViewProps` interface for component props
- Redeclare imported types locally due to codegen parser limitations
- Export component using `codegenNativeComponent<Props>()`

**Good:**
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

**When to apply:**
- Creating new Fabric native components
- Defining component prop interfaces for native views
- Adding event handlers to native components

### React Native Codegen Commands (TypeScript)

Defines imperative native methods using `codegenNativeCommands` for async/sync operations.

**Rules:**
- Define `NativeCommands` interface with method signatures
- Use `React.ElementRef<ComponentType>` as first parameter
- Support both void and Promise return types
- Export commands with `codegenNativeCommands<NativeCommands>()` and `supportedCommands` array

**Good:**
```typescript
interface NativeCommands {
  screenToCoordinate: (
    ref: React.ElementRef<ComponentType>,
    x: Double,
    y: Double
  ) => Promise<Readonly<{
    isValid: boolean;
    latitude: Double;
    longitude: Double;
  }>>;
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

**When to apply:**
- Adding imperative methods to native components
- Implementing async operations that return values
- Creating command interfaces for native modules

### iOS Fabric Component Implementation (Objective-C++)

iOS Fabric component implementation extending `RCTViewComponentView` with props handling.

**Rules:**
- Extend `RCTViewComponentView` for Fabric components
- Implement `initWithFrame:` to initialize with default props
- Implement `updateProps:oldProps:` to handle prop changes
- Compare old and new props before updating native properties
- Use `std::static_pointer_cast` to cast props to component-specific type
- Access event emitter through `_eventEmitter` cast to component emitter type

**Good:**
```objc
@implementation RNCNaverMapPath

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapPathProps>();
    _props = defaultProps;
    _inner = [NMFPath new];
  }
  return self;
}

- (std::shared_ptr<RNCNaverMapPathEventEmitter const>)emitter {
  if (!_eventEmitter) return nullptr;
  return std::static_pointer_cast<RNCNaverMapPathEventEmitter const>(_eventEmitter);
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPathProps const>(props);

  if (prev.width != next.width)
    _inner.width = next.width;
  if (prev.color != next.color)
    _inner.color = nmap::intToColor(next.color);

  [super updateProps:props oldProps:oldProps];
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPathComponentDescriptor>();
}

@end
```

**When to apply:**
- Implementing Fabric native components on iOS
- Handling prop updates efficiently
- Setting up native view lifecycle methods

### iOS Command Handling (Objective-C++)

iOS command handling implementation for processing imperative native commands.

**Rules:**
- Implement command methods as instance methods on component view
- Use generated command handler in `handleCommand:args:` method
- Command handler function format: `RCT{ComponentName}HandleCommand`
- Method parameters match TypeScript command definition

**Good:**
```objc
@implementation RNCNaverMapView

- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing {
  NMFCameraUpdate* update =
      [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)];
  update.animation = getEasingAnimation(easing);
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  [self.map moveCamera:update];
}

- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}

@end
```

**When to apply:**
- Implementing imperative command methods on iOS
- Processing commands triggered from JavaScript

### iOS Event Emission (Objective-C++)

iOS event emission using generated event emitter for sending events to JavaScript.

**Rules:**
- Access emitter through component's `_eventEmitter` member
- Cast to component-specific emitter type using `std::static_pointer_cast`
- Call event methods with struct containing event data
- Check emitter validity before emitting

**Good:**
```objc
- (std::shared_ptr<RNCNaverMapPathEventEmitter const>)emitter {
  if (!_eventEmitter) return nullptr;
  return std::static_pointer_cast<RNCNaverMapPathEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPath new];
    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      if (self.emitter) {
        self.emitter->onTapOverlay({});
        return YES;
      }
      return NO;
    };
  }
  return self;
}
```

**When to apply:**
- Sending events from native iOS code to JavaScript
- Implementing touch handlers and callbacks
- Notifying React about native state changes

### Android ViewManager with Codegen (Kotlin)

Android ViewManager implementation using codegen delegate pattern.

**Rules:**
- Extend generated spec class (e.g., `RNCNaverMapMarkerManagerSpec`)
- Use `ViewGroupManager` for view groups or `SimpleViewManager` for simple views
- Implement delegate pattern with generated manager delegate
- Override `getDelegate()` to return the delegate

**Good:**
```kotlin
abstract class RNCNaverMapMarkerManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(),
  RNCNaverMapMarkerManagerInterface<T> {

  private val mDelegate: ViewManagerDelegate<T> =
      RNCNaverMapMarkerManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
```

**When to apply:**
- Creating ViewManagers for Fabric components on Android
- Implementing prop handling with codegen delegate

### Android Command Handling (Kotlin)

Android command handling using `receiveCommand` method with command ID matching.

**Rules:**
- Override `receiveCommand(view, commandId, args)` method
- Use string command IDs to match commands
- Extract arguments from `ReadableArray` args parameter
- Implement command logic on the view instance

**Good:**
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
    "cancelAnimation" -> {
      view.cancelAnimation()
    }
  }
}
```

**When to apply:**
- Implementing imperative commands on Android ViewManagers
- Processing command requests from JavaScript

### Android Event Emission (Kotlin)

Android event emission using ReactContext and RCTEventEmitter.

**Rules:**
- Get `RCTEventEmitter` from ReactContext
- Create event data using `Arguments.createMap()`
- Emit events with view ID and event name
- Event names match TypeScript `DirectEventHandler` prop names

**Good:**
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

**When to apply:**
- Sending events from Android native code to JavaScript
- Implementing user interaction callbacks
- Notifying React about native state changes

### Android Package Registration (Kotlin)

Android ReactPackage registration for native modules and ViewManagers.

**Rules:**
- Implement `ReactPackage` interface
- Override `createViewManagers()` to register ViewManagers
- Override `createNativeModules()` to register native modules
- Return list of manager instances

**Good:**
```kotlin
class RNCNaverMapPackage : ReactPackage {
  override fun createViewManagers(
    reactContext: ReactApplicationContext
  ): List<ViewManager<*, *>> {
    return listOf(
      RNCNaverMapViewManager(),
      RNCNaverMapMarkerManager(),
      RNCNaverMapCircleManager()
    )
  }

  override fun createNativeModules(
    reactContext: ReactApplicationContext
  ): List<NativeModule> {
    return emptyList()
  }
}
```

**When to apply:**
- Registering native components and modules in Android
- Setting up ReactPackage for the library

### JSDoc Documentation (TypeScript)

JSDoc documentation patterns for TypeScript components and methods.

**Rules:**
- Document all public APIs with JSDoc comments
- Use `@param {Type} name - description` for parameters
- Use `@returns {Type} description` for return values
- Use `@example` for code examples
- Use `@default value` for default values
- Use `@platform ios|android` for platform-specific APIs
- Use `@internal` for internal/private APIs

**Good:**
```typescript
/**
 * Animates the camera to a specific coordinate.
 *
 * @param latitude - The target latitude
 * @param longitude - The target longitude
 * @param duration - Animation duration in milliseconds
 * @default 300
 * @example
 * ```tsx
 * mapRef.current?.animateCameraTo(37.5665, 126.9780, 500);
 * ```
 */
animateCameraTo: (
  latitude: number,
  longitude: number,
  duration?: number
) => void;
```

**When to apply:**
- Documenting public component APIs
- Writing method and function documentation
- Providing usage examples for developers

### Native Color Parsing (TypeScript)

TypeScript color prop handling with `processColor` and native color utilities.

**Rules:**
- Use `processColor()` from `react-native` to convert color values
- Accept `ColorValue` type for color props
- Convert to `Int32` for native consumption
- Handle null/undefined color values

**Good:**
```typescript
import { processColor, type ColorValue } from 'react-native';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  tintColor?: Int32;
  outlineColor?: Int32;
}

// Usage in component
const nativeProps = {
  tintColor: processColor(props.tintColor) as Int32,
  outlineColor: processColor(props.outlineColor) as Int32,
};
```

**When to apply:**
- Handling color props in native components
- Converting React Native color values to native integers
- Passing colors to native implementations

### Marker Image Handling (iOS/Android)

How to load marker images from different sources in native platforms.

**Rules:**
- iOS: Use `nmap::getImage()` helper with callback pattern
- Android: Use `getOverlayImage()` with DraweeHolder for Fresco
- Support 5 types: symbol, rnAssetUri, httpUri, assetName, custom view
- Use `reuseIdentifier` for caching
- Cancel pending requests on cleanup

**iOS Usage (Objective-C++):**
```objc
// Store canceller
RNCNaverMapImageCanceller _imageCanceller;

// Load image
_imageCanceller = nmap::getImage([self bridge], imageStruct, ^(NMFOverlayImage* image) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.inner.iconImage = image;
    self.inner.alpha = 1;
  });
});

// Cancel on cleanup
if (_imageCanceller) {
  _imageCanceller();
  _imageCanceller = nil;
}

// Custom view to image
- (UIImage*)captureView:(UIView*)view {
  UIGraphicsImageRenderer* renderer = [[UIGraphicsImageRenderer alloc] initWithSize:view.bounds.size];
  return [renderer imageWithActions:^(UIGraphicsImageRendererContext* ctx) {
    [view.layer renderInContext:ctx.CGContext];
  }];
}
```

**Android Usage (Kotlin):**
```kotlin
// Store DraweeHolder
private val imageHolder = DraweeHolder.create(...)

// Load image
getOverlayImage(imageHolder, context, imageMap) { overlayImage ->
  overlay.icon = overlayImage ?: OverlayImage.fromBitmap(createBitmap(1, 1))
  overlay.alpha = 1f
}

// Custom view to bitmap
private fun updateCustomView() {
  val bitmap = createBitmap(overlay.width, overlay.height, Bitmap.Config.ARGB_4444)
  bitmap.eraseColor(Color.TRANSPARENT)
  val canvas = Canvas(bitmap)
  draw(canvas)
  overlay.icon = OverlayImage.fromBitmap(bitmap)
}

// Cleanup
override fun onDropViewInstance() {
  imageHolder.onDetach()
  customViewBitmap?.recycle()
}
```

**Image Types:**
- `symbol`: Built-in markers (green, blue, red, yellow, black, etc.)
- `rnAssetUri`: React Native require() assets
- `httpUri`: Network images (HTTP/HTTPS)
- `assetName`: Native bundle/drawable resources
- Custom view: React component rendered to image

**When to apply:**
- Implementing overlay components with image support
- Loading marker icons from different sources
- Converting custom React views to native images

[GUIDE LIST END]

