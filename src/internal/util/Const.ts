import type { CameraAnimationEasing } from '@mj-studio/react-native-naver-map';

export const Const = {
  /**
   * ios: codegen generate struct number fields with default value zero.
   *      in some cases, we should check it is invalid value instead of checking is zero.
   */
  NULL_NUMBER: -123123123,
  DEFAULT_ANIM_DURATION: 700,
  DEFAULT_EASING: 'EaseOut',
  DEFAULT_ZOOM: 10,
  DEFAULT_TILT: 0,
  DEFAULT_BEARING: 0,
  Z_INFO: 400000,
  Z_LOCATION: 300000,
  Z_MARKER: 200000,
  Z_ARROW: 100000,
  Z_SYMBOL: 0,
  Z_PATH: -100000,
  Z_SHAPE: -200000,
  Z_GROUND: -300000,
  Z_BACKGROUND: -400000,
  MIN_ZOOM: 0,
  MAX_ZOOM: 21,
  DEFAULT_SCREEN_DISTANCE: 70,
} satisfies (Record<string, any> & {}) & {
  DEFAULT_EASING: CameraAnimationEasing;
};
