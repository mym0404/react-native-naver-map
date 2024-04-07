//
//  RNCNaverMapMarker.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import <Foundation/Foundation.h>
#import <NMapsMap/NMFMarker.h>
#import <NMapsMap/NMFOverlay.h>
#import <NMapsMap/NMFCircleOverlay.h>
#import <React/RCTImageLoader.h>
#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>
#import <React/RCTView.h>
#import "Utils.h"
#import "MacroUtil.h"
#import "FnUtil.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
#import "RCTFabricComponentsPlugins.h"
@interface RNCNaverMapMarker : RCTViewComponentView
#else
@interface RNCNaverMapMarker : RCTView
#endif

@property(nonatomic, strong) NMFMarker* inner;

@property(nonatomic, copy) NMGLatLng* position;
@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy) RCTDirectEventBlock onTap;

@property(nonatomic, assign) double width;
@property(nonatomic, assign) double height;
@property(nonatomic, assign) CGPoint anchor;
@property(nonatomic, assign) double angle;
@property(nonatomic, assign) BOOL isFlatEnabled;
@property(nonatomic, assign) BOOL isIconPerspectiveEnabled;
@property(nonatomic, assign) double alpha;
@property(nonatomic, assign) BOOL isHideCollidedSymbols;
@property(nonatomic, assign) BOOL isHideCollidedMarkers;
@property(nonatomic, assign) BOOL isHideCollidedCaptions;
@property(nonatomic, assign) BOOL isForceShowIcon;
@property(nonatomic, strong) UIColor* tintColor;

@property (nonatomic, copy) NSString *image;

//- (void)setCaptionText:(NSString *)text;
//- (void)setCaptionTextSize:(CGFloat)size;
//- (void)setCaptionColor:(UIColor *)color;
//- (void)setCaptionHaloColor:(UIColor *)color;
//- (void)setCaptionAligns:(NSArray<NMFAlignType *> *)aligns;
//- (void)setCaptionOffset:(CGFloat)offset;
//- (void)setCaptionRequestedWidth:(CGFloat)captionWidth;
//- (void)setCaptionMinZoom:(double)minZoom;
//- (void)setCaptionMaxZoom:(double)maxZoom;
//- (void)setSubCaptionText:(NSString *)subText;
//- (void)setSubCaptionTextSize:(CGFloat)subTextSize;
//- (void)setSubCaptionColor:(UIColor *)subColor;
//- (void)setSubCaptionHaloColor:(UIColor *)subHaloColor;
//- (void)setSubCaptionRequestedWidth:(CGFloat)subCaptionWidth;
//- (void)setSubCaptionMinZoom:(double)subMinZoom;
//- (void)setSubCaptionMaxZoom:(double)subMaxZoom;

@end
