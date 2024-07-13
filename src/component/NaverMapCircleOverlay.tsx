import { default as NativeNaverMapCircle } from '../spec/RNCNaverMapCircleNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../internal/util/Const';
import type { Coord } from '../types/Coord';
import React from 'react';

export interface NaverMapCircleOverlayProps extends BaseOverlayProps, Coord {
  /** 지도에 원의 반지름을 미터 단위로 표시합니다. */
  radius?: number;
  /**
   * 원의 색상입니다.
   *
   * @default black
   */
  color?: ColorValue;
  /**
   * 외곽선의 굵기입니다. dp(android), pt(ios)
   *
   * @default 0
   */
  outlineWidth?: number;
  /**
   * 외곽선의 색상입니다.
   *
   * @default black
   */
  outlineColor?: ColorValue;
}

export const NaverMapCircleOverlay = ({
  latitude,
  longitude,
  zIndex = 0,
  globalZIndex = Const.NULL_NUMBER,
  isHidden = false,
  minZoom = Const.MIN_ZOOM,
  maxZoom = Const.MAX_ZOOM,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  radius = 0,
  color = 'black',
  outlineWidth = 0,
  outlineColor = 'black',
  onTap,
}: NaverMapCircleOverlayProps) => {
  return (
    <NativeNaverMapCircle
      coord={{
        latitude,
        longitude,
      }}
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      radius={radius}
      color={processColor(color) as number}
      outlineWidth={outlineWidth}
      outlineColor={processColor(outlineColor) as number}
      onTapOverlay={onTap}
    />
  );
};
