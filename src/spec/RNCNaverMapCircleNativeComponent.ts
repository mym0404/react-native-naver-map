import {
  CodegenTypes,
  codegenNativeComponent,
  type ViewProps,
} from 'react-native';

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

interface BaseOverlay {
  zIndexValue: CodegenTypes.Int32;
  globalZIndexValue: CodegenTypes.Int32;
  isHidden: boolean;
  minZoom: CodegenTypes.Double;
  maxZoom: CodegenTypes.Double;
  isMinZoomInclusive: boolean;
  isMaxZoomInclusive: boolean;
}

////////////////////

interface Props extends BaseOverlay, ViewProps {
  coord: Readonly<{
    latitude: CodegenTypes.Double;
    longitude: CodegenTypes.Double;
  }>;
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>;
  radius?: CodegenTypes.Double;
  color?: CodegenTypes.Int32;
  outlineColor?: CodegenTypes.Int32;
  outlineWidth?: CodegenTypes.Double;
}

export default codegenNativeComponent<Props>('RNCNaverMapCircle');
