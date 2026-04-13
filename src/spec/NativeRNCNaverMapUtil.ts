import { type TurboModule, TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  createInfoWindow(id: string): void;
  destroyInfoWindow(id: string): void;
  closeInfoWindow(id: string): void;
  setInfoWindowContent(id: string, title: string, subtitle?: string): void;
  isInfoWindowOpen(id: string): boolean;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCNaverMapUtil');
