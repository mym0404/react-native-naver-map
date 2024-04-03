#import <Foundation/Foundation.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import "RCTBridge.h"
#import "RCTConvert+NMFMapView.h"
#import "RNCNaverMapView.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

@interface RNCNaverMapViewManager : RCTViewManager
@end

@implementation RNCNaverMapViewManager

RCT_EXPORT_MODULE(RNCNaverMapView)

#ifndef RCT_NEW_ARCH_ENABLED

- (UIView *)view
{
    RNCNaverMapViewImpl *ret = [[RNCNaverMapViewImpl alloc] init];

    return ret;
}

#endif

RCT_EXPORT_VIEW_PROPERTY(mapType, NMFMapType)
RCT_EXPORT_VIEW_PROPERTY(isIndoorEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isNightModeEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isLiteModeEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightness, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(buildingHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(symbolScale, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(symbolPerspectiveRatio, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(center, NSDictionary)


// event
RCT_EXPORT_VIEW_PROPERTY(onInitialized, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOptionChanged, RCTDirectEventBlock)


// command

@end
