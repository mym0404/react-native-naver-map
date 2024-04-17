import type {
  CameraAnimationEasing,
  CameraChangeReason,
  Align,
  Camera,
  MarkerImageProp,
} from '@mj-studio/react-native-naver-map';
import { Const } from './util/Const';
import { Image } from 'react-native';

export function cameraEasingToNumber(
  value: CameraAnimationEasing = 'EaseIn'
): number {
  switch (value) {
    case 'None':
      return 1;
    case 'Linear':
      return 2;
    case 'Fly':
      return 3;
    case 'EaseOut':
      return 4;
    default:
    case 'EaseIn':
      return 0;
  }
}

export function cameraChangeReasonFromNumber(
  value: number
): CameraChangeReason {
  switch (value) {
    case 0:
      return 'Developer';
    case 1:
      return 'Gesture';
    case 2:
      return 'Control';
    case 3:
      return 'Location';
    default:
      return 'Developer';
  }
}

export function getAlignIntValue(value?: Align) {
  switch (value) {
    case 'Center':
      return 0;
    case 'Left':
      return 1;
    case 'Right':
      return 2;
    case 'Top':
      return 3;
    case 'TopLeft':
      return 5;
    case 'TopRight':
      return 6;
    case 'BottomRight':
      return 7;
    case 'BottomLeft':
      return 8;
    default:
    case 'Bottom':
      return 4;
  }
}

export function createCameraInstance({
  bearing,
  latitude,
  longitude,
  tilt,
  zoom,
}: Camera): Camera {
  return {
    latitude,
    longitude,
    zoom: zoom ?? Const.DEFAULT_ZOOM,
    tilt: tilt ?? Const.DEFAULT_TILT,
    bearing: bearing ?? Const.DEFAULT_BEARING,
  };
}

export const convertJsImagePropToNativeProp = (image: MarkerImageProp) => {
  if (typeof image === 'number') {
    const rnAssetUri = Image.resolveAssetSource(image)?.uri;
    if (rnAssetUri) {
      return { rnAssetUri };
    } else {
      return;
    }
  }
  const { assetName, httpUri, reuseIdentifier, symbol } = image as Exclude<
    MarkerImageProp,
    number
  >;
  if (assetName) {
    return { assetName, reuseIdentifier };
  }
  if (httpUri) {
    return { httpUri, reuseIdentifier };
  }
  if (symbol) {
    return { symbol, reuseIdentifier };
  }
  return;
};
