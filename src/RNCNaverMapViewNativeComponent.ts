import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Int32,
  WithDefault,
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

  /*Not Implemented Yet*/
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
  // buildingHeight?: number;
  // minZoomLevel?: number;
  // maxZoomLevel?: number;
  // nightMode?: boolean;
  // scrollGesturesEnabled?: boolean;
  // zoomGesturesEnabled?: boolean;
  // tiltGesturesEnabled?: boolean;
  // rotateGesturesEnabled?: boolean;
  // stopGesturesEnabled?: boolean;
  // liteModeEnabled?: boolean;
  // useTextureView?: boolean;
}

export default codegenNativeComponent<NaverMapViewProps>('RNCNaverMapView');
