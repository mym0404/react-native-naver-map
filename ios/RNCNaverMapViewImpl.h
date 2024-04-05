//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#ifndef RNCNaverMapViewImpl_h
#define RNCNaverMapViewImpl_h

#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMGLatLng.h>
#import <NMapsGeometry/NMGLatLngBounds.h>
#import <NMapsMap/NMFCameraPosition.h>
#import <NMapsMap/NMFCameraUpdate.h>
#import <NMapsMap/NMFMapView.h>
#import <NMapsMap/NMFMapViewCameraDelegate.h>
#import <NMapsMap/NMFMapViewOptionDelegate.h>
#import <NMapsMap/NMFMapViewTouchDelegate.h>
#import <NMapsMap/NMFNaverMapView.h>
#import <NMapsMap/NMFOverlay.h>
#import <react/renderer/components/RNCNaverMapViewSpec/Props.h>
#import <react/renderer/components/RNCNaverMapViewSpec/RCTComponentViewHelpers.h>
#import <React/RCTConvert.h>
#import <React/RCTView.h>
#import "RCTConvert+NMFMapView.h"

using namespace facebook::react;

/**
   Real implementation of Naver Map View

   In old architecture, this is instantiated from `- (UIView *)view`.

   In new architecture, this is instantiated from `initWithFrame` of `RNCNaverMapView.mm`
 */
@interface RNCNaverMapViewImpl : NMFNaverMapView <
        NMFMapViewTouchDelegate,
        NMFMapViewCameraDelegate,
        NMFMapViewOptionDelegate,
        RCTRNCNaverMapViewViewProtocol
        >

@property (nonatomic, assign) NMFMapType mapType;
@property (nonatomic, copy) NSDictionary *camera;
@property (nonatomic, copy) NSDictionary *initialCamera;
@property (nonatomic, copy) RNCNaverMapRegion *region;
@property (nonatomic, copy) RNCNaverMapRegion *initialRegion;
@property (nonatomic, copy) RNCNaverMapRect *mapPadding;
@property (nonatomic, assign) BOOL isIndoorEnabled;
@property (nonatomic, assign) BOOL isNightModeEnabled;
@property (nonatomic, assign) BOOL isLiteModeEnabled;
@property (nonatomic, assign) double lightness;
@property (nonatomic, assign) double buildingHeight;
@property (nonatomic, assign) double symbolScale;
@property (nonatomic, assign) double symbolPerspectiveRatio;
@property (nonatomic, assign) BOOL isShowCompass;
@property (nonatomic, assign) BOOL isShowIndoorLevelPicker;
@property (nonatomic, assign) BOOL isShowLocationButton;
@property (nonatomic, assign) BOOL isShowScaleBar;
@property (nonatomic, assign) BOOL isShowZoomControls;
@property (nonatomic, copy) RNCNaverMapRect* logoMargin;
@property (nonatomic, assign) NMFLogoAlign logoAlign;
@property (nonatomic, assign) double minZoom;
@property (nonatomic, assign) double maxZoom;
@property (nonatomic, copy) RNCNaverMapRegion *extent;
@property (nonatomic, assign) BOOL isScrollGesturesEnabled;
@property (nonatomic, assign) BOOL isZoomGesturesEnabled;
@property (nonatomic, assign) BOOL isTiltGesturesEnabled;
@property (nonatomic, assign) BOOL isRotateGesturesEnabled;
@property (nonatomic, assign) BOOL isStopGesturesEnabled;

@property (nonatomic, copy) RCTDirectEventBlock onInitialized;
@property (nonatomic, copy) RCTDirectEventBlock onOptionChanged;
@property (nonatomic, copy) RCTDirectEventBlock onCameraChanged;
@property (nonatomic, copy) RCTDirectEventBlock onTapMap;

@end

#endif /* ifndef RNCNaverMapViewImpl_h */
