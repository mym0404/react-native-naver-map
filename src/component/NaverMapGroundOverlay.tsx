import { default as NativeNaverMapGround } from '../spec/RNCNaverMapGroundNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { Const } from '../internal/util/Const';
import type {
  MarkerImageProp,
  Region,
} from '@mj-studio/react-native-naver-map';
import { convertJsImagePropToNativeProp } from '../internal/Util';
import React from 'react';

export interface NaverMapGroundOverlayProps extends BaseOverlayProps {
  /**
   * 지상 오버레이의 이미지를 지정할 수 있습니다.
   *
   * 이미지는 필수적인 속성으로, 이미지를 지정하지 않은 지상 오버레이는 지도에 추가되지 않습니다.
   */
  image: MarkerImageProp;
  /**
   * 지상 오버레이의 영역을 지정할 수 있습니다.
   *
   * 영역은 필수적인 속성으로, 영역을 지정하지 않은 지상 오버레이는 지도에 추가되지 않습니다.
   */
  region: Region;
}

export const NaverMapGroundOverlay = ({
  zIndex = 0,
  globalZIndex = Const.NULL_NUMBER,
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
      globalZIndexValue={globalZIndex}
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
