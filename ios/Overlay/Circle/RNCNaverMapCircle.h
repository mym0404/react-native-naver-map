//
//  RNCNaverMapCircle.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "FnUtil.h"
#import "MacroUtil.h"
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
@interface RNCNaverMapCircle : RCTViewComponentView
#else
@interface RNCNaverMapCircle : RCTView
#endif

@property(nonatomic, strong) NMFCircleOverlay* inner;

@property(nonatomic, copy) NMGLatLng* coord;
@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy) RCTDirectEventBlock onTapOverlay;

@property(nonatomic, assign) double radius;
@property(nonatomic, assign) NSInteger color;
@property(nonatomic, assign) NSInteger outlineColor;
@property(nonatomic, assign) double outlineWidth;
@end
