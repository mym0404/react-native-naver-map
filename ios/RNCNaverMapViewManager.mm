#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "Utils.h"
#import "RNCNaverMapView.h"
#import "RNCNaverMapViewImpl.h"

@interface RNCNaverMapViewManager : RCTViewManager
@end

@implementation RNCNaverMapViewManager

RCT_EXPORT_MODULE(RNCNaverMapView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNCNaverMapViewImpl alloc] init];
}
#endif

RCT_EXPORT_VIEW_PROPERTY(mapType, NMFMapType)
RCT_EXPORT_VIEW_PROPERTY(isIndoorEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isNightModeEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightness, NSNumber)

@end
