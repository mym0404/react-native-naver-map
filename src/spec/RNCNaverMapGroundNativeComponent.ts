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

export type NativeImageProp =
  | undefined
  | Readonly<{
      symbol?: string
      rnAssetUri?: string
      httpUri?: string
      assetName?: string
      reuseIdentifier?: string
    }>
type Region = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
  latitudeDelta: CodegenTypes.Double
  longitudeDelta: CodegenTypes.Double
}

////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  image: NativeImageProp
  region: Region
}

export default codegenNativeComponent<Props>('RNCNaverMapGround')
