//
//  RNCNaverMapUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import "RNCNaverMapUtil.h"
#import <Foundation/Foundation.h>

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
