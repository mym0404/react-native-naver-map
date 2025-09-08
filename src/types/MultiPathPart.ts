import type { ColorValue } from 'react-native';
import type { Coord } from './Coord';

/**
 * MultiPath overlay의 각 경로 구간을 정의합니다.
 * 좌표와 색상 설정이 함께 포함된 통합 타입입니다.
 */
export interface MultiPathPart {
  /**
   * 구간의 좌표들
   * 2개 이상의 좌표로 구성되어야 합니다.
   */
  coords: Coord[];
  /**
   * 지나갈 경로의 색상
   * @default 'black'
   */
  color?: ColorValue;
  /**
   * 지나온 경로의 색상
   * @default 'black'
   */
  passedColor?: ColorValue;
  /**
   * 지나갈 경로의 외곽선 색상
   * @default 'black'
   */
  outlineColor?: ColorValue;
  /**
   * 지나온 경로의 외곽선 색상
   * @default 'black'
   */
  passedOutlineColor?: ColorValue;
}
