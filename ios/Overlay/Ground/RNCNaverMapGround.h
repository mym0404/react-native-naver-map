//
//  RNCNaverMapGround.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "FnUtil.h"
#import "MacroUtil.h"
#import "RCTConvert+NMFMapView.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTImageLoader.h>
#import <React/RCTUtils.h>
#import <React/RCTView.h>
#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
@interface RNCNaverMapGround : RCTViewComponentView
#else
#import <React/RCTBridge.h>
@interface RNCNaverMapGround : RCTView
#endif

@property(nonatomic, weak, nullable) RCTBridge* bridge;
@property(nonatomic, strong, nullable) NMFGroundOverlay* inner;

@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy, nullable) RCTDirectEventBlock onTapOverlay;

@property(nonatomic, copy, nonnull) RNCNaverMapRegion* region;
@property(nonatomic, copy, nonnull) NSDictionary* image;

@end
