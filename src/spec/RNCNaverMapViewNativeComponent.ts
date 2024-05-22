import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps, HostComponent } from 'react-native';
import type {
  DirectEventHandler,
  Int32,
  WithDefault,
  Double,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import React from 'react';

/* Type should be redeclared because of codegen ts parser doesn't allow imported type
 * [comments](https://github.com/reactwg/react-native-new-architecture/discussions/91#discussioncomment-4282452)
 */

type Coord = {
  latitude: Double;
  longitude: Double;
};
type NativeImageProp = Readonly<{
  symbol?: string;
  rnAssetUri?: string;
  httpUri?: string;
  assetName?: string;
  reuseIdentifier?: string;
}>;

type ClusterMarker = Coord & {
  identifier: string;
  image?: NativeImageProp;
  width?: Double;
  height?: Double;
};
type Camera = {
  latitude: Double;
  longitude: Double;
  zoom?: Double;
  tilt?: Double;
  bearing?: Double;
};
type Region = {
  latitude: Double;
  longitude: Double;
  latitudeDelta: Double;
  longitudeDelta: Double;
};
type LogoAlign = 'TopLeft' | 'TopRight' | 'BottomLeft' | 'BottomRight';
export type NativeClusterProp = {
  key: string;
  markers: ClusterMarker[];
  screenDistance?: Double;
  minZoom?: Double;
  maxZoom?: Double;
  animate?: boolean;
};
export type NativeClustersProp = Readonly<{
  key: string;
  clusters: ReadonlyArray<NativeClusterProp>;
  isLeafTapCallbackExist: boolean;
}>;
export type NativeLocationOverlayProp = {
  isVisible?: boolean;
  position?: Coord;
  bearing?: Double;
  image?: NativeImageProp;
  imageWidth?: Double;
  imageHeight?: Double;
  anchor?: Readonly<{ x: Double; y: Double }>;
  subImage?: NativeImageProp;
  subImageWidth?: Double;
  subImageHeight?: Double;
  subAnchor?: Readonly<{ x: Double; y: Double }>;
  circleRadius?: Double;
  circleColor?: Int32;
  circleOutlineWidth?: Double;
  circleOutlineColor?: Int32;
};

////////////////////

type PartialRect = Readonly<{
  top?: Double;
  right?: Double;
  bottom?: Double;
  left?: Double;
}>;

interface Props extends ViewProps {
  mapType?: WithDefault<
    | 'Basic'
    | 'Navi'
    | 'Satellite'
    | 'Hybrid'
    | 'Terrain'
    | 'NaviHybrid'
    | 'None',
    'Basic'
  >;

  layerGroups: Int32;

  initialCamera?: Readonly<Camera>;
  camera?: Readonly<Camera>;

  initialRegion?: Readonly<Region>;
  region?: Readonly<Region>;

  animationDuration?: Int32;
  animationEasing?: Int32 /*'EaseIn' | 'None' | 'Linear' | 'Fly' | 'EaseOut'*/;

  isIndoorEnabled?: boolean;
  isNightModeEnabled?: boolean;
  isLiteModeEnabled?: boolean;
  lightness?: Double;
  buildingHeight?: Double;
  symbolScale?: Double;
  symbolPerspectiveRatio?: Double;

  mapPadding?: PartialRect;

  minZoom?: Double;
  maxZoom?: Double;

  isShowCompass?: boolean;
  isShowScaleBar?: boolean;
  isShowZoomControls?: boolean;
  isShowIndoorLevelPicker?: boolean;
  isShowLocationButton?: boolean;

  logoAlign?: WithDefault<LogoAlign, 'BottomLeft'>;
  logoMargin?: PartialRect;
  // isLogoInteractionEnabled?: boolean;

  extent?: Readonly<Region>;

  isScrollGesturesEnabled?: boolean;
  isZoomGesturesEnabled?: boolean;
  isTiltGesturesEnabled?: boolean;
  isRotateGesturesEnabled?: boolean;
  isUseTextureViewAndroid?: boolean;
  isStopGesturesEnabled?: boolean;

  locale?: string;

  clusters?: NativeClustersProp;
  fpsLimit?: Int32;
  locationOverlay?: Readonly<NativeLocationOverlayProp>;

  onInitialized?: DirectEventHandler<Readonly<{}>>;
  onOptionChanged?: DirectEventHandler<Readonly<{}>>;
  onCameraChanged?: DirectEventHandler<
    Readonly<{
      latitude: Double;
      longitude: Double;
      zoom: Double;
      tilt: Double;
      bearing: Double;
      reason: Int32 /* CameraChangeReason */;
    }>
  >;
  onTapMap?: DirectEventHandler<
    Readonly<{
      latitude: Double;
      longitude: Double;
      x: Double;
      y: Double;
    }>
  >;
  onTapClusterLeaf?: DirectEventHandler<Readonly<{ markerIdentifier: string }>>;

  onScreenToCoordinate?: DirectEventHandler<
    Readonly<{ isValid: boolean; latitude: Double; longitude: Double }>
  >;
  onCoordinateToScreen?: DirectEventHandler<
    Readonly<{ isValid: boolean; screenX: Double; screenY: Double }>
  >;
}

type ComponentType = HostComponent<Props>;

interface NaverMapNativeCommands {
  screenToCoordinate: (
    ref: React.ElementRef<ComponentType>,
    x: Double,
    y: Double
  ) => Promise<
    Readonly<{
      isValid: boolean;
      latitude: Double;
      longitude: Double;
    }>
  >;
  coordinateToScreen: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double
  ) => Promise<
    Readonly<{
      isValid: boolean;
      screenX: Double;
      screenY: Double;
    }>
  >;
  animateCameraTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double,
    duration?: Int32,
    easing?: Int32 /*'EaseIn' | 'None' | 'Linear' | 'Fly' | 'EaseOut'*/,
    pivotX?: Double,
    pivotY?: Double,
    zoom?: Double
  ) => void;
  animateCameraBy: (
    ref: React.ElementRef<ComponentType>,
    x: Double,
    y: Double,
    duration?: Int32,
    easing?: Int32 /*'Easing' | 'None' | 'Linear' | 'Fly'*/,
    pivotX?: Double,
    pivotY?: Double
  ) => void;
  animateRegionTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double,
    latitudeDelta: Double,
    longitudeDelta: Double,
    duration?: Int32,
    easing?: Int32 /*'Easing' | 'None' | 'Linear' | 'Fly'*/,
    pivotX?: Double,
    pivotY?: Double
  ) => void;
  cancelAnimation: (ref: React.ElementRef<ComponentType>) => void;
  setLocationTrackingMode: (
    ref: React.ElementRef<ComponentType>,
    mode: string
  ) => void;
}

export default codegenNativeComponent<Props>('RNCNaverMapView');
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
  });
