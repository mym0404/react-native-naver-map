#import <Foundation/Foundation.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import "RCTBridge.h"
#import "RCTConvert+NMFMapView.h"
#import "RNCNaverMapView.h"
#import "RNCNaverMapViewImpl.h"
#import <react/renderer/components/RNCNaverMapViewSpec/Props.h>
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
RCT_EXPORT_VIEW_PROPERTY(camera, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(region, RNCNaverMapViewRegionStruct)


// event
RCT_EXPORT_VIEW_PROPERTY(onInitialized, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOptionChanged, RCTDirectEventBlock)


// command
#if !TARGET_OS_OSX
#define BASE_VIEW_PER_OS() UIView
#else
#define BASE_VIEW_PER_OS() NSView
#endif
#define QUICK_RCT_EXPORT_COMMAND_METHOD(name)                                                                                                 \
    RCT_EXPORT_METHOD(name:(nonnull NSNumber *)reactTag) {                                                                                    \
        [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, BASE_VIEW_PER_OS() *> *viewRegistry) { \
            RNCNaverMapViewImpl *view = (RNCNaverMapViewImpl *)viewRegistry[reactTag];                                                        \
            if (![view isKindOfClass:[RNCNaverMapViewImpl class]]) {                                                                          \
                RCTLogError(@"Invalid view returned from registry, expecting RNCNaverMapView, got: %@", view);                                \
            } else {                                                                                                                          \
                [view name];                                                                                                                  \
            }                                                                                                                                 \
        }];                                                                                                                                   \
    }
#define QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(name, in_param, out_param)                                                                     \
    RCT_EXPORT_METHOD(name:(nonnull NSNumber *)reactTag in_param) {                                                                           \
NSLog(@"fuck1");[self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, BASE_VIEW_PER_OS() *> *viewRegistry) { \
            RNCNaverMapViewImpl *view = (RNCNaverMapViewImpl *)viewRegistry[reactTag];                                                        \
            if (![view isKindOfClass:[RNCNaverMapViewImpl class]]) {                                                                          \
                RCTLogError(@"Invalid view returned from registry, expecting RNCNaverMapView, got: %@", view);                                \
            } else {                                                                                                                          \
                NSLog(@"fuck"); [view name:out_param];                                                                                        \
            }                                                                                                                                 \
        }];                                                                                                                                   \
    }

QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(animateCameraTo,
                                       latitude:(double)latitude
                                       longitude:(double)longitude
                                       duration:(NSInteger)duration
                                       easing:(NSInteger)easing
                                       pivotX:(double)pivotX
                                       pivotY:(double)pivotY
                                       ,
                                       latitude longitude:longitude duration:duration
                                       easing:easing pivotX:pivotX pivotY:pivotY
                                       )
QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(animateCameraBy,
                                       x:(double)x
                                       y:(double)y
                                       duration:(NSInteger)duration
                                       easing:(NSInteger)easing
                                       pivotX:(double)pivotX
                                       pivotY:(double)pivotY
                                       ,
                                       x y:y duration:duration
                                       easing:easing pivotX:pivotX pivotY:pivotY
                                       )

@end
