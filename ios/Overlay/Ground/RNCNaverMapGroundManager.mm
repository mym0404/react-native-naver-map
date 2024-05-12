//
//  RNCNaverMapArrowheadPathManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "RNCNaverMapGround.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>

@interface RNCNaverMapGroundManager : RCTViewManager
@end

@implementation RNCNaverMapGroundManager

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
RCT_EXPORT_VIEW_PROPERTY(region, RNCNaverMapRegion)
RCT_EXPORT_VIEW_PROPERTY(image, NSDictionary)

@end
