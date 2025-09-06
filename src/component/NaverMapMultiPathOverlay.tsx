import React from 'react';
import { processColor } from 'react-native';
import { convertJsImagePropToNativeProp } from '../internal/Util';
import { nAssert } from '../internal/util/Assert';
import { Const } from '../internal/util/Const';
import { default as NativeNaverMapMultiPath } from '../spec/RNCNaverMapMultiPathNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import type { Coord } from '../types/Coord';
import type { MarkerImageProp } from '../types/MarkerImageProp';
import type { MultiPathColorPart } from '../types/MultiPathColorPart';

export interface NaverMapMultiPathOverlayProps extends BaseOverlayProps {
  /**
   * 좌표 구간들을 지정할 수 있습니다.
   * 각 구간은 2개 이상의 좌표로 구성되어야 하며, coordParts와 colorParts의 길이가 일치해야 합니다.
   */
  coordParts: Coord[][];
  /**
   * 각 좌표 구간별 색상 설정입니다.
   * coordParts와 동일한 길이여야 합니다.
   */
  colorParts: MultiPathColorPart[];
  /**
   * 두께를 지정할 수 있습니다.
   *
   * dp, pt단위입니다.
   *
   * @default 1
   */
  width?: number;
  /**
   * 테두리의 두께를 지정할 수 있습니다. 0으로 지정하면 테두리가 그려지지 않습니다.
   *
   * @default 0
   */
  outlineWidth?: number;
  /**
   * 패턴을 의미하는 이미지를 삽입할 수 있습니다.
   * 패턴 이미지의 크기가 경로선의 두께보다 클 경우 경로선의 두께에 맞게 축소됩니다. undefined일 경우 패턴을 표시하지 않습니다.
   *
   * @default undefined
   */
  patternImage?: MarkerImageProp;
  /**
   * patternInterval 속성을 사용하면 패턴 이미지 간 간격을 지정할 수 있습니다. 0일 경우 패턴이 그려지지 않습니다.
   *
   * @default 0
   */
  patternInterval?: number;
  /**
   * isHideCollidedSymbols 속성을 true로 지정하면 경로선과 겹치는 지도 심벌이 숨겨집니다.
   *
   * @default false
   */
  isHideCollidedSymbols?: boolean;
  /**
   * isHideCollidedMarkers 속성을 true로 지정하면 경로선과 겹치는 마커가 숨겨집니다.
   * 마커의 Z 인덱스가 경로선의 Z 인덱스보다 크더라도 경로선이 우선합니다.
   *
   * @default false
   */
  isHideCollidedMarkers?: boolean;
  /**
   * isHideCollidedCaptions 속성을 true로 지정하면 경로선과 겹치는 마커 캡션이 숨겨집니다.
   * 겹치는 마커의 captionAligns에 둘 이상의 방향을 지정했다면 겹치지 않는 첫 번째 방향에 캡션이 나타나며, 어느 방향으로 위치시켜도 겹칠 경우에만 캡션이 숨겨집니다.
   * 단, hideCollidedMarkers가 true로 지정된 경우 hideCollidedCaptions는 무시됩니다.
   * 마커의 Z 인덱스가 경로선의 Z 인덱스보다 크더라도 경로선이 우선합니다.
   *
   * @default false
   */
  isHideCollidedCaptions?: boolean;
}

export const NaverMapMultiPathOverlay = ({
  colorParts,
  coordParts,
  globalZIndex = Const.NULL_NUMBER,
  isHidden,
  isHideCollidedCaptions,
  isHideCollidedMarkers,
  isHideCollidedSymbols,
  isMaxZoomInclusive,
  isMinZoomInclusive,
  maxZoom = Const.MAX_ZOOM,
  minZoom = Const.MIN_ZOOM,
  onTap,
  outlineWidth = 0,
  patternImage,
  patternInterval = 0,
  width = 1,
  zIndex = 0,
}: NaverMapMultiPathOverlayProps) => {
  // Validate coordParts and colorParts
  nAssert(
    coordParts.length === colorParts.length,
    `[NaverMapMultiPathOverlay] coordParts length (${coordParts.length}) should equal colorParts length (${colorParts.length}).`
  );

  if (coordParts.length === 0 || colorParts.length === 0) return null;

  // Validate each coordinate part has at least 2 coordinates
  coordParts.forEach((coords, index) => {
    nAssert(
      coords.length >= 2,
      `[NaverMapMultiPathOverlay] coordParts[${index}] length should be equal or greater than 2, is ${coords.length}.`
    );
  });

  if (coordParts.some((coords) => coords.length < 2)) return null;

  // Process color parts to native format
  const processedColorParts = colorParts.map((colorPart) => ({
    color: processColor(colorPart.color || 'black') as number,
    passedColor: processColor(colorPart.passedColor || 'black') as number,
    outlineColor: processColor(colorPart.outlineColor || 'black') as number,
    passedOutlineColor: processColor(
      colorPart.passedOutlineColor || 'black'
    ) as number,
  }));

  return (
    <NativeNaverMapMultiPath
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      coordParts={coordParts}
      colorParts={processedColorParts}
      width={width}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      isHideCollidedCaptions={isHideCollidedCaptions}
      isHideCollidedMarkers={isHideCollidedMarkers}
      isHideCollidedSymbols={isHideCollidedSymbols}
      patternImage={
        patternImage ? convertJsImagePropToNativeProp(patternImage) : undefined
      }
      patternInterval={patternInterval}
      outlineWidth={outlineWidth}
      onTapOverlay={onTap}
    />
  );
};
