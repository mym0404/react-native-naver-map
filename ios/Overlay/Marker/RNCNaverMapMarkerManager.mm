//
//  RNCNaverMapMarkerManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapMarker.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMGLatLng.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapMarkerManager : RCTViewManager

@end

@implementation RNCNaverMapMarkerManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

// MARK: - COMMON PROPS
RCT_EXPORT_VIEW_PROPERTY(coord, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(zIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(globalZIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(isMinZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isMaxZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onTapOverlay, RCTDirectEventBlock)

// MARK: - MARKER PROPS
RCT_EXPORT_VIEW_PROPERTY(width, double)
RCT_EXPORT_VIEW_PROPERTY(height, double)
RCT_EXPORT_VIEW_PROPERTY(anchor, CGPoint)
RCT_EXPORT_VIEW_PROPERTY(angle, double)
RCT_EXPORT_VIEW_PROPERTY(isFlatEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isIconPerspectiveEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(alpha, double)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedSymbols, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedMarkers, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedCaptions, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isForceShowIcon, BOOL)
RCT_EXPORT_VIEW_PROPERTY(tintColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(image, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(caption, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(subCaption, NSDictionary)

@end
