//
//  RNCNaverMapPolylineManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPolyline.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapPolylineManager : RCTViewManager
@end

@implementation RNCNaverMapPolylineManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

// MARK: - COMMON PROPS
RCT_EXPORT_VIEW_PROPERTY(zIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(globalZIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(isMinZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isMaxZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onTapOverlay, RCTDirectEventBlock)

// MARK: - Polyline PROPS
RCT_EXPORT_VIEW_PROPERTY(coords, NSArray)
RCT_EXPORT_VIEW_PROPERTY(width, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(color, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(pattern, NSArray)
RCT_EXPORT_VIEW_PROPERTY(capType, NMFOverlayLineCap)
RCT_EXPORT_VIEW_PROPERTY(joinType, NMFOverlayLineJoin)

@end
