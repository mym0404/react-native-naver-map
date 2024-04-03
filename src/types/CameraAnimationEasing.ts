export type CameraAnimationEasing = 'Easing' | 'None' | 'Linear' | 'Fly';
export function cameraEasingToNumber(
  value: CameraAnimationEasing = 'Easing'
): number {
  switch (value) {
    case 'None':
      return 1;
    case 'Linear':
      return 2;
    case 'Fly':
      return 3;
    default:
    case 'Easing':
      return 0;
  }
}
