import { default as NativeNaverMapMarker } from '../spec/RNCNaverMapMarkerNativeComponent';
import React, { type PropsWithChildren, Children } from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import {
  type PointProp,
  type ColorValue,
  type ImageSourcePropType,
  Image,
  processColor,
} from 'react-native';
import { Const } from '../util/Const';
import invariant from 'invariant';
import { type MarkerImages } from '../types/MarkerImages';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';
import { type Align } from '../types/Align';
import type { Coord } from '../types/Coord';
import { getAlignIntValue, allMarkerImages } from '../internal/Util';

export interface CaptionType {
  key: string;
  text: string;
  requestedWidth?: Double;
  align?: Align;
  offset?: Double;
  color?: ColorValue;
  haloColor?: ColorValue;
  textSize?: Double;
  minZoom?: Double;
  maxZoom?: Double;
}
export interface SubCaptionType {
  key: string;
  text: string;
  color?: ColorValue;
  haloColor?: ColorValue;
  textSize?: Double;
  requestedWidth?: Double;
  minZoom?: Double;
  maxZoom?: Double;
}
const defaultCaptionProps = {
  key: 'DEFAULT',
  text: '',
  textSize: 12,
  minZoom: 0,
  maxZoom: 9999,
  color: 'black',
  haloColor: 'transparent',
  requestedWidth: 0,
} satisfies Partial<CaptionType>;
const defaultSubCaptionProps = {
  key: 'DEFAULT',
  text: '',
  textSize: 10,
  minZoom: 0,
  maxZoom: 9999,
  color: 'black',
  haloColor: 'transparent',
  requestedWidth: 0,
} satisfies Partial<SubCaptionType>;

export interface NaverMapMarkerOverlayProps
  extends BaseOverlayProps,
    Coord,
    PropsWithChildren<{}> {
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
  image?: ImageSourcePropType | (MarkerImages & {});
  caption?: CaptionType;
  subCaption?: SubCaptionType;
}

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
  caption,
  subCaption,
  children,
}: NaverMapMarkerOverlayProps) => {
  invariant(
    Children.count(children) <= 1,
    '[NaverMapMarkerOverlay] children count should be equal or less than 1, is %s',
    Children.count(children)
  );

  invariant(
    Children.count(children) > 0 ? !image : true,
    '[NaverMapMarkerOverlay] passing `image` prop and `children` both for the marker image detected. only one of two should be passed.'
  );
  invariant(
    image ? getImageUri(image) : true,
    "[NaverMapMarkerOverlay] `image` uri is not found. If it is network image, then it should `{'uri': '...'}`. If it is local image, then it should be a ImageSourcePropType like `require('./myImage.png')`"
  );
  return (
    <NativeNaverMapMarker
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
      tintColor={processColor(tintColor) as number}
      image={getImageUri(image) ?? 'default'}
      onTapOverlay={onTap}
      caption={{
        ...defaultCaptionProps,
        ...caption,
        align: getAlignIntValue(caption?.align),
        color: processColor(
          caption?.color ?? defaultCaptionProps.color
        ) as number,
        haloColor: processColor(
          caption?.haloColor ?? defaultCaptionProps.haloColor
        ) as number,
      }}
      subCaption={{
        ...defaultSubCaptionProps,
        ...subCaption,
        color: processColor(
          subCaption?.color ?? defaultSubCaptionProps.color
        ) as number,
        haloColor: processColor(
          subCaption?.haloColor ?? defaultSubCaptionProps.haloColor
        ) as number,
      }}
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
