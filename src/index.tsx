import {
  default as NativeNaverMapView,
  Commands,
} from './spec/RNCNaverMapViewNativeComponent';
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
import type { LogoAlign } from './types/LogoAlign';
import {
  type CameraChangeReason,
  cameraChangeReasonFromNumber,
} from './types/CameraChangeReason';
import { useStableCallback } from './util/useStableCallback';

export * from './spec/RNCNaverMapViewNativeComponent';
export * from './types/Coord';
export * from './types/Rect';
export * from './types/Region';
export * from './types/MapType';
export * from './types/TrackingMode';
export * from './types/LayerGroup';
export * from './types/Gravity';
export * from './types/Align';
export * from './types/LogoAlign';
export * from './types/Camera';
export * from './types/CameraAnimationEasing';
export * from './types/CameraChangeReason';

export type NaverMapViewProps = ViewProps & {
  /**
   * mapType 속성을 지정하면 지도의 유형을 변경할 수 있습니다.
   * 지도의 유형을 변경하면 가장 바닥에 나타나는 배경 지도의 스타일이 변경됩니다.
   */
  mapType?: MapType;
  /**
   * 카메라의 위치를 조절합니다. `region`이 존재해도 `camera`가 설정되면 동작하지 않습니다.
   *
   * [Reference](https://navermaps.github.io/ios-map-sdk/guide-ko/3-1.html)
   */
  camera?: Partial<Camera>;
  /**
   * 맵이 생성된 후 첫 카메라 설정입니다.
   *
   * `camera`를 사용하지 않을 때만 사용해야합니다.
   *
   * 컴포넌트가 mount되고 변경해도 동작하지 않습니다.
   *
   */
  initialCamera?: Partial<Camera>;
  /**
   * 해당 영역이 완전히 보이는 좌표와 최대 줌 레벨로 카메라가 이동합니다.
   *
   * `camera`가 존재한다면 동작하지 않습니다.
   *
   * `latitude`, `longtidue`는 지도의 south-west(위도, 경도가 낮은 부분)를 의미합니다.
   *
   * `latitudeDelta`, `longitudeDelta`는 각 위도 경도로 얼마만큼의 범위를 가질 것인지를 의미합니다.
   *  항상 양수입니다.
   *
   * 예를 들어, `latitudeDelta`가 0.1이라면 위도가 지도의 보이는 곳의 끝과 끝에서 0.1이 차이난다는 것을 의미합니다.
   * 하지만 `longitudeDelta`가 특정 값보다 커서 최대 줌 레벨이 더 작아진다면 0.1보다 더 차이나게 될 수도 있고 반대도 같습니다.
   */
  region?: Region;
  /**
   * 맵이 생성된 후 첫 위치 설정입니다.
   *
   * `region`를 사용하지 않을 때만 사용해야합니다.
   *
   * 컴포넌트가 mount되고 변경해도 동작하지 않습니다.
   */
  initialRegion?: Region;
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
   *
   */
  mapPadding?: Partial<Rect>;
  /**
   * 나침반: 카메라의 회전 및 틸트 상태를 표현합니다.
   * 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다.
   * 헤딩과 틸트가 0이 되면 자동으로 사라집니다.
   */
  isShowCompass?: boolean;
  /**
   * 축척 바: 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
   */
  isShowScaleBar?: boolean;
  /**
   * 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소합니다.
   */
  isShowZoomControls?: boolean;
  /**
   * 실내지도 층 피커: 노출 중인 실내지도 구역의 층 정보를 표현합니다
   * 층을 선택하면 해당 층의 실내지도가 노출됩니다.
   * 실내지도가 보이는 상황에만 나타납니다.
   */
  isShowIndoorLevelPicker?: boolean;
  /**
   * 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경됩니다.
   */
  isShowLocationButton?: boolean;
  /**
   * 카메라의 최소 줌 레벨입니다.
   */
  minZoom?: number;
  /**
   * 카메라의 최대 줌 레벨입니다.
   */
  maxZoom?: number;
  /**
   * extent 속성을 지정하면 카메라의 대상 지점을 영역 내로 제한할 수 있습니다.
   * 카메라가 제한 영역을 벗어나도록 API를 호출하더라도 대상 지점이 영역 내로 조정됩니다.
   *
   * 카메라 영역을 제한할 때 최소 줌 레벨도 함께 제한하는 것이 좋습니다.
   * 그렇지 않으면 지도가 축소되었을 때 제한 영역이 너무 작게 나타날 수 있습니다.
   */
  extent?: Region;
  /**
   * 한반도로 `extent`를 제한합니다. `extent`가 존재한다면 동작하지 않습니다.
   */
  isExtentBoundedInKorea?: boolean;

  logoAlign?: LogoAlign;
  logoMargin?: Partial<Rect>;

  /**
   * 탭 활성화 여부를 지정할 수 있습니다.
   * 로고 탭을 비활성화한 앱은 반드시 앱 내에 네이버 지도 SDK의
   * 법적 공지(-showLegalNotice) 및 오픈소스 라이선스(-showOpenSourceLicense)뷰를 보여주는 메뉴를 만들어야 합니다.
   */
  // isLogoInteractionEnabled?: boolean;

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
  /**
   * 어떤 이유에 의해서건 카메라가 움직이면 카메라 변경 이벤트가 발생합니다.
   *
   * reason은 이벤트를 발생시킨 카메라 이동의 원인입니다.
   * reason을 이용해 카메라 이동의 원인을 지정할 수 있으며, 이벤트 리스너 내에서 이 값을 이용해 어떤 원인에 의해 발생한 이벤트인지 판단할 수 있습니다.
   *
   * {@link CameraChangeReason}
   */
  onCameraChanged?: (
    params: Camera & {
      reason: CameraChangeReason;
    }
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
  animateRegionTo: (params: Region & CameraMoveBaseParams) => void;
  /**
   * 두 좌표가 모두 보이는 최대 줌 레벨로 이동합니다.
   *
   * 카메라의 중심은 두 좌표의 중심이며 `pivot`으로 조절할 수 있습니다.
   * `pivot`은 기본 0.5(중앙)이며 0 ~ 1 값으로 설정할 수 있습니다.
   */
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

/**
 * ios: codegen generate struct number fields with default value zero.
 *      in some cases, we should check it is invalid value instead of checking is zero.
 */
const NULL_NUMBER = -123123123;
const DEFAULT_ANIM_DURATION = 700;
const DEFAULT_EASING: CameraAnimationEasing = 'EaseOut';
const NaverMapView = forwardRef(
  (
    {
      camera,
      initialCamera,
      region,
      initialRegion,
      mapType = 'Basic',

      isIndoorEnabled = false,
      isNightModeEnabled = false,
      isLiteModeEnabled = false,
      lightness = 0,
      buildingHeight = 1,
      symbolScale = 1,
      symbolPerspectiveRatio = 1,

      mapPadding,
      isShowCompass = true,
      isShowIndoorLevelPicker = true,
      isShowLocationButton = true,
      isShowScaleBar = true,
      isShowZoomControls = true,
      minZoom,
      maxZoom,
      extent,
      isExtentBoundedInKorea,
      logoAlign,
      logoMargin,

      onCameraChanged: onCameraChangedProp,
      onInitialized,
      onOptionChanged,

      ...rest
    }: NaverMapViewProps,
    ref: ForwardedRef<NaverMapViewRef>
  ) => {
    const innerRef = useRef<any>(null);

    const onCameraChanged = useStableCallback(
      ({
        nativeEvent: { bearing, latitude, longitude, reason, tilt, zoom },
      }: NativeSyntheticEvent<Camera & { reason: number }>) => {
        onCameraChangedProp?.({
          zoom,
          tilt,
          reason: cameraChangeReasonFromNumber(reason),
          latitude,
          longitude,
          bearing,
        });
      }
    );

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
              cameraEasingToNumber(easing ?? DEFAULT_EASING),
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
              cameraEasingToNumber(easing ?? DEFAULT_EASING),
              pivot?.x ?? 0.5,
              pivot?.y ?? 0.5
            );
          }
        },
        animateRegionTo: ({
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
              cameraEasingToNumber(easing ?? DEFAULT_EASING),
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
            const latitude = Math.min(coord1.latitude, coord2.latitude);
            const longitude = Math.min(coord1.longitude, coord2.longitude);
            const latitudeDelta = Math.abs(coord1.latitude - coord2.latitude);
            const longitudeDelta = Math.abs(
              coord1.longitude - coord2.longitude
            );

            Commands.animateRegionTo(
              innerRef.current,
              latitude,
              longitude,
              latitudeDelta,
              longitudeDelta,
              duration ?? DEFAULT_ANIM_DURATION,
              cameraEasingToNumber(easing ?? DEFAULT_EASING),
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
        camera={camera}
        initialCamera={
          !camera && initialCamera
            ? initialCamera
            : {
                latitude: NULL_NUMBER,
                longitude: NULL_NUMBER,
                zoom: NULL_NUMBER,
                tilt: NULL_NUMBER,
                bearing: NULL_NUMBER,
              }
        }
        region={!camera && !initialCamera ? region : undefined}
        initialRegion={
          !region && !camera && !initialCamera && initialRegion
            ? initialRegion
            : {
                latitude: NULL_NUMBER,
                longitude: NULL_NUMBER,
                latitudeDelta: NULL_NUMBER,
                longitudeDelta: NULL_NUMBER,
              }
        }
        isIndoorEnabled={isIndoorEnabled}
        isNightModeEnabled={isNightModeEnabled}
        isLiteModeEnabled={isLiteModeEnabled}
        lightness={clamp(lightness, -1, 1)}
        buildingHeight={clamp(buildingHeight, 0, 1)}
        symbolScale={clamp(symbolScale, 0, 2)}
        symbolPerspectiveRatio={clamp(symbolPerspectiveRatio, 0, 1)}
        onInitialized={onInitialized}
        onCameraChanged={onCameraChangedProp ? onCameraChanged : undefined}
        onOptionChanged={onOptionChanged}
        mapPadding={mapPadding}
        isShowCompass={isShowCompass}
        isShowIndoorLevelPicker={isShowIndoorLevelPicker}
        isShowLocationButton={isShowLocationButton}
        isShowScaleBar={isShowScaleBar}
        isShowZoomControls={isShowZoomControls}
        minZoom={minZoom}
        maxZoom={maxZoom}
        extent={
          extent
            ? extent
            : isExtentBoundedInKorea
              ? {
                  latitude: 31.43,
                  longitude: 122.37,
                  latitudeDelta: 44.35 - 31.43,
                  longitudeDelta: 132 - 122.37,
                }
              : undefined
        }
        logoAlign={logoAlign}
        logoMargin={logoMargin}
        {...rest}
      />
    );
  }
);

export default NaverMapView;
