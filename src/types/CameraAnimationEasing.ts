export type CameraAnimationEasing =
  | 'EaseIn'
  | 'EaseOut'
  | 'None'
  | 'Linear'
  | 'Fly';
export function cameraEasingToNumber(
  value: CameraAnimationEasing = 'EaseIn'
): number {
  switch (value) {
    case 'None':
      return 1;
    case 'Linear':
      return 2;
    case 'Fly':
      return 3;
    case 'EaseOut':
      return 4;
    default:
    case 'EaseIn':
      return 0;
  }
}
