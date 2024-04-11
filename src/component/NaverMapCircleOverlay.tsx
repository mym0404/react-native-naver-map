import { default as NativeNaverMapCircle } from '../spec/RNCNaverMapCircleNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../util/Const';

export type NaverMapCircleOverlayProps = BaseOverlayProps & {
  radius?: number;
  color?: ColorValue;
  outlineWidth?: number;
  outlineColor?: ColorValue;
};

export const NaverMapCircleOverlay = ({
  latitude,
  longitude,
  zIndex = Const.Z_SHAPE,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
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
