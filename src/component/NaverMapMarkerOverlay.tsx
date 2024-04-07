import { default as NativeNaverMapMarker } from '../spec/RNCNaverMapMarkerNativeComponent';
import React, { type PropsWithChildren, Children } from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import {
  type PointProp,
  type ColorValue,
  type ImageSourcePropType,
  Image,
} from 'react-native';
import { Const } from '../util/Const';
import invariant from 'invariant';
import { type MarkerImages, allMarkerImages } from '../types/MarkerImages';

export type NaverMapMarkerOverlayProps = BaseOverlayProps & {
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
  image?: ImageSourcePropType & (MarkerImages & {});
} & PropsWithChildren<{}>;

export const NaverMapMarkerOverlay = ({
  latitude,
  longitude,
  zIndex = Const.Z_MARKER,
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
  children,
}: NaverMapMarkerOverlayProps) => {
  invariant(
    Children.count(children) <= 1,
    '[NaverMapMarkerOverlay] children count should be equal or less than 1, is %s',
    Children.count(children)
  );
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
      image={getImageUri(image)}
      onTapOverlay={onTap}
      children={children}
    />
  );
};

function getImageUri(src?: ImageSourcePropType | string): string | undefined {
  let imageUri;
  if (typeof src === 'string' && allMarkerImages.includes(src as any)) {
    imageUri = src;
  } else if (typeof src !== 'string' && src) {
    let image = Image.resolveAssetSource(src) || { uri: null };
    imageUri = image.uri;
  }
  return imageUri;
}
