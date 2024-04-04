//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <Foundation/Foundation.h>
#import "FnUtil.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

NMFCameraUpdateAnimation getEasingAnimation(int easing) {
    if (easing == 1) {
        return NMFCameraUpdateAnimationNone;
    }

    if (easing == 2) {
        return NMFCameraUpdateAnimationLinear;
    }

    if (easing == 3) {
        return NMFCameraUpdateAnimationFly;
    }

    if (easing == 4) {
        return NMFCameraUpdateAnimationEaseOut;
    }

    return NMFCameraUpdateAnimationEaseIn;
}

//@interface RNCNaverMapViewImpl () <RCTRNCNaverMapViewViewProtocol>
//
//@end

@implementation RNCNaverMapViewImpl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

//        [self.mapView addCameraDelegate:self];
//        [self.mapView setTouchDelegate:self];
        [self.mapView addOptionDelegate:self];

        // run after _eventEmitter available(new arch), direct event block set(old arch)
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            self.onInitialized(@{});
        });
    }

    return self;
}

// MARK: - SETTER

- (void)setMapType:(NMFMapType)mapType
{
    _mapType = mapType;
    self.mapView.mapType = mapType;
}

- (void)setIsIndoorEnabled:(BOOL)isIndoorEnabled
{
    _isIndoorEnabled = isIndoorEnabled;
    self.mapView.indoorMapEnabled = isIndoorEnabled;
}

- (void)setIsNightModeEnabled:(BOOL)isNightModeEnabled
{
    _isNightModeEnabled = isNightModeEnabled;
    self.mapView.nightModeEnabled = isNightModeEnabled;
}

- (void)setIsLiteModeEnabled:(BOOL)isLiteModeEnabled
{
    _isLiteModeEnabled = isLiteModeEnabled;
    self.mapView.liteModeEnabled = isLiteModeEnabled;
}

- (void)setLightness:(double)lightness
{
    _lightness = lightness;
    self.mapView.lightness = lightness;
}

- (void)setBuildingHeight:(double)buildingHeight
{
    _buildingHeight = buildingHeight;
    self.mapView.buildingHeight = buildingHeight;
}

- (void)setSymbolScale:(double)symbolScale
{
    _symbolScale = symbolScale;
    self.mapView.symbolScale = symbolScale;
}

- (void)setSymbolPerspectiveRatio:(double)symbolPerspectiveRatio
{
    _symbolPerspectiveRatio = symbolPerspectiveRatio;
    self.mapView.symbolPerspectiveRatio = symbolPerspectiveRatio;
}

- (void)setCamera:(NSDictionary *)camera
{
    _camera = camera;

    NMFCameraPosition *prev = self.mapView.cameraPosition;
    double latitude = getDoubleOrDefault(camera[@"latitude"], prev.target.lat);
    double longitude = getDoubleOrDefault(camera[@"longitude"], prev.target.lng);
    double zoom = getDoubleOrDefault(camera[@"zoom"], prev.zoom);
    double tilt = getDoubleOrDefault(camera[@"tilt"], prev.tilt);
    double heading = getDoubleOrDefault(camera[@"bearing"], prev.heading);

    NMGLatLng *p = NMGLatLngMake(latitude, longitude);
    NMFCameraPosition *cameraPosition = [NMFCameraPosition cameraPosition:p
                                                                     zoom:zoom
                                                                     tilt:tilt
                                                                  heading:heading];
    NMFCameraUpdate *update = [NMFCameraUpdate cameraUpdateWithPosition:cameraPosition];

    [self.mapView moveCamera:update];
}

- (void)setRegion:(RNCNaverMapRegion *)region
{
    _region = region;

    NMFCameraUpdate *update = [NMFCameraUpdate
                               cameraUpdateWithFitBounds:[region convertToNMGLatLngBounds]];

    [self.mapView moveCamera:update];
}

- (void)setMapPadding:(RNCNaverMapRect *)mapPadding
{
    self.mapView.contentInset = [mapPadding convertToUIEdgeInsets];
}

- (void)setIsShowCompass:(BOOL)isShowCompass
{
    _isShowCompass = isShowCompass;
    self.showCompass = isShowCompass;
}

- (void)setIsShowScaleBar:(BOOL)isShowScaleBar
{
    _isShowScaleBar = isShowScaleBar;
    self.showScaleBar = isShowScaleBar;
}

- (void)setIsShowZoomControls:(BOOL)isShowZoomControls
{
    _isShowZoomControls = isShowZoomControls;
    self.showZoomControls = isShowZoomControls;
}

- (void)setIsShowIndoorLevelPicker:(BOOL)isShowIndoorLevelPicker
{
    _isShowIndoorLevelPicker = isShowIndoorLevelPicker;
    self.showIndoorLevelPicker = isShowIndoorLevelPicker;
}

- (void)setIsShowLocationButton:(BOOL)isShowLocationButton
{
    _isShowLocationButton = isShowLocationButton;
    self.showLocationButton = isShowLocationButton;
}

- (void)setLogoMargin:(RNCNaverMapRect *)logoMargin
{
    self.mapView.logoMargin = [logoMargin convertToUIEdgeInsets];
}

- (void)setLogoAlign:(NMFLogoAlign)logoAlign
{
    self.mapView.logoAlign = logoAlign;
}

- (void)setMinZoom:(double)minZoom
{
    _minZoom = minZoom;
    self.mapView.minZoomLevel = minZoom;
}

- (void)setMaxZoom:(double)maxZoom
{
    _maxZoom = maxZoom;
    self.mapView.maxZoomLevel = maxZoom;
}

- (void)setExtent:(RNCNaverMapRegion *)extent
{
    _extent = extent;
    self.mapView.extent = [extent convertToNMGLatLngBounds];
}

// MARK: - EVENT

- (void)mapViewOptionChanged:(NMFMapView *)mapView
{
    self.onOptionChanged(@{});
}


// MARK: - COMMAND

- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
{
    NMFCameraUpdate *update =
        [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)];

    update.animation = getEasingAnimation(easing);
    update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
    update.pivot = CGPointMake(pivotX, pivotY);
    [self.mapView moveCamera:update];
}

- (void)animateCameraBy:(double)x
                      y:(double)y
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
{
    NMFCameraUpdate *update =
        [NMFCameraUpdate cameraUpdateWithScrollBy:CGPointMake(x, y)];

    update.animation = getEasingAnimation(easing);
    update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
    update.pivot = CGPointMake(pivotX, pivotY);
    [self.mapView moveCamera:update];
}

- (void)animateRegionTo:(double)latitude
              longitude:(double)longitude
          latitudeDelta:(double)latitudeDelta
         longitudeDelta:(double)longitudeDelta
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
{
    RNCNaverMapRegion *region = RNCNaverMapRegionMake(latitude, longitude, latitudeDelta, longitudeDelta);
    NMFCameraUpdate *update = [NMFCameraUpdate
                               cameraUpdateWithFitBounds:[region convertToNMGLatLngBounds]];

    update.animation = getEasingAnimation(easing);
    update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
    update.pivot = CGPointMake(pivotX, pivotY);

    [self.mapView moveCamera:update];
}

@end
