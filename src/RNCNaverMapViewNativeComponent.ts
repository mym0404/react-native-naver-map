import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Int32,
  WithDefault,
  Float,
} from 'react-native/Libraries/Types/CodegenTypes';

export type NaverMapAuthFailedEvent = Readonly<{
  errorCode: Int32;
  description: string;
}>;

interface NaverMapViewProps extends ViewProps {
  // Additional
  // onAuthFailed?: DirectEventHandler<NaverMapAuthFailedEvent>;

  // Implemented

  onInitialized?: DirectEventHandler<Readonly<{}>>;

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
  lightness?: WithDefault<Float, 0>;
  buildingHeight?: WithDefault<Float, 1>;
  symbolScale?: WithDefault<Float, 1>;
  symbolPerspectiveRatio?: WithDefault<Float, 1>;

  /*Not Implemented Yet*/
  // center?: Readonly<{
  //   latitude: Double;
  //   longitude: Double;
  //   zoom?: Double;
  //   tilt?: Double;
  //   bearing?: Double;
  // }>;
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

export default codegenNativeComponent<NaverMapViewProps>('RNCNaverMapView');
