import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

interface BaseOverlay {
  zIndexValue: Int32;
  globalZIndexValue: Int32;
  isHidden: boolean;
  minZoom: Double;
  maxZoom: Double;
  isMinZoomInclusive: boolean;
  isMaxZoomInclusive: boolean;
}

////////////////////

interface Props extends BaseOverlay, ViewProps {
  coord: Readonly<{
    latitude: Double;
    longitude: Double;
  }>;
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  radius?: Double;
  color?: Int32;
  outlineColor?: Int32;
  outlineWidth?: Double;
}

export default codegenNativeComponent<Props>('RNCNaverMapCircle');
