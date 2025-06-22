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
////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  geometries: Readonly<{
    coords: ReadonlyArray<Coord>
    holes: ReadonlyArray<ReadonlyArray<Coord>>
  }>
  color?: CodegenTypes.Int32
  outlineColor?: CodegenTypes.Int32
  outlineWidth?: CodegenTypes.Double
}

export default codegenNativeComponent<Props>('RNCNaverMapPolygon')
