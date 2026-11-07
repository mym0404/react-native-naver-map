import {
  codegenNativeCommands,
  codegenNativeComponent,
  type HostComponent,
  type ViewProps,
} from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

interface Props extends ViewProps {
  infoWindowId: string;
  anchorX: Double;
  anchorY: Double;
  offsetX: Double;
  offsetY: Double;
  alpha: Double;
}

type ComponentType = HostComponent<Props>;

interface NativeCommands {
  invalidateContent: (ref: React.ElementRef<ComponentType>) => void;
}

export default codegenNativeComponent<Props>('RNCNaverMapInfoWindow');
export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['invalidateContent'],
});
