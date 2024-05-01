import { default as NativeNaverMapGround } from '../spec/RNCNaverMapGroundNativeComponent';
import React from 'react';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { Const } from '../internal/util/Const';
import type {
  MarkerImageProp,
  Region,
} from '@mj-studio/react-native-naver-map';
import { convertJsImagePropToNativeProp } from '../internal/Util';

export interface NaverMapGroundOverlayProps extends BaseOverlayProps {
  image: MarkerImageProp;
  region: Region;
}

export const NaverMapGroundOverlay = ({
  zIndex = 0,
  isHidden = false,
  minZoom = Const.MIN_ZOOM,
  maxZoom = Const.MAX_ZOOM,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,
  image,
  region,
  onTap,
}: NaverMapGroundOverlayProps) => {
  return (
    <NativeNaverMapGround
      zIndexValue={zIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      region={region}
      image={convertJsImagePropToNativeProp(image)}
      onTapOverlay={onTap}
    />
  );
};
