import type { CameraAnimationEasing } from '@mj-studio/react-native-naver-map';

export const Const = {
  /**
   * ios: codegen generate struct number fields with default value zero.
   *      in some cases, we should check it is invalid value instead of checking is zero.
   */
  NULL_NUMBER: -123123123,
  DEFAULT_ANIM_DURATION: 700,
  DEFAULT_EASING: 'EaseOut',
  Z_INFO: 400000,
  Z_LOCATION: 300000,
  Z_MARKER: 200000,
  Z_ARROW: 100000,
  Z_SYMBOL: 0,
  Z_PATH: -100000,
  Z_SHAPE: -200000,
  Z_GROUND: -300000,
  Z_BACKGROUND: -400000,
} satisfies (Record<string, any> & {}) & {
  DEFAULT_EASING: CameraAnimationEasing;
};
