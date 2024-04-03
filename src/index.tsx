import { default as NativeNaverMapView } from './RNCNaverMapViewNativeComponent';
import React, {
  forwardRef,
  type ForwardedRef,
  useImperativeHandle,
} from 'react';
import type { MapType } from './types/MapType';
import type { ViewProps, NativeSyntheticEvent } from 'react-native';

export * from './RNCNaverMapViewNativeComponent';
export * from './types/Coord';
export * from './types/Rect';
export * from './types/Region';
export * from './types/MapType';
export * from './types/TrackingMode';
export * from './types/LayerGroup';
export * from './types/Gravity';
export * from './types/Align';

export type NaverMapViewProps = ViewProps & {
  /**
   * mapType 속성을 지정하면 지도의 유형을 변경할 수 있습니다.
   * 지도의 유형을 변경하면 가장 바닥에 나타나는 배경 지도의 스타일이 변경됩니다.
   */
  mapType?: MapType;
  center?: {
    latitude: number;
    longitude: number;
    zoom?: number;
    tilt?: number;
    bearing?: number;
  };
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

export type NaverMapViewRef = {};

function clamp(v: number, min: number, max: number): number {
  return Math.min(max, Math.max(min, v));
}
const INVALID_NUMBER = -123123123;

const NaverMapView = forwardRef(
  (
    {
      center,
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

      ...rest
    }: NaverMapViewProps,
    ref: ForwardedRef<NaverMapViewRef>
  ) => {
    useImperativeHandle(ref, () => ({}), []);
    return (
      <NativeNaverMapView
        mapType={mapType}
        center={
          center
            ? {
                latitude: center.latitude,
                longitude: center.longitude,
                zoom: center.zoom ?? INVALID_NUMBER,
                tilt: center.tilt ?? INVALID_NUMBER,
                bearing: center.bearing ?? INVALID_NUMBER,
              }
            : undefined
        }
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
        {...rest}
      />
    );
  }
);
export default NaverMapView;
