import { default as NativeNaverMapMarker } from '../spec/RNCNaverMapMarkerNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import type { PointProp, ColorValue } from 'react-native';
import { Const } from '../util/Const';
import type { MarkerImages } from '../types/MarkerImages';

export type NaverMapMarkerProps = BaseOverlayProps & {
  width?: number;
  height?: number;
  anchor?: PointProp;
  angle?: number;
  isFlatEnabled?: boolean;
  isIconPerspectiveEnabled?: boolean;
  alpha?: number;
  isHideCollidedSymbols?: boolean;
  isHideCollidedMarkers?: boolean;
  isHideCollidedCaptions?: boolean;
  isForceShowIcon?: boolean;
  tintColor?: ColorValue;
  image?: MarkerImages;
};

export const NaverMapMarker = ({
  latitude,
  longitude,
  zIndex = Const.DEFAULT_MARKER_ZINDEX,
  isHidden = false,
  minZoom = 0,
  maxZoom = 1000,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  width = Const.NULL_NUMBER,
  height = Const.NULL_NUMBER,

  alpha = 1,
  anchor = { x: 0, y: 0 },
  angle = 0,
  isFlatEnabled = false,
  isForceShowIcon = false,
  isHideCollidedCaptions = false,
  isHideCollidedMarkers = false,
  isHideCollidedSymbols = false,
  isIconPerspectiveEnabled = false,

  tintColor,
  image,
  onTap,
}: NaverMapMarkerProps) => {
  return (
    <NativeNaverMapMarker
      position={{
        latitude,
        longitude,
      }}
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      width={width}
      height={height}
      alpha={alpha}
      anchor={anchor}
      angle={angle}
      isFlatEnabled={isFlatEnabled}
      isForceShowIcon={isForceShowIcon}
      isHideCollidedCaptions={isHideCollidedCaptions}
      isHideCollidedMarkers={isHideCollidedMarkers}
      isHideCollidedSymbols={isHideCollidedSymbols}
      isIconPerspectiveEnabled={isIconPerspectiveEnabled}
      tintColor={tintColor}
      image={image}
      onTap={onTap}
    />
  );
};
