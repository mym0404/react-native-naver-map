import { default as NativeNaverMapPath } from '../spec/RNCNaverMapPathNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../util/Const';
import type { Coord } from '@mj-studio/react-native-naver-map';
import invariant from 'invariant';

export type NaverMapPathOverlayProps = Omit<
  BaseOverlayProps,
  'latitude' | 'longitude'
> & {
  coords: Coord[];
  width?: number;
  outlineWidth?: number;
  patternInterval?: number;
  progress?: number;
  color?: ColorValue;
  passedColor?: ColorValue;
  outlineColor?: ColorValue;
  passedOutlineColor?: ColorValue;
  isHideCollidedSymbols?: boolean;
  isHideCollidedMarkers?: boolean;
  isHideCollidedCaptions?: boolean;
};

export const NaverMapPathOverlay = ({
  zIndex = Const.Z_SHAPE,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  coords = [],
  width = 1,
  color = 'black',
  isHideCollidedCaptions = false,
  isHideCollidedMarkers = false,
  isHideCollidedSymbols = false,
  outlineColor = 'black',
  outlineWidth = 0,
  passedColor = 'black',
  passedOutlineColor = 'black',
  patternInterval = 0,
  progress = 0,
  onTap,
}: NaverMapPathOverlayProps) => {
  if (coords) {
    invariant(
      coords.length >= 2,
      '[NaverMapPolylineOverlay] coords length should be equal or greater than 2, is %s.',
      coords.length
    );
    if (coords.length < 2) return null;
  }
  invariant(
    progress >= -1 && progress <= 1,
    '[NaverMapPolylineOverlay] progress should be -1 ~ 1'
  );
  return (
    <NativeNaverMapPath
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      coords={coords}
      width={width}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      isHideCollidedCaptions={isHideCollidedCaptions}
      isHideCollidedMarkers={isHideCollidedMarkers}
      isHideCollidedSymbols={isHideCollidedSymbols}
      color={processColor(color) as number}
      passedColor={processColor(passedColor) as number}
      passedOutlineColor={processColor(passedOutlineColor) as number}
      outlineColor={processColor(outlineColor) as number}
      patternInterval={patternInterval}
      outlineWidth={outlineWidth}
      progress={progress}
      onTapOverlay={onTap}
    />
  );
};
