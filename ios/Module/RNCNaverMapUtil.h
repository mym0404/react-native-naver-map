//
//  RNCNaverMapUtil.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import <NMapsMap/NMapsMap.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapSpec.h"

@interface RNCNaverMapUtil : NSObject <NativeRNCNaverMapUtilSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RNCNaverMapUtil : NSObject <RCTBridgeModule>
#endif

@end
