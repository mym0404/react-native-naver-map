import type { CameraAnimationEasing } from '@mj-studio/react-native-naver-map';

export const Const = {
  /**
   * ios: codegen generate struct number fields with default value zero.
   *      in some cases, we should check it is invalid value instead of checking is zero.
   */
  NULL_NUMBER: -123123123,
  DEFAULT_ANIM_DURATION: 700,
  DEFAULT_EASING: 'EaseOut',
  DEFAULT_MARKER_ZINDEX: 200000,
} satisfies (Record<string, any> & {}) & {
  DEFAULT_EASING: CameraAnimationEasing;
};
