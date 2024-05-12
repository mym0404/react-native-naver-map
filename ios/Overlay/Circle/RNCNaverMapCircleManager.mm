//
//  RNCNaverMapCircleManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapCircle.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapCircleManager : RCTViewManager
@end

@implementation RNCNaverMapCircleManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

// MARK: - COMMON PROPS
RCT_EXPORT_VIEW_PROPERTY(coord, NMGLatLng)
RCT_EXPORT_VIEW_PROPERTY(zIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(globalZIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(isMinZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isMaxZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onTapOverlay, RCTDirectEventBlock)

// MARK: - Circle PROPS
RCT_EXPORT_VIEW_PROPERTY(radius, double)
RCT_EXPORT_VIEW_PROPERTY(color, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(outlineColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(outlineWidth, double)

@end
