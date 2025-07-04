import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
  WithDefault,
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

type Coord = {
  latitude: Double;
  longitude: Double;
};
////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  coords: ReadonlyArray<Coord>;
  width?: Double;
  color?: Int32;
  pattern?: ReadonlyArray<Int32>;
  capType?: WithDefault<'Round' | 'Butt' | 'Square', 'Round'>;
  joinType?: WithDefault<'Bevel' | 'Miter' | 'Round', 'Round'>;
}

export default codegenNativeComponent<Props>('RNCNaverMapPolyline');
