//
//  RNCNaverMapPathManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import <Foundation/Foundation.h>
#import <NMapsMap/NMFMarker.h>
#import <NMapsGeometry/NMGLatLng.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import "RCTConvert+NMFMapView.h"
#import "RNCNaverMapPath.h"

@interface RNCNaverMapPathManager : RCTViewManager
@end

@implementation RNCNaverMapPathManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (UIView*)view {
  return [RNCNaverMapPath new];
}

// MARK: - COMMON PROPS
RCT_EXPORT_VIEW_PROPERTY(zIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(isMinZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isMaxZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onTapOverlay, RCTDirectEventBlock)

// MARK: - Path PROPS
RCT_EXPORT_VIEW_PROPERTY(coords, NSArray*)
RCT_EXPORT_VIEW_PROPERTY(width, double)
RCT_EXPORT_VIEW_PROPERTY(outlineWidth, double)
RCT_EXPORT_VIEW_PROPERTY(patternInterval, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(progress, double)
RCT_EXPORT_VIEW_PROPERTY(color, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(passedColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(outlineColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(passedOutlineColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedSymbols, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedMarkers, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedCaptions, BOOL)

@end
