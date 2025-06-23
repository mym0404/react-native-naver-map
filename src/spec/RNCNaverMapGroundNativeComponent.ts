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

export type NativeImageProp =
  | undefined
  | Readonly<{
      symbol?: string;
      rnAssetUri?: string;
      httpUri?: string;
      assetName?: string;
      reuseIdentifier?: string;
    }>;
type Region = {
  latitude: Double;
  longitude: Double;
  latitudeDelta: Double;
  longitudeDelta: Double;
};

////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: DirectEventHandler<Readonly<{}>>;
  image: NativeImageProp;
  region: Region;
}

export default codegenNativeComponent<Props>('RNCNaverMapGround');
