#import "RCTBridge.h"
#import "RCTConvert+NMFMapView.h"
#import "RNCNaverMapView.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapViewManager : RCTViewManager
@end

@implementation RNCNaverMapViewManager

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

RCT_EXPORT_MODULE()

#ifndef RCT_NEW_ARCH_ENABLED

- (UIView*)view {
  RNCNaverMapViewImpl* ret = [[RNCNaverMapViewImpl alloc] init];

  return ret;
}

#endif

RCT_EXPORT_VIEW_PROPERTY(mapType, NMFMapType)
RCT_EXPORT_VIEW_PROPERTY(layerGroups, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(camera, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(initialCamera, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(region, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(initialRegion, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(isIndoorEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isNightModeEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isLiteModeEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(lightness, double)
RCT_EXPORT_VIEW_PROPERTY(buildingHeight, double)
RCT_EXPORT_VIEW_PROPERTY(symbolScale, double)
RCT_EXPORT_VIEW_PROPERTY(symbolPerspectiveRatio, double)
RCT_EXPORT_VIEW_PROPERTY(mapPadding, RNCNaverMapRect)
RCT_EXPORT_VIEW_PROPERTY(isShowCompass, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isShowIndoorLevelPicker, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isShowLocationButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isShowScaleBar, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isShowZoomControls, BOOL)
RCT_EXPORT_VIEW_PROPERTY(logoMargin, RNCNaverMapRect)
RCT_EXPORT_VIEW_PROPERTY(logoAlign, NMFLogoAlign)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(extent, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(isScrollGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isZoomGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isTiltGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isRotateGesturesEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isStopGesturesEnabled, BOOL)

// event
RCT_EXPORT_VIEW_PROPERTY(onInitialized, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOptionChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCameraChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapMap, RCTDirectEventBlock)

// command
#if !TARGET_OS_OSX
#define BASE_VIEW_PER_OS() UIView
#else
#define BASE_VIEW_PER_OS() NSView
#endif
#define QUICK_RCT_EXPORT_COMMAND_METHOD(name)                                                      \
  RCT_EXPORT_METHOD(name : (nonnull NSNumber*)reactTag) {                                          \
    [self.bridge.uiManager                                                                         \
        addUIBlock:^(__unused RCTUIManager * uiManager,                                            \
                     NSDictionary<NSNumber*, BASE_VIEW_PER_OS()*> * viewRegistry) {                \
          RNCNaverMapViewImpl* view = (RNCNaverMapViewImpl*)viewRegistry[reactTag];                \
          if (![view isKindOfClass:[RNCNaverMapViewImpl class]]) {                                 \
            RCTLogError(                                                                           \
                @"Invalid view returned from registry, expecting RNCNaverMapView, got: %@", view); \
          } else {                                                                                 \
            [view name];                                                                           \
          }                                                                                        \
        }];                                                                                        \
  }
#define QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(name, in_param, out_param)                          \
  RCT_EXPORT_METHOD(name : (nonnull NSNumber*)reactTag in_param) {                                 \
    [self.bridge.uiManager                                                                         \
        addUIBlock:^(__unused RCTUIManager * uiManager,                                            \
                     NSDictionary<NSNumber*, BASE_VIEW_PER_OS()*> * viewRegistry) {                \
          RNCNaverMapViewImpl* view = (RNCNaverMapViewImpl*)viewRegistry[reactTag];                \
          if (![view isKindOfClass:[RNCNaverMapViewImpl class]]) {                                 \
            RCTLogError(                                                                           \
                @"Invalid view returned from registry, expecting RNCNaverMapView, got: %@", view); \
          } else {                                                                                 \
            [view name:out_param];                                                                 \
          }                                                                                        \
        }];                                                                                        \
  }

QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(animateCameraTo, latitude
                                       : (double)latitude longitude
                                       : (double)longitude duration
                                       : (NSInteger)duration easing
                                       : (NSInteger)easing pivotX
                                       : (double)pivotX pivotY
                                       : (double)pivotY, latitude longitude
                                       : longitude duration
                                       : duration easing
                                       : easing pivotX
                                       : pivotX pivotY
                                       : pivotY)
QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(animateCameraBy, x
                                       : (double)x y
                                       : (double)y duration
                                       : (NSInteger)duration easing
                                       : (NSInteger)easing pivotX
                                       : (double)pivotX pivotY
                                       : (double)pivotY, x y
                                       : y duration
                                       : duration easing
                                       : easing pivotX
                                       : pivotX pivotY
                                       : pivotY)
QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(animateRegionTo, latitude
                                       : (double)latitude longitude
                                       : (double)longitude latitudeDelta
                                       : (double)latitudeDelta longitudeDelta
                                       : (double)longitudeDelta duration
                                       : (NSInteger)duration easing
                                       : (NSInteger)easing pivotX
                                       : (double)pivotX pivotY
                                       : (double)pivotY, latitude longitude
                                       : longitude latitudeDelta
                                       : latitudeDelta longitudeDelta
                                       : longitudeDelta duration
                                       : duration easing
                                       : easing pivotX
                                       : pivotX pivotY
                                       : pivotY)

@end
