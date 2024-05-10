//
//  RNCNaverMapMarker.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "FnUtil.h"
#import "MacroUtil.h"
#import "RCTConvert+NMFMapView.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTImageLoader.h>
#import <React/RCTImageLoaderProtocol.h>
#import <React/RCTUtils.h>
#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
@interface RNCNaverMapMarker : RCTViewComponentView
#else
#import <React/RCTBridge.h>
@interface RNCNaverMapMarker : RCTView
#endif

@property(nonatomic, weak) RCTBridge* bridge;

@property(nonatomic, strong) NMFMarker* inner;

@property(nonatomic, copy) NMGLatLng* coord;
@property(nonatomic, assign) NSInteger zIndexValue;
@property(nonatomic, assign) NSInteger globalZIndexValue;
@property(nonatomic, assign) BOOL isHidden;
@property(nonatomic, assign) double minZoom;
@property(nonatomic, assign) double maxZoom;
@property(nonatomic, assign) BOOL isMinZoomInclusive;
@property(nonatomic, assign) BOOL isMaxZoomInclusive;
@property(nonatomic, copy) RCTDirectEventBlock onTapOverlay;

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
@property(nonatomic, assign) NSInteger tintColor;

@property(nonatomic, copy) NSDictionary* image;

@property(nonatomic, copy) NSDictionary* caption;
@property(nonatomic, copy) NSDictionary* subCaption;

@end
