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
   * InfoWindow가 열릴 마커의 identifier
   * 지정하면 해당 identifier를 가진 마커 위에 InfoWindow가 열립니다.
   * identifier가 없으면 latitude, longitude 좌표에 직접 표시됩니다.
   */
  identifier?: string;

  /**
   * InfoWindow를 처음부터 열린 상태로 표시할지 여부
   * @default true
   */
  isOpen?: boolean;

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
   * 폰트 굵기
   * 'normal' | 'bold' | '100' | '200' | ... | '900'
   * @default 'normal'
   */
  fontWeight?:
    | 'normal'
    | 'bold'
    | '100'
    | '200'
    | '300'
    | '400'
    | '500'
    | '600'
    | '700'
    | '800'
    | '900';

  /**
   * 배경 색상
   * @default 'white'
   */
  backgroundColor?: ColorValue;

  /**
   * 둥근 모서리 반경 (픽셀)
   * @default 5
   */
  borderRadius?: number;

  /**
   * 테두리 두께 (픽셀)
   * @default 1
   */
  borderWidth?: number;

  /**
   * 테두리 색상
   * @default '#ccc'
   */
  borderColor?: ColorValue;

  /**
   * 수평 내부 여백 (픽셀, 좌우)
   * @default 10
   */
  paddingHorizontal?: number;

  /**
   * 수직 내부 여백 (픽셀, 상하)
   * @default 10
   */
  paddingVertical?: number;
}

/**
 * 네이버 지도에 InfoWindow를 표시하는 컴포넌트입니다.
 *
 * InfoWindow는 마커의 위 또는 지도의 특정 지점에 부가적인 정보를 나타내기 위한 오버레이입니다.
 * 주로 말풍선 형태로 구성되어 텍스트를 표시하는 용도로 사용합니다.
 *
 * **플랫폼별 스타일 지원:**
 * - Android: 모든 스타일 속성 지원 (ViewAdapter를 통한 커스텀 뷰 렌더링)
 * - iOS: 모든 스타일 속성 지원 (NMFOverlayImageDataSource를 통한 커스텀 이미지 렌더링)
 *
 * @example
 * ```tsx
 * // 1. 마커에 연결된 InfoWindow (권장)
 * <NaverMapMarkerOverlay
 *   identifier="marker1"
 *   latitude={37.5666102}
 *   longitude={126.9783881}
 * />
 * <NaverMapInfoWindow
 *   identifier="marker1"
 *   text="마커 정보"
 *   isOpen={true}
 *   // 커스텀 스타일 (Android & iOS 모두 지원)
 *   fontWeight="bold"
 *   borderRadius={10}
 *   borderColor="#4263eb"
 *   paddingHorizontal={12}
 *   paddingVertical={8}
 * />
 *
 * // 2. 특정 좌표에 InfoWindow 직접 표시
 * <NaverMapInfoWindow
 *   latitude={37.5666102}
 *   longitude={126.9783881}
 *   text="서울시청"
 *   textSize={16}
 *   textColor="white"
 *   backgroundColor="#4263eb"
 *   borderRadius={8}
 * />
 * ```
 *
 * @see https://navermaps.github.io/android-map-sdk/guide-ko/5-3.html
 * @see https://navermaps.github.io/ios-map-sdk/guide-ko/5-3.html
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

  identifier,
  isOpen = true,
  align = 'Top',
  anchor = { x: 0.5, y: 1 },
  offsetX = 0,
  offsetY = 0,
  alpha = 1,

  text,
  textSize = 14,
  textColor = 'black',
  fontWeight = 'normal',
  backgroundColor = 'white',
  borderRadius = 5,
  borderWidth = 1,
  borderColor = '#ccc',
  paddingHorizontal = 10,
  paddingVertical = 10,

  children,
}: NaverMapInfoWindowProps) => {
  const fontWeightValue = (() => {
    if (fontWeight === 'normal') return 400;
    if (fontWeight === 'bold') return 700;
    return parseInt(fontWeight, 10);
  })();
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
      identifier={identifier}
      isOpen={isOpen}
      align={getAlignIntValue(align)}
      anchor={anchor}
      offsetX={offsetX}
      offsetY={offsetY}
      alpha={alpha}
      text={text}
      textSize={textSize}
      textColor={processColor(textColor) as number}
      fontWeight={fontWeightValue}
      infoWindowBackgroundColor={processColor(backgroundColor) as number}
      infoWindowBorderRadius={borderRadius}
      infoWindowBorderWidth={borderWidth}
      infoWindowBorderColor={processColor(borderColor) as number}
      infoWindowPaddingHorizontal={paddingHorizontal}
      infoWindowPaddingVertical={paddingVertical}
    >
      {children}
    </NativeNaverMapInfoWindow>
  );
};
