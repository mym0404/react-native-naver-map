import type { CameraAnimationEasing } from '../../types/CameraAnimationEasing';

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
  MIN_ZOOM: 0,
  MAX_ZOOM: 21,
  DEFAULT_SCREEN_DISTANCE: 70,
} satisfies (Record<string, any> & {}) & {
  DEFAULT_EASING: CameraAnimationEasing;
};
