import { default as NativeNaverMapPath } from '../spec/RNCNaverMapPathNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../internal/util/Const';
import type { Coord, MarkerImageProp } from '@mj-studio/react-native-naver-map';
import { nAssert } from '../internal/util/Assert';
import { convertJsImagePropToNativeProp } from '../internal/Util';
import React from 'react';

export interface NaverMapPathOverlayProps extends BaseOverlayProps {
  /**
   *  좌표열을 지정할 수 있습니다.
   *  좌표열은 필수적인 속성으로, 좌표열을 지정하지 않은 경로선 오버레이는 지도에 추가되지 않습니다.
   *  또한 좌표열의 크기가 2 미만이거나 null인 원소가 있을 경우에도 지도에 추가되지 않습니다.
   */
  coords: Coord[];
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
   * 진척률을 지정할 수 있습니다. 경로는 진척률을 기준으로 지나온 경로와 지나갈 경로로 구분됩니다. 지나온 구간과 지나갈 구간에 대한 색상을 달리 지정할 수 있으므로 진척률에 따라 좌표열을 변경할 필요가 없습니다. 값의 범위는 -1~1이며 각각 다음과 같은 의미를 갖습니다.
   *
   * 양수로 지정하면 첫 좌표부터 진척률만큼 떨어진 지점까지의 선형은 지나온 경로로, 나머지는 지나갈 경로로 간주됩니다.
   * 음수로 지정하면 마지막 좌표부터 -진척률만큼 떨어진 지점까지의 선형은 지나온 경로로, 나머지는 지나갈 경로로 간주됩니다.
   * 0으로 지정하면 모든 선형이 지나갈 경로로 간주됩니다.
   *
   * @default 0
   */
  progress?: number;
  /**
   * color와 passedColor 속성을 사용해 각각 지나갈, 지나온 경로선의 색상을 지정할 수 있습니다.
   *
   * @default black
   */
  color?: ColorValue;
  /**
   * color와 passedColor 속성을 사용해 각각 지나갈, 지나온 경로선의 색상을 지정할 수 있습니다.
   *
   * @default black
   */
  passedColor?: ColorValue;
  /**
   * 외곽선 색상입니다.
   *
   * @default black
   */
  outlineColor?: ColorValue;
  /**
   * 지나온 경로의 외곽선 색상입니다.
   *
   * @default black
   */
  passedOutlineColor?: ColorValue;
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

export const NaverMapPathOverlay = ({
  zIndex = 0,
  globalZIndex = Const.NULL_NUMBER,
  isHidden = false,
  minZoom = Const.MIN_ZOOM,
  maxZoom = Const.MAX_ZOOM,
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
  patternImage,
  patternInterval = 0,
  progress = 0,
  onTap,
}: NaverMapPathOverlayProps) => {
  if (coords) {
    nAssert(
      coords.length >= 2,
      `[NaverMapPolylineOverlay] coords length should be equal or greater than 2, is ${coords.length}.`
    );
    if (coords.length < 2) return null;
  }
  nAssert(
    progress >= -1 && progress <= 1,
    '[NaverMapPolylineOverlay] progress should be -1 ~ 1'
  );
  return (
    <NativeNaverMapPath
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
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
      patternImage={
        patternImage ? convertJsImagePropToNativeProp(patternImage) : undefined
      }
      patternInterval={patternInterval}
      outlineWidth={outlineWidth}
      progress={progress}
      onTapOverlay={onTap}
    />
  );
};
