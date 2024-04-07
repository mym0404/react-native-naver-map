import { default as NativeNaverMapPolyline } from '../spec/RNCNaverMapPolylineNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../util/Const';
import type {
  Coord,
  CapType,
  JoinType,
} from '@mj-studio/react-native-naver-map';
import invariant from 'invariant';

export type NaverMapPolylineOverlayProps = Omit<
  BaseOverlayProps,
  'latitude' | 'longitude'
> & {
  coords: Coord[];
  width?: number;
  color?: ColorValue;
  pattern?: number[];
  capType?: CapType;
  joinType?: JoinType;
};

export const NaverMapPolylineOverlay = ({
  zIndex = Const.Z_SHAPE,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  coords = [],
  width = 1,
  capType = 'Round',
  joinType = 'Round',
  color = 'black',
  onTap,
}: NaverMapPolylineOverlayProps) => {
  if (coords) {
    invariant(
      coords.length >= 2,
      'coords length should be equal or greater than 2, is %s.',
      coords.length
    );
    if (coords.length < 2) return null;
  }
  return (
    <NativeNaverMapPolyline
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      coords={coords}
      width={width}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      color={processColor(color) as number}
      capType={capType}
      joinType={joinType}
      onTapOverlay={onTap}
    />
  );
};
