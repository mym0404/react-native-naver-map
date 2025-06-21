//
//  RNCNaverMapArrowheadPath.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "ColorUtil.h"
#import "FnUtil.h"
#import "MacroUtil.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTImageLoader.h>
#import <React/RCTUtils.h>
#import <React/RCTView.h>
#import <UIKit/UIKit.h>

#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
@interface RNCNaverMapArrowheadPath : RCTViewComponentView

@property(nonatomic, strong) NMFArrowheadPath* inner;

@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) NSInteger globalZIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy) RCTDirectEventBlock onTapOverlay;

@property(nonatomic, copy) NSArray* coords;
@property(nonatomic, assign) double width;
@property(nonatomic, assign) double outlineWidth;
@property(nonatomic, assign) NSInteger color;
@property(nonatomic, assign) NSInteger outlineColor;
@property(nonatomic, assign) double headSizeRatio;

@end
