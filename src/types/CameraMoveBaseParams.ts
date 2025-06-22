import type { CameraAnimationEasing } from './CameraAnimationEasing';

export interface CameraMoveBaseParams {
  /**
   * 지속시간, milliseconds
   *
   * @default 700
   */
  duration?: number;
  /**
   * 카메라 애니메이션 Easing
   *
   * @default EaseOut
   */
  easing?: CameraAnimationEasing;
  /**
   * 카메라의 중심은 두 좌표의 중심이며 `pivot`으로 조절할 수 있습니다.
   * `pivot`은 기본 0.5(중앙)이며 0 ~ 1 값으로 설정할 수 있습니다.
   *
   * @default {x: 0.5, y: 0.5}
   */
  pivot?: {
    x: number;
    y: number;
  };
}
