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

RCT_EXPORT_METHOD(setGlobalZIndex : (NSString*)type zIndex : (double)zIndex) {
  std::string t = [type UTF8String];
  if (t == "InfoWindow") {
    [NMFInfoWindow new].zIndex = zIndex;
  } else if (t == "Location") {
    [NMFLocationOverlay new].globalZIndex = zIndex;
  } else if (t == "Marker") {
    [NMFMarker new].globalZIndex = zIndex;
  } else if (t == "ArrowheadPath") {
    [NMFArrowheadPath new].globalZIndex = zIndex;
  } else if (t == "Path") {
    [NMFPath new].globalZIndex = zIndex;
  } else if (t == "Polygon") {
    [NMFPolygonOverlay new].globalZIndex = zIndex;
  } else if (t == "Polyline") {
    [NMFPolylineOverlay new].globalZIndex = zIndex;
  } else if (t == "Circle") {
    [NMFCircleOverlay new].globalZIndex = zIndex;
  } else if (t == "Ground") {
    [NMFGroundOverlay new].globalZIndex = zIndex;
  }
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
