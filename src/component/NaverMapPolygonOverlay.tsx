import { default as NativeNaverMapPolygon } from '../spec/RNCNaverMapPolygonNativeComponent';
import type { BaseOverlayProps } from '../types/BaseOverlayProps';
import { type ColorValue, processColor } from 'react-native';
import { Const } from '../internal/util/Const';
import type { Coord } from '@mj-studio/react-native-naver-map';
import { nAssert } from '../internal/util/Assert';
import React from 'react';

export interface NaverMapPolygonOverlayProps extends BaseOverlayProps {
  /**
   * 폴리곤 오버레이는 좌표열 혹은 좌표열 정보가 입력된 객체를 사용하여 생성할 수 있습니다.
   * 이때, 좌표열의 첫 좌표와 끝 좌표가 정확히 같아야 합니다.
   *
   * coords는 필수적인 속성으로, 시계 방향으로 감겨 있어야 하며, 그렇지 않을 경우 비정상적으로 그려지거나 이벤트를 받지 못할 수 있습니다.
   * 폴리곤을 지정하지 않은 폴리곤 오버레이는 지도에 추가되지 않습니다.
   * 또한 폴리곤의 coords의 크기가 3 미만이거나 nil인 원소가 있을 경우에도 지도에 추가되지 않습니다.
   */
  coords: Coord[];
  /**
   * polygon의 holes 속성이 있을 경우 폴리곤 오버레이에 홀을 만들 수 있습니다.
   * 폴리곤에는 여러 개의 내부 홀을 지정할 수 있으며, 홀에 해당하는 부분은 색상이 칠해지지 않고 이벤트도 받지 못합니다.
   * 각 홀의 좌표열은 시계 반대 방향으로 감겨 있어야 하며, 그렇지 않을 경우 비정상적으로 그려지거나 이벤트를 받지 못할 수 있습니다.
   * 또한 각 홀의 좌표열의 크기가 3 미만이거나 nil인 원소가 있을 경우 지도에 추가되지 않습니다.
   */
  holes?: Coord[][];
  /**
   * color속성을 사용해 선의 색상을 지정할 수 있습니다.
   *
   * @default black
   */
  color?: ColorValue;
  /**
   * 테두리의 두께를 지정할 수 있습니다. 0으로 지정하면 테두리가 그려지지 않습니다.
   *
   * @default 0
   */
  outlineWidth?: number;
  /**
   * 외곽선 색상입니다.
   *
   * @default black
   */
  outlineColor?: ColorValue;
}

export const NaverMapPolygonOverlay = ({
  zIndex = 0,
  globalZIndex = Const.NULL_NUMBER,
  isHidden = false,
  minZoom = Const.MIN_ZOOM,
  maxZoom = Const.MAX_ZOOM,
  isMinZoomInclusive = true,
  isMaxZoomInclusive = true,

  coords = [],
  holes = [],
  color = 'black',
  outlineWidth = 0,
  outlineColor = 'black',
  onTap,
}: NaverMapPolygonOverlayProps) => {
  if (coords) {
    nAssert(
      coords.length >= 3,
      `[NaverMapPolygonOverlay] coords length should be equal or greater than 3, is ${coords.length}.`
    );
  }
  if (holes) {
    for (const hole of holes) {
      nAssert(
        hole.length >= 3,
        `[NaverMapPolygonOverlay] hole length should be equal or greater than 3, is ${hole.length}.`
      );
    }
  }
  return (
    <NativeNaverMapPolygon
      zIndexValue={zIndex}
      globalZIndexValue={globalZIndex}
      isHidden={isHidden}
      minZoom={minZoom}
      maxZoom={maxZoom}
      geometries={{
        coords,
        holes,
      }}
      isMinZoomInclusive={isMinZoomInclusive}
      isMaxZoomInclusive={isMaxZoomInclusive}
      color={processColor(color) as number}
      outlineWidth={outlineWidth}
      outlineColor={processColor(outlineColor) as number}
      onTapOverlay={onTap}
    />
  );
};
