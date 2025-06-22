import {
  CodegenTypes,
  codegenNativeCommands,
  codegenNativeComponent,
  type HostComponent,
  type ViewProps,
} from 'react-native'

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

type Coord = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
}
type NativeImageProp = Readonly<{
  symbol?: string
  rnAssetUri?: string
  httpUri?: string
  assetName?: string
  reuseIdentifier?: string
}>

type ClusterMarker = Coord & {
  identifier: string
  image?: NativeImageProp
  width?: CodegenTypes.Double
  height?: CodegenTypes.Double
}
type Camera = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
  zoom?: CodegenTypes.Double
  tilt?: CodegenTypes.Double
  bearing?: CodegenTypes.Double
}
type Region = {
  latitude: CodegenTypes.Double
  longitude: CodegenTypes.Double
  latitudeDelta: CodegenTypes.Double
  longitudeDelta: CodegenTypes.Double
}
type LogoAlign = 'TopLeft' | 'TopRight' | 'BottomLeft' | 'BottomRight'
export type NativeClusterProp = {
  key: string
  width?: CodegenTypes.Double
  height?: CodegenTypes.Double
  markers: ClusterMarker[]
  screenDistance?: CodegenTypes.Double
  minZoom?: CodegenTypes.Double
  maxZoom?: CodegenTypes.Double
  animate?: boolean
}
export type NativeClustersProp = Readonly<{
  key: string
  clusters: ReadonlyArray<NativeClusterProp>
  isLeafTapCallbackExist: boolean
}>
export type NativeLocationOverlayProp = {
  isVisible?: boolean
  position?: Coord
  bearing?: CodegenTypes.Double
  image?: NativeImageProp
  imageWidth?: CodegenTypes.Double
  imageHeight?: CodegenTypes.Double
  anchor?: Readonly<{ x: CodegenTypes.Double; y: CodegenTypes.Double }>
  subImage?: NativeImageProp
  subImageWidth?: CodegenTypes.Double
  subImageHeight?: CodegenTypes.Double
  subAnchor?: Readonly<{ x: CodegenTypes.Double; y: CodegenTypes.Double }>
  circleRadius?: CodegenTypes.Double
  circleColor?: CodegenTypes.Int32
  circleOutlineWidth?: CodegenTypes.Double
  circleOutlineColor?: CodegenTypes.Int32
}

////////////////////

type PartialRect = Readonly<{
  top?: CodegenTypes.Double
  right?: CodegenTypes.Double
  bottom?: CodegenTypes.Double
  left?: CodegenTypes.Double
}>

interface Props extends ViewProps {
  mapType?: CodegenTypes.WithDefault<
    | 'Basic'
    | 'Navi'
    | 'Satellite'
    | 'Hybrid'
    | 'Terrain'
    | 'NaviHybrid'
    | 'None',
    'Basic'
  >

  layerGroups: CodegenTypes.Int32

  initialCamera?: Readonly<Camera>
  camera?: Readonly<Camera>

  initialRegion?: Readonly<Region>
  region?: Readonly<Region>

  animationDuration?: CodegenTypes.Int32
  animationEasing?: CodegenTypes.Int32 /*'EaseIn' | 'None' | 'Linear' | 'Fly' | 'EaseOut'*/

  isIndoorEnabled?: boolean
  isNightModeEnabled?: boolean
  isLiteModeEnabled?: boolean
  lightness?: CodegenTypes.Double
  buildingHeight?: CodegenTypes.Double
  symbolScale?: CodegenTypes.Double
  symbolPerspectiveRatio?: CodegenTypes.Double

  mapPadding?: PartialRect

  minZoom?: CodegenTypes.Double
  maxZoom?: CodegenTypes.Double

  isShowCompass?: boolean
  isShowScaleBar?: boolean
  isShowZoomControls?: boolean
  isShowIndoorLevelPicker?: boolean
  isShowLocationButton?: boolean

  logoAlign?: CodegenTypes.WithDefault<LogoAlign, 'BottomLeft'>
  logoMargin?: PartialRect
  // isLogoInteractionEnabled?: boolean;

  extent?: Readonly<Region>

  isScrollGesturesEnabled?: boolean
  isZoomGesturesEnabled?: boolean
  isTiltGesturesEnabled?: boolean
  isRotateGesturesEnabled?: boolean
  isUseTextureViewAndroid?: boolean
  isStopGesturesEnabled?: boolean

  locale?: string

  clusters?: NativeClustersProp
  fpsLimit?: CodegenTypes.Int32
  locationOverlay?: Readonly<NativeLocationOverlayProp>

  onInitialized?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  onOptionChanged?: CodegenTypes.DirectEventHandler<Readonly<{}>>
  onCameraChanged?: CodegenTypes.DirectEventHandler<
    Readonly<{
      latitude: CodegenTypes.Double
      longitude: CodegenTypes.Double
      zoom: CodegenTypes.Double
      tilt: CodegenTypes.Double
      bearing: CodegenTypes.Double
      reason: CodegenTypes.Int32 /* CameraChangeReason */
      regionLatitude: CodegenTypes.Double
      regionLongitude: CodegenTypes.Double
      regionLatitudeDelta: CodegenTypes.Double
      regionLongitudeDelta: CodegenTypes.Double
    }>
  >
  onCameraIdle?: CodegenTypes.DirectEventHandler<
    Readonly<{
      latitude: CodegenTypes.Double
      longitude: CodegenTypes.Double
      zoom: CodegenTypes.Double
      tilt: CodegenTypes.Double
      bearing: CodegenTypes.Double
      regionLatitude: CodegenTypes.Double
      regionLongitude: CodegenTypes.Double
      regionLatitudeDelta: CodegenTypes.Double
      regionLongitudeDelta: CodegenTypes.Double
    }>
  >
  onTapMap?: CodegenTypes.DirectEventHandler<
    Readonly<{
      latitude: CodegenTypes.Double
      longitude: CodegenTypes.Double
      x: CodegenTypes.Double
      y: CodegenTypes.Double
    }>
  >
  onTapClusterLeaf?: CodegenTypes.DirectEventHandler<
    Readonly<{ markerIdentifier: string }>
  >

  onScreenToCoordinate?: CodegenTypes.DirectEventHandler<
    Readonly<{
      isValid: boolean
      latitude: CodegenTypes.Double
      longitude: CodegenTypes.Double
    }>
  >
  onCoordinateToScreen?: CodegenTypes.DirectEventHandler<
    Readonly<{
      isValid: boolean
      screenX: CodegenTypes.Double
      screenY: CodegenTypes.Double
    }>
  >
}

type ComponentType = HostComponent<Props>

interface NaverMapNativeCommands {
  screenToCoordinate: (
    ref: React.ElementRef<ComponentType>,
    x: CodegenTypes.Double,
    y: CodegenTypes.Double
  ) => Promise<
    Readonly<{
      isValid: boolean
      latitude: CodegenTypes.Double
      longitude: CodegenTypes.Double
    }>
  >
  coordinateToScreen: (
    ref: React.ElementRef<ComponentType>,
    latitude: CodegenTypes.Double,
    longitude: CodegenTypes.Double
  ) => Promise<
    Readonly<{
      isValid: boolean
      screenX: CodegenTypes.Double
      screenY: CodegenTypes.Double
    }>
  >
  animateCameraTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: CodegenTypes.Double,
    longitude: CodegenTypes.Double,
    duration?: CodegenTypes.Int32,
    easing?: CodegenTypes.Int32 /*'EaseIn' | 'None' | 'Linear' | 'Fly' | 'EaseOut'*/,
    pivotX?: CodegenTypes.Double,
    pivotY?: CodegenTypes.Double,
    zoom?: CodegenTypes.Double
  ) => void
  animateCameraBy: (
    ref: React.ElementRef<ComponentType>,
    x: CodegenTypes.Double,
    y: CodegenTypes.Double,
    duration?: CodegenTypes.Int32,
    easing?: CodegenTypes.Int32 /*'Easing' | 'None' | 'Linear' | 'Fly'*/,
    pivotX?: CodegenTypes.Double,
    pivotY?: CodegenTypes.Double
  ) => void
  animateRegionTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: CodegenTypes.Double,
    longitude: CodegenTypes.Double,
    latitudeDelta: CodegenTypes.Double,
    longitudeDelta: CodegenTypes.Double,
    duration?: CodegenTypes.Int32,
    easing?: CodegenTypes.Int32 /*'Easing' | 'None' | 'Linear' | 'Fly'*/,
    pivotX?: CodegenTypes.Double,
    pivotY?: CodegenTypes.Double
  ) => void
  cancelAnimation: (ref: React.ElementRef<ComponentType>) => void
  setLocationTrackingMode: (
    ref: React.ElementRef<ComponentType>,
    mode: string
  ) => void
}

export default codegenNativeComponent<Props>('RNCNaverMapView')
export const Commands: NaverMapNativeCommands =
  codegenNativeCommands<NaverMapNativeCommands>({
    supportedCommands: [
      'screenToCoordinate',
      'coordinateToScreen',
      'animateCameraTo',
      'animateCameraBy',
      'cancelAnimation',
      'animateRegionTo',
      'setLocationTrackingMode',
    ],
  })
