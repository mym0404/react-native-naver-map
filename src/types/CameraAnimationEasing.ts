/**
 * 카메라 애니메이션의 Easing입니다.
 *
 * - EaseIn: 부드럽게 가속하며 이동합니다. 가까운 거리를 이동할 때 적합합니다.
 * - EaseOut: 부드럽게 감속하며 이동합니다. 가까운 거리를 이동할 때 적합합니다.
 * - None: 애니메이션 없이 이동합니다.
 * - Linear: 일정한 속도로 이동합니다.
 * - Fly: 부드럽게 축소됐다가 확대되며 이동합니다. 먼 거리를 이동할 때 적합합니다.
 */
export type CameraAnimationEasing =
  | 'EaseIn'
  | 'EaseOut'
  | 'None'
  | 'Linear'
  | 'Fly';
