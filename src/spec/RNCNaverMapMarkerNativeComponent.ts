import type { CodegenTypes, ViewProps } from 'react-native'
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent'

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

export type NativeCaptionProp = {
  key: string
  text: string
  requestedWidth?: CodegenTypes.Double
  align?: CodegenTypes.Int32
  offset?: CodegenTypes.Double
  color?: CodegenTypes.Int32
  haloColor?: CodegenTypes.Int32
  textSize?: CodegenTypes.Double
  minZoom?: CodegenTypes.Double
  maxZoom?: CodegenTypes.Double
}

export type NativeSubCaptionProp = {
  key: string
  text: string
  color?: CodegenTypes.Int32
  haloColor?: CodegenTypes.Int32
  textSize?: CodegenTypes.Double
  requestedWidth?: CodegenTypes.Double
  minZoom?: CodegenTypes.Double
  maxZoom?: CodegenTypes.Double
}

export type NativeImageProp = Readonly<{
  symbol?: string
  rnAssetUri?: string
  httpUri?: string
  assetName?: string
  reuseIdentifier?: string
}>

////////////////////

interface Props extends BaseOverlay, ViewProps {
  coord: Readonly<{
    latitude: CodegenTypes.Double
    longitude: CodegenTypes.Double
  }>
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  width?: CodegenTypes.Double
  height?: CodegenTypes.Double
  anchor?: Readonly<{ x: CodegenTypes.Double; y: CodegenTypes.Double }>
  angle?: CodegenTypes.Double
  isFlatEnabled?: boolean
  isIconPerspectiveEnabled?: boolean
  alpha?: CodegenTypes.Double
  isHideCollidedSymbols?: boolean
  isHideCollidedMarkers?: boolean
  isHideCollidedCaptions?: boolean
  isForceShowIcon?: boolean
  tintColor?: CodegenTypes.Int32
  image?: Readonly<NativeImageProp>
  caption?: Readonly<NativeCaptionProp>
  subCaption?: Readonly<NativeSubCaptionProp>
}

export default codegenNativeComponent<Props>('RNCNaverMapMarker')
