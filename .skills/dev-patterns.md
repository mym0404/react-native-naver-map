# NaverMap Dev Patterns

This file is a quick pattern reference extracted from `CLAUDE.md`.
Use this when implementing native-spec-linked features and when you need concrete code shapes.

## TypeScript: Fabric Native Component Spec

Rules:
- Define props with codegen types (`Double`, `Int32`, `WithDefault`, `DirectEventHandler`).
- Keep component spec files in `src/spec/` as source of truth.
- Use `codegenNativeComponent<Props>()`.

```ts
import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  coord: Readonly<{ latitude: Double; longitude: Double }>;
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  isHidden?: WithDefault<boolean, false>;
  tintColor?: Int32;
}

export default codegenNativeComponent<Props>('RNCNaverMapMarker');
```

## TypeScript: Native Commands Spec

Rules:
- Define imperative methods via `codegenNativeCommands`.
- First arg is always `React.ElementRef<ComponentType>`.
- Keep command names aligned with native handlers.

```ts
interface NativeCommands {
  animateCameraTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double,
    duration?: Int32
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['animateCameraTo'],
});
```

## TypeScript: TurboModule Spec

Rules:
- Define module interface with `TurboModule`.
- Access via `TurboModuleRegistry.getEnforcing()`.

```ts
import { type TurboModule, TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  createInfoWindow(id: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCNaverMapUtil');
```

## iOS: Fabric Component Pattern

Rules:
- Extend `RCTViewComponentView`.
- Implement `initWithFrame`, `updateProps`.
- Cast props/emitter safely.

```objc
- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<MyProps const>(_props);
  const auto& next = *std::static_pointer_cast<MyProps const>(props);

  if (prev.width != next.width) {
    _inner.width = next.width;
  }

  [super updateProps:props oldProps:oldProps];
}
```

## iOS: Command Handling

Rules:
- Implement command methods on component view.
- Route commands through generated handler.

```objc
- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTMyComponentHandleCommand(self, commandName, args);
}
```

## Android: ViewManager + Codegen Delegate

Rules:
- Extend generated manager spec class.
- Use generated delegate.

```kt
abstract class MyManagerSpec<T : ViewGroup> : ViewGroupManager<T>(), MyManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T> = MyManagerDelegate(this)
  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
```

## Android: Event Emission Pattern

Rules:
- Emit via ReactContext JS module.
- Event names must match TS `DirectEventHandler` props.

```kt
val event = Arguments.createMap().apply {
  putDouble("latitude", marker.position.latitude)
  putDouble("longitude", marker.position.longitude)
}

reactContext
  .getJSModule(RCTEventEmitter::class.java)
  .receiveEvent(view.id, "onTapOverlay", event)
```

## TypeScript: Color Prop to Native Int

Rules:
- Accept `ColorValue` on JS side.
- Convert with `processColor` before passing native prop.

```ts
import { processColor, type ColorValue } from 'react-native';

const tintColorNative = processColor(tintColor as ColorValue) as number;
```

## JSDoc Baseline

Public APIs should include:
- `@param`
- `@returns`
- `@example`
- `@default`
- `@platform` (when platform-scoped)

## Marker Image Handling (Native)

Rules:
- Support symbol, RN asset, HTTP URL, native asset, and custom view cases.
- Cancel pending image work on cleanup.
- Keep behavior parity between iOS and Android implementations.

---

For full details and extended examples, see `CLAUDE.md`.
