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
  isHidden?: WithDefault<boolean, false>;
  minZoom: Double;
  maxZoom: Double;
  isMinZoomInclusive?: WithDefault<boolean, true>;
  isMaxZoomInclusive?: WithDefault<boolean, true>;
}

type Coord = {
  latitude: Double;
  longitude: Double;
};

type PathPart = {
  coords: ReadonlyArray<Coord>;
  color: Int32;
  passedColor: Int32;
  outlineColor: Int32;
  passedOutlineColor: Int32;
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
  pathParts: ReadonlyArray<PathPart>;
  width?: Double;
  outlineWidth?: Double;
  patternInterval?: Int32;
  patternImage?: NativeImageProp;
  isHideCollidedSymbols?: WithDefault<boolean, false>;
  isHideCollidedMarkers?: WithDefault<boolean, false>;
  isHideCollidedCaptions?: WithDefault<boolean, false>;
}

export default codegenNativeComponent<Props>('RNCNaverMapMultiPath');
