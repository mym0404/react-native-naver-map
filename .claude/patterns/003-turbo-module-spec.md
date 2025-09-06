# turbo-module-spec

# TurboModule Specification

## Usage

```typescript
import { type TurboModule, TurboModuleRegistry } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  setGlobalZIndex(type: string, zIndex: Double): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCNaverMapUtil');
```