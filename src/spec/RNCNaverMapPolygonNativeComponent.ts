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
  isHidden: WithDefault<boolean, false>;
  minZoom: Double;
  maxZoom: Double;
  isMinZoomInclusive: WithDefault<boolean, true>;
  isMaxZoomInclusive: WithDefault<boolean, true>;
}

type Coord = {
  latitude: Double;
  longitude: Double;
};
////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  geometries: Readonly<{
    coords: ReadonlyArray<Coord>;
    holes: ReadonlyArray<ReadonlyArray<Coord>>;
  }>;
  color?: Int32;
  outlineColor?: Int32;
  outlineWidth?: Double;
}

export default codegenNativeComponent<Props>('RNCNaverMapPolygon');
