# codegen-native-commands

# React Native Codegen Commands

[EXPLANATION] Defines imperative native methods using codegenNativeCommands for async/sync operations

## Usage

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