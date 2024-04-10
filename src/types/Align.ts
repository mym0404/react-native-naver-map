export type Align =
  | 'Center'
  | 'Left'
  | 'Right'
  | 'Top'
  | 'Bottom'
  | 'TopLeft'
  | 'TopRight'
  | 'BottomRight'
  | 'BottomLeft';
export function getAlignIntValue(value?: Align) {
  switch (value) {
    case 'Center':
      return 0;
    case 'Left':
      return 1;
    case 'Right':
      return 2;
    case 'Top':
      return 3;
    case 'TopLeft':
      return 5;
    case 'TopRight':
      return 6;
    case 'BottomRight':
      return 7;
    case 'BottomLeft':
      return 8;
    default:
    case 'Bottom':
      return 4;
  }
}
