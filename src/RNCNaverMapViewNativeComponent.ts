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

export type NaverMapAuthFailedEvent = Readonly<{
  errorCode: Int32;
  description: string;
}>;

type Coord = Readonly<{
  latitude: Double;
  longitude: Double;
}>;

type Rect = Readonly<{
  top: Double;
  right: Double;
  bottom: Double;
  left: Double;
}>;

type PartialRect = Readonly<{
  top?: Double;
  right?: Double;
  bottom?: Double;
  left?: Double;
}>;

interface NaverMapViewProps extends ViewProps {
  // Additional
  // onAuthFailed?: DirectEventHandler<NaverMapAuthFailedEvent>;

  // Implemented

  onInitialized?: DirectEventHandler<Readonly<{}>>;
  onOptionChanged?: DirectEventHandler<Readonly<{}>>;
  onCameraChanged?: DirectEventHandler<
    Readonly<{
      latitude: string;
      longitude: string;
      zoom: Double;
    }>
  >;

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

  layerGroups?: WithDefault<
    ReadonlyArray<
      'BUILDING' | 'TRAFFIC' | 'TRANSIT' | 'BICYCLE' | 'MOUNTAIN' | 'CADASTRAL'
    >,
    'BUILDING'
  >;

  isIndoorEnabled?: boolean;
  isNightModeEnabled?: boolean;
  isLiteModeEnabled?: boolean;
  lightness?: WithDefault<Double, 0>;
  buildingHeight?: WithDefault<Double, 1>;
  symbolScale?: WithDefault<Double, 1>;
  symbolPerspectiveRatio?: WithDefault<Double, 1>;

  center?: Readonly<{
    latitude: Double;
    longitude: Double;
    zoom?: Double;
    tilt?: Double;
    bearing?: Double;
  }>;

  mapPadding?: PartialRect;

  /*Not Implemented Yet*/
  // tilt?: number;
  // bearing?: number;
  // mapPadding?: Rect;
  // logoMargin?: Rect;
  // logoGravity?: Gravity;
  // onCameraChange?: (event: {
  //   latitude: number;
  //   longitude: number;
  //   zoom: number;
  //   contentsRegion: [Coord, Coord, Coord, Coord, Coord];
  //   coveringRegion: [Coord, Coord, Coord, Coord, Coord];
  // }) => void;
  // onMapClick?: (event: {
  //   x: number;
  //   y: number;
  //   latitude: number;
  //   longitude: number;
  // }) => void;
  // onTouch?: () => void;
  // showsMyLocationButton?: boolean;
  // compass?: boolean;
  // scaleBar?: boolean;
  // zoomControl?: boolean;

  // minZoomLevel?: number;
  // maxZoomLevel?: number;

  // scrollGesturesEnabled?: boolean;
  // zoomGesturesEnabled?: boolean;
  // tiltGesturesEnabled?: boolean;
  // rotateGesturesEnabled?: boolean;
  // stopGesturesEnabled?: boolean;

  // useTextureView?: boolean;
}

type ComponentType = HostComponent<NaverMapViewProps>;

interface NaverMapNativeCommands {
  animateToCoordinate: (
    ref: React.ElementRef<ComponentType>,
    latitude: Double,
    longitude: Double
  ) => void;
  animateToBound: (
    ref: React.ElementRef<ComponentType>,
    encodedJsonString: string
  ) => void;
}

export default codegenNativeComponent<NaverMapViewProps>('RNCNaverMapView');
export const NaverMapCommands: NaverMapNativeCommands =
  codegenNativeCommands<NaverMapNativeCommands>({
    supportedCommands: ['animateToCoordinate', 'animateToBound'],
  });
