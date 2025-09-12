---
keywords: codegen, native, commands, react-native, async, sync
language: typescript
explanation: Defines imperative native methods using codegenNativeCommands for async/sync operations
---

# React Native Codegen Commands

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