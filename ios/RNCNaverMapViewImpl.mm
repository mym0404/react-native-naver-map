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

- (void)setLightness:(NSNumber *)lightness
{
    _lightness = lightness;
    self.mapView.lightness = [lightness floatValue];
}

- (void)setBuildingHeight:(NSNumber *)buildingHeight
{
    _buildingHeight = buildingHeight;
    self.mapView.buildingHeight = [buildingHeight floatValue];
}

- (void)setSymbolScale:(NSNumber *)symbolScale
{
    _symbolScale = symbolScale;
    self.mapView.symbolScale = [symbolScale floatValue];
}

- (void)setSymbolPerspectiveRatio:(NSNumber *)symbolPerspectiveRatio
{
    _symbolPerspectiveRatio = symbolPerspectiveRatio;
    self.mapView.symbolPerspectiveRatio = [symbolPerspectiveRatio floatValue];
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

- (void)setRegion:(NSDictionary *)region
{
    _region = region;

    NMGLatLngBounds *bounds = [RCTConvert NMGLatLngBounds:region];
    NMFCameraUpdate *update = [NMFCameraUpdate cameraUpdateWithFitBounds:bounds];

    [self.mapView moveCamera:update];
}

- (void)setMapPadding:(NSDictionary *)mapPadding
{
    self.mapView.contentInset = UIEdgeInsetsMake(
        [mapPadding[@"top"] doubleValue],
        [mapPadding[@"left"] doubleValue],
        [mapPadding[@"bottom"] doubleValue],
        [mapPadding[@"right"] doubleValue]
        );
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
    NMGLatLngBounds *bounds = [RCTConvert NMGLatLngBounds:@{
                                   @"latitude": @(latitude),
                                   @"longitude": @(longitude),
                                   @"latitudeDelta": @(latitudeDelta),
                                   @"longitudeDelta": @(longitudeDelta),
    }];
    NMFCameraUpdate *update = [NMFCameraUpdate cameraUpdateWithFitBounds:bounds];

    update.animation = getEasingAnimation(easing);
    update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
    update.pivot = CGPointMake(pivotX, pivotY);

    [self.mapView moveCamera:update];
}

@end
