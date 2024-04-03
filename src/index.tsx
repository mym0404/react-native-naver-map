import {
  default as NativeNaverMapView,
  Commands,
} from './RNCNaverMapViewNativeComponent';
import React, {
  forwardRef,
  type ForwardedRef,
  useImperativeHandle,
  useRef,
} from 'react';
import type { MapType } from './types/MapType';
import { type ViewProps, type NativeSyntheticEvent } from 'react-native';
import {
  type CameraAnimationEasing,
  cameraEasingToNumber,
} from './types/CameraAnimationEasing';
import type { Camera } from './types/Camera';
import type { Region } from './types/Region';
import type { Coord } from './types/Coord';
import type { Rect } from './types/Rect';

export * from './RNCNaverMapViewNativeComponent';
export * from './types/Coord';
export * from './types/Rect';
export * from './types/Region';
export * from './types/MapType';
export * from './types/TrackingMode';
export * from './types/LayerGroup';
export * from './types/Gravity';
export * from './types/Align';
export * from './types/Camera';
export * from './types/CameraAnimationEasing';

export type NaverMapViewProps = ViewProps & {
  /**
   * mapType 속성을 지정하면 지도의 유형을 변경할 수 있습니다.
   * 지도의 유형을 변경하면 가장 바닥에 나타나는 배경 지도의 스타일이 변경됩니다.
   */
  mapType?: MapType;
  /**
   * 카메라의 위치를 조절합니다. `region`이 존재한다면 작동하지 않습니다.
   *
   * [Reference](https://navermaps.github.io/ios-map-sdk/guide-ko/3-1.html)
   */
  camera?: Partial<Camera>;
  /**
   * 해당 영역이 완전히 보이는 좌표와 최대 줌 레벨로 카메라가 이동합니다.
   */
  region?: Region;
  /**
   * indoorMapEnabled 속성을 사용하면 실내지도를 활성화할 수 있습니다.
   * 실내지도가 활성화되면 줌 레벨이 일정 수준 이상이고 실내지도가 있는 영역에 지도의 중심이 위치할 경우 자동으로 해당 영역에 대한 실내지도가 나타납니다.
   * 단, 지도 유형이 실내지도를 지원하지 않으면 실내지도를 활성화하더라도 아무런 변화가 일어나지 않습니다.
   * Basic, Terrain 지도 유형만이 실내지도를 지원합니다.
   */
  isIndoorEnabled?: boolean;
  /**
   * nightModeEnabled 속성을 사용하면 야간 모드를 활성화할 수 있습니다.
   * 야간 모드가 활성화되면 지도의 전반적인 스타일이 어두운 톤으로 변경됩니다.
   * 단, 지도 유형이 야간 모드를 지원하지 않을 경우 야간 모드를 활성화하더라도 아무런 변화가 일어나지 않습니다.
   * Navi 지도 유형만이 야간 모드를 지원합니다.
   */
  isNightModeEnabled?: boolean;
  isLiteModeEnabled?: boolean;
  /**
   * lightness 속성을 사용하면 지도의 밝기를 지정할 수 있습니다.
   * 지도의 밝기를 지정하더라도 오버레이의 밝기는 변경되지 않으므로 오버레이를 강조하고자 할 때 사용할 수 있습니다.
   * 값은 -1~1의 비율로 지정할 수 있으며, -1에 가까울수록 어두워지고 1에 가까울수록 밝아집니다.
   * 기본값은 0입니다.
   */
  lightness?: number;
  /**
   * 지도가 기울어지면 건물이 입체적으로 표시됩니다.
   * buildingHeight 속성을 사용하면 입체적으로 표현되는 건물의 높이를 지정할 수 있습니다.
   * 값은 0~1의 비율로 지정할 수 있으며, 0으로 지정하면 지도가 기울어지더라도 건물이 입체적으로 표시되지 않습니다.
   * 기본값은 1입니다.
   */
  buildingHeight?: number;
  /**
   * symbolScale 속성을 사용하면 심벌의 크기를 변경할 수 있습니다.
   * 0~2의 비율로 지정할 수 있으며, 값이 클수록 심벌이 커집니다.
   * 기본값은 1입니다.
   */
  symbolScale?: number;
  /**
   * 지도를 기울이면 가까이 있는 심벌은 크게, 멀리 있는 심벌은 작게 그려집니다.
   * symbolPerspectiveRatio 속성을 사용하면 심벌의 원근 효과를 조절할 수 있습니다.
   * 0~1의 비율로 지정할 수 있으며, 값이 작을수록 원근감이 줄어들어 0이 되면 원근 효과가 완전히 사라집니다.
   * 기본값은 1입니다.
   */
  symbolPerspectiveRatio?: number;
  mapPadding?: Partial<Rect>;
  isShowCompass?: boolean;
  isShowScaleBar?: boolean;
  isShowZoomControls?: boolean;
  isShowIndoorLevelPicker?: boolean;
  isShowLocationButton?: boolean;

  /**
   * 지도 객체가 초기화가 완료된 뒤에 호출됩니다.
   */
  onInitialized?: () => void;
  /**
   * 지도 유형, 디스플레이 옵션 등 지도와 관련된 옵션이 변경되면 이벤트가 발생합니다.
   * 지도의 옵션이 변경되면 콜백 메서드가 호출됩니다.
   *
   * 이 이벤트는 지도의 옵션에 따라 UI나 다른 속성을 변경하고자 할 때 유용합니다.
   * 예를 들어 지도가 야간 모드로 변경되면 마커의 색상도 어두운 색으로 변경해야 자연스러운데,
   * 이런 경우에 옵션 변경 이벤트를 사용할 수 있습니다.
   */
  onOptionChanged?: () => void;
  onCameraChanged?: (
    params: NativeSyntheticEvent<{
      latitude: number;
      longitude: number;
      zoom: number;
    }>
  ) => void;
};

type CameraMoveBaseParams = {
  duration?: number;
  easing?: CameraAnimationEasing;
  pivot?: {
    x: number;
    y: number;
  };
};
export type NaverMapViewRef = {
  animateCameraTo: (
    params: {
      latitude: number;
      longitude: number;
    } & CameraMoveBaseParams
  ) => void;
  animateCameraBy: (
    params: {
      x: number;
      y: number;
    } & CameraMoveBaseParams
  ) => void;
  animateCameraToCenterWithDelta: (
    params: {
      latitude: number;
      longitude: number;
      latitudeDelta: number;
      longitudeDelta: number;
    } & CameraMoveBaseParams
  ) => void;
  animateCameraWithTwoCoords: (
    params: {
      coord1: Coord;
      coord2: Coord;
    } & CameraMoveBaseParams
  ) => void;
};

function clamp(v: number, min: number, max: number): number {
  return Math.min(max, Math.max(min, v));
}
// const INVALID_NUMBER = -123123123;
const DEFAULT_ANIM_DURATION = 700;
const NaverMapView = forwardRef(
  (
    {
      camera,
      region,
      mapType = 'Basic',

      isIndoorEnabled = false,
      isNightModeEnabled = false,
      isLiteModeEnabled = false,
      lightness = 0,
      buildingHeight = 1,
      symbolScale = 1,
      symbolPerspectiveRatio = 1,

      onCameraChanged,
      onInitialized,
      onOptionChanged,
      mapPadding,
      isShowCompass = true,
      isShowIndoorLevelPicker = true,
      isShowLocationButton = true,
      isShowScaleBar = true,
      isShowZoomControls = true,

      ...rest
    }: NaverMapViewProps,
    ref: ForwardedRef<NaverMapViewRef>
  ) => {
    const innerRef = useRef<any>(null);
    useImperativeHandle(
      ref,
      () => ({
        animateCameraTo: ({ duration, easing, latitude, longitude, pivot }) => {
          if (innerRef.current) {
            Commands.animateCameraTo(
              innerRef.current,
              latitude,
              longitude,
              duration ?? DEFAULT_ANIM_DURATION,
              cameraEasingToNumber(easing),
              pivot?.x ?? 0.5,
              pivot?.y ?? 0.5
            );
          }
        },
        animateCameraBy: ({ duration, easing, x, y, pivot }) => {
          if (innerRef.current) {
            Commands.animateCameraBy(
              innerRef.current,
              x,
              y,
              duration ?? DEFAULT_ANIM_DURATION,
              cameraEasingToNumber(easing),
              pivot?.x ?? 0.5,
              pivot?.y ?? 0.5
            );
          }
        },
        animateCameraToCenterWithDelta: ({
          easing,
          longitude,
          latitude,
          duration,
          latitudeDelta,
          longitudeDelta,
          pivot,
        }) => {
          if (innerRef.current) {
            Commands.animateRegionTo(
              innerRef.current,
              latitude,
              longitude,
              latitudeDelta,
              longitudeDelta,
              duration ?? DEFAULT_ANIM_DURATION,
              cameraEasingToNumber(easing),
              pivot?.x ?? 0.5,
              pivot?.y ?? 0.5
            );
          }
        },
        animateCameraWithTwoCoords: ({
          duration,
          easing,
          coord1,
          coord2,
          pivot,
        }) => {
          if (innerRef.current) {
            const centerLatitude = (coord1.latitude + coord2.latitude) / 2;
            const centerLongitude = (coord1.longitude + coord2.longitude) / 2;
            const latitudeDiff = Math.abs(coord1.latitude - coord2.latitude);
            const longitudeDiff = Math.abs(coord1.longitude - coord2.longitude);

            Commands.animateRegionTo(
              innerRef.current,
              centerLatitude,
              centerLongitude,
              latitudeDiff * 2,
              longitudeDiff * 2,
              duration ?? DEFAULT_ANIM_DURATION,
              cameraEasingToNumber(easing),
              pivot?.x ?? 0.5,
              pivot?.y ?? 0.5
            );
          }
        },
      }),
      []
    );
    return (
      <NativeNaverMapView
        ref={innerRef}
        mapType={mapType}
        camera={
          camera && !region
            ? {
                latitude: camera.latitude,
                longitude: camera.longitude,
                zoom: camera.zoom,
                tilt: camera.tilt,
                bearing: camera.bearing,
              }
            : undefined
        }
        region={region}
        isIndoorEnabled={isIndoorEnabled}
        isNightModeEnabled={isNightModeEnabled}
        isLiteModeEnabled={isLiteModeEnabled}
        lightness={clamp(lightness, -1, 1)}
        buildingHeight={clamp(buildingHeight, 0, 1)}
        symbolScale={clamp(symbolScale, 0, 2)}
        symbolPerspectiveRatio={clamp(symbolPerspectiveRatio, 0, 1)}
        onInitialized={onInitialized}
        onCameraChanged={onCameraChanged}
        onOptionChanged={onOptionChanged}
        mapPadding={mapPadding}
        isShowCompass={isShowCompass}
        isShowIndoorLevelPicker={isShowIndoorLevelPicker}
        isShowLocationButton={isShowLocationButton}
        isShowScaleBar={isShowScaleBar}
        isShowZoomControls={isShowZoomControls}
        {...rest}
      />
    );
  }
);

export default NaverMapView;
