import type {
  Double,
  Int32,
  DirectEventHandler,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';

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
type NativeImageProp =
  | undefined
  | Readonly<{
      symbol?: string;
      rnAssetUri?: string;
      httpUri?: string;
      assetName?: string;
      reuseIdentifier?: string;
    }>;

////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  coords: ReadonlyArray<Coord>;
  width?: Double;
  outlineWidth?: Double;
  patternInterval?: Int32;
  patternImage?: NativeImageProp;
  progress?: Double;
  color?: Int32;
  passedColor?: Int32;
  outlineColor?: Int32;
  passedOutlineColor?: Int32;
  isHideCollidedSymbols?: boolean;
  isHideCollidedMarkers?: boolean;
  isHideCollidedCaptions?: boolean;
}

export default codegenNativeComponent<Props>('RNCNaverMapPath');
