import {
  CodegenTypes,
  codegenNativeComponent,
  type ViewProps,
} from 'react-native'

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

interface BaseOverlay {
  zIndexValue: CodegenTypes.Int32
  globalZIndexValue: CodegenTypes.Int32
  isHidden: boolean
  minZoom: CodegenTypes.Double
  maxZoom: CodegenTypes.Double
  isMinZoomInclusive: boolean
  isMaxZoomInclusive: boolean
}

type Coord = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
}
type NativeImageProp =
  | undefined
  | Readonly<{
      symbol?: string
      rnAssetUri?: string
      httpUri?: string
      assetName?: string
      reuseIdentifier?: string
    }>

////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  coords: ReadonlyArray<Coord>
  width?: CodegenTypes.Double
  outlineWidth?: CodegenTypes.Double
  patternInterval?: CodegenTypes.Int32
  patternImage?: NativeImageProp
  progress?: CodegenTypes.Double
  color?: CodegenTypes.Int32
  passedColor?: CodegenTypes.Int32
  outlineColor?: CodegenTypes.Int32
  passedOutlineColor?: CodegenTypes.Int32
  isHideCollidedSymbols?: boolean
  isHideCollidedMarkers?: boolean
  isHideCollidedCaptions?: boolean
}

export default codegenNativeComponent<Props>('RNCNaverMapPath')
