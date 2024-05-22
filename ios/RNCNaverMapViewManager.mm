#import "RCTBridge.h"
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

RCT_EXPORT_VIEW_PROPERTY(mapType, NMFMapType)
RCT_EXPORT_VIEW_PROPERTY(layerGroups, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(camera, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(initialCamera, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(region, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(initialRegion, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(animationDuration, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(animationEasing, NSInteger)
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
RCT_EXPORT_VIEW_PROPERTY(locale, NSString)
RCT_EXPORT_VIEW_PROPERTY(clusters, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(fpsLimit, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(locationOverlay, NSDictionary)

// event
RCT_EXPORT_VIEW_PROPERTY(onInitialized, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOptionChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCameraChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapMap, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScreenToCoordinate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCoordinateToScreen, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapClusterLeaf, RCTDirectEventBlock)

@end
