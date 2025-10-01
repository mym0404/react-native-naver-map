import React, { type PropsWithChildren } from 'react';
import { type ColorValue, processColor } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';
import { getAlignIntValue } from '../internal/Util';
import { Const } from '../internal/util/Const';
import NativeNaverMapInfoWindow from '../spec/RNCNaverMapInfoWindowNativeComponent';
import type { Align } from '../types/Align';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import type { Coord } from '../types/Coord';

export interface NaverMapInfoWindowProps
  extends BaseOverlayProps,
    Coord,
    PropsWithChildren<{}> {
  /**
   * InfoWindow가 열릴 마커의 태그 (선택적)
   * 지정하면 해당 마커 위에 InfoWindow가 열립니다.
   * 지정하지 않으면 latitude, longitude 좌표에 InfoWindow가 열립니다.
   */
  markerTag?: string;

  /**
   * InfoWindow가 마커에 대해 열릴 때의 정렬 방향
   * @default 'Top'
   */
  align?: Align;

  /**
   * 앵커 포인트를 지정합니다.
   * 왼쪽 위가 (0, 0), 오른쪽 아래가 (1, 1)인 비율로 표현합니다.
   * @default {x: 0.5, y: 1}
   */
  anchor?: { x: Double; y: Double };

  /**
   * X축 오프셋 (픽셀)
   * @default 0
   */
  offsetX?: number;

  /**
   * Y축 오프셋 (픽셀)
   * @default 0
   */
  offsetY?: number;

  /**
   * InfoWindow의 불투명도 (0~1)
   * @default 1
   */
  alpha?: Double;

  /**
   * InfoWindow에 표시할 텍스트
   */
  text?: string;

  /**
   * 텍스트 크기
   * @default 14
   */
  textSize?: Double;

  /**
   * 텍스트 색상
   * @default 'black'
   */
  textColor?: ColorValue;

  /**
   * 배경 색상
   * @default 'white'
   */
  backgroundColor?: ColorValue;
}

/**
 * 네이버 지도에 InfoWindow를 표시하는 컴포넌트입니다.
 *
 * InfoWindow는 마커의 위 또는 지도의 특정 지점에 부가적인 정보를 나타내기 위한 오버레이입니다.
 * 주로 말풍선 형태로 구성되어 텍스트를 표시하는 용도로 사용합니다.
 *
 * @example
 * ```tsx
 * // 특정 좌표에 InfoWindow 표시
 * <NaverMapInfoWindow
 *   latitude={37.5666102}
 *   longitude={126.9783881}
 *   text="서울시청"
 *   textSize={14}
 *   textColor="black"
 *   backgroundColor="white"
 * />
 *
 * // 마커에 연결된 InfoWindow
 * <NaverMapInfoWindow
 *   latitude={37.5666102}
 *   longitude={126.9783881}
 *   markerTag="marker1"
 *   align="Top"
 *   text="마커 정보"
 * />
 * ```
 *
 * @see https://navermaps.github.io/android-map-sdk/guide-ko/5-3.html
 */
export const NaverMapInfoWindow = ({
  latitude,
  longitude,
  zIndex = 0,
  globalZIndex = Const.NULL_NUMBER,
  isHidden = false,
  minZoom = Const.MIN_ZOOM,
  maxZoom = Const.MAX_ZOOM,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  markerTag,
  align = 'Top',
  anchor = { x: 0.5, y: 1 },
  offsetX = 0,
  offsetY = 0,
  alpha = 1,

  text,
  textSize = 14,
  textColor = 'black',
  backgroundColor = 'white',

  children,
}: NaverMapInfoWindowProps) => {
  return (
    <NativeNaverMapInfoWindow
      coord={{ latitude, longitude }}
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      markerTag={markerTag}
      align={getAlignIntValue(align)}
      anchor={anchor}
      offsetX={offsetX}
      offsetY={offsetY}
      alpha={alpha}
      text={text}
      textSize={textSize}
      textColor={processColor(textColor) as number}
      infoWindowBackgroundColor={processColor(backgroundColor) as number}
    >
      {children}
    </NativeNaverMapInfoWindow>
  );
};
