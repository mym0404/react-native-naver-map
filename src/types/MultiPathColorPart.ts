import type { ColorValue } from 'react-native';

/**
 * MultiPath overlay의 각 경로 구간별 색상 설정을 정의합니다.
 */
export interface MultiPathColorPart {
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