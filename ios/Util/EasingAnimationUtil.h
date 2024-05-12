//
//  EasingAnimationUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/12/24.
//

#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>

static inline NMFCameraUpdateAnimation getEasingAnimation(int easing) {
  if (easing == 1) {
    return NMFCameraUpdateAnimationNone;
  }

  if (easing == 2) {
    return NMFCameraUpdateAnimationLinear;
  }

  if (easing == 3) {
    return NMFCameraUpdateAnimationFly;
  }

  if (easing == 4) {
    return NMFCameraUpdateAnimationEaseOut;
  }

  return NMFCameraUpdateAnimationEaseIn;
}
