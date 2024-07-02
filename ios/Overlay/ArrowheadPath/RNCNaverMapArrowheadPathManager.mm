//
//  RNCNaverMapArrowheadPathManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "RNCNaverMapArrowheadPath.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapArrowheadPathManager : RCTViewManager
@end

@implementation RNCNaverMapArrowheadPathManager

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

// MARK: - ArrowheadPath PROPS
RCT_EXPORT_VIEW_PROPERTY(coords, NSArray*)
RCT_EXPORT_VIEW_PROPERTY(width, double)
RCT_EXPORT_VIEW_PROPERTY(outlineWidth, double)
RCT_EXPORT_VIEW_PROPERTY(color, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(outlineColor, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(headSizeRatio, NSInteger)

@end
