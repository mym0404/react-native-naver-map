import React, { useMemo } from 'react';
import { processColor } from 'react-native';
import { convertJsImagePropToNativeProp } from '../internal/Util';
import { nAssert } from '../internal/util/Assert';
import { Const } from '../internal/util/Const';
import { default as NativeNaverMapMultiPath } from '../spec/RNCNaverMapMultiPathNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import type { MarkerImageProp } from '../types/MarkerImageProp';
import type { MultiPathPart } from '../types/MultiPathPart';

export interface NaverMapMultiPathOverlayProps extends BaseOverlayProps {
  /**
   * 경로 구간들을 지정할 수 있습니다.
   * 각 구간은 좌표와 색상 설정이 포함된 객체로 구성됩니다.
   */
  pathParts: MultiPathPart[];
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
   * progress 속성을 사용하면 경로의 진행도를 0.0 ~ 1.0 범위로 지정할 수 있습니다.
   *
   * @default 0
   */
  progress?: number;
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
  pathParts,
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
  progress = 0,
  width = 1,
  zIndex = 0,
}: NaverMapMultiPathOverlayProps) => {
  // Validate pathParts
  if (pathParts.length === 0) return null;

  // Validate each path part has at least 2 coordinates
  pathParts.forEach((pathPart, index) => {
    nAssert(
      pathPart.coords.length >= 2,
      `[NaverMapMultiPathOverlay] pathParts[${index}].coords length should be equal or greater than 2, is ${pathPart.coords.length}.`
    );
  });

  if (pathParts.some((pathPart) => pathPart.coords.length < 2)) return null;

  // Process pathParts to native format with useMemo
  const processedPathParts = useMemo(() => {
    return pathParts.map((pathPart) => ({
      coords: pathPart.coords,
      color: processColor(pathPart.color || 'black') as number,
      passedColor: processColor(pathPart.passedColor || 'black') as number,
      outlineColor: processColor(pathPart.outlineColor || 'black') as number,
      passedOutlineColor: processColor(
        pathPart.passedOutlineColor || 'black'
      ) as number,
    }));
  }, [pathParts]);

  return (
    <NativeNaverMapMultiPath
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      pathParts={processedPathParts}
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
      progress={progress}
      outlineWidth={outlineWidth}
      onTapOverlay={onTap}
    />
  );
};
