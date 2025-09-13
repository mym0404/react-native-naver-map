---
keywords: fabric,codegenNativeComponent,HostComponent,ViewProps,DirectEventHandler
language: typescript
explanation: Defines React Native Fabric component using codegenNativeComponent with TypeScript props interface
---

# Fabric Native Component Definition

## Usage

```typescript
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