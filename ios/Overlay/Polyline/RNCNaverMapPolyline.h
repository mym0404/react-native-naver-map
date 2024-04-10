//
//  RNCNaverMapPolyline.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import <Foundation/Foundation.h>
#import <NMapsMap/NMFPolylineOverlay.h>
#import <React/RCTImageLoader.h>
#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>
#import <React/RCTView.h>
#import "Utils.h"
#import "MacroUtil.h"
#import "FnUtil.h"
#import "RCTConvert+NMFMapView.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
#import "RCTFabricComponentsPlugins.h"
@interface RNCNaverMapPolyline : RCTViewComponentView
#else
@interface RNCNaverMapPolyline : RCTView
#endif

@property(nonatomic, strong) NMFPolylineOverlay* inner;

@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy) RCTDirectEventBlock onTapOverlay;

@property(nonatomic, copy) NSArray* coords;
@property(nonatomic, assign) double width;
@property(nonatomic, assign) NSInteger color;
@property(nonatomic, copy) NSArray* pattern;
@property(nonatomic, assign) NMFOverlayLineCap capType;
@property(nonatomic, assign) NMFOverlayLineJoin joinType;
@end
