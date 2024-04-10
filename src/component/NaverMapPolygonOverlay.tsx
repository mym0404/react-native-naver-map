import { default as NativeNaverMapPolygon } from '../spec/RNCNaverMapPolygonNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../util/Const';
import type { Coord } from '@mj-studio/react-native-naver-map';
import invariant from 'invariant';

export type NaverMapPolygonOverlayProps = Omit<
  BaseOverlayProps,
  'latitude' | 'longitude'
> & {
  coords: Coord[];
  holes?: Coord[][];
  color?: ColorValue;
  outlineWidth?: number;
  outlineColor?: ColorValue;
};

export const NaverMapPolygonOverlay = ({
  zIndex = Const.Z_SHAPE,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  coords = [],
  holes = [],
  color = 'black',
  outlineWidth = 0,
  outlineColor = 'black',
  onTap,
}: NaverMapPolygonOverlayProps) => {
  if (coords) {
    invariant(
      coords.length >= 3,
      '[NaverMapPolygonOverlay] coords length should be equal or greater than 3, is %s.',
      coords.length
    );
    if (coords.length < 3) return null;
  }
  if (holes) {
    for (const hole of holes) {
      invariant(
        hole.length >= 3,
        '[NaverMapPolygonOverlay] hole length should be equal or greater than 3, is %s.',
        hole.length
      );
      if (hole.length < 3) return null;
    }
  }
  return (
    <NativeNaverMapPolygon
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      geometries={{
        coords,
        holes,
      }}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      color={processColor(color) as number}
      outlineWidth={outlineWidth}
      outlineColor={processColor(outlineColor) as number}
      onTapOverlay={onTap}
    />
  );
};
