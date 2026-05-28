import { type TurboModule, TurboModuleRegistry } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  createInfoWindow(id: string): void;
  destroyInfoWindow(id: string): void;
  closeInfoWindow(id: string): void;
  setInfoWindowContent(id: string, text: string): void;
  setInfoWindowOptions(
    id: string,
    anchorX: Double,
    anchorY: Double,
    offsetX: Double,
    offsetY: Double,
    alpha: Double
  ): void;
  isInfoWindowOpen(id: string): boolean;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCNaverMapUtil');
