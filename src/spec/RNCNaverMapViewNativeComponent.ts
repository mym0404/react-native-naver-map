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

type Camera = {
  latitude?: Double;
  longitude?: Double;
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
  isStopGesturesEnabled?: boolean;

  // useTextureView?: boolean;

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
      latitude: number;
      longitude: number;
    }>
  >;
  coordinateToScreen: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double
  ) => Promise<
    Readonly<{
      isValid: boolean;
      screenX: number;
      screenY: number;
    }>
  >;
  animateCameraTo: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double,
    duration?: Int32,
    easing?: Int32 /*'EaseIn' | 'None' | 'Linear' | 'Fly' | 'EaseOut'*/,
    pivotX?: Double,
    pivotY?: Double
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
    ],
  });
