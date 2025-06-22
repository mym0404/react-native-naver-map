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

type Coord = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
}
////////////////////

interface Props extends BaseOverlay, ViewProps {
  onTapOverlay?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  coords: ReadonlyArray<Coord>
  width?: CodegenTypes.Double
  color?: CodegenTypes.Int32
  pattern?: ReadonlyArray<CodegenTypes.Int32>
  capType?: CodegenTypes.WithDefault<'Round' | 'Butt' | 'Square', 'Round'>
  joinType?: CodegenTypes.WithDefault<'Bevel' | 'Miter' | 'Round', 'Round'>
}

export default codegenNativeComponent<Props>('RNCNaverMapPolyline')
