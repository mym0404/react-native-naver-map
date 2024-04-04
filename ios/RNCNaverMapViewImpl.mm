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

        [self.mapView addCameraDelegate:self];
//        [self.mapView setTouchDelegate:self];
        [self.mapView addOptionDelegate:self];

        // run after _eventEmitter available(new arch), direct event block set(old arch)
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            self.onInitialized(@{});
        });
    }

    return self;
}

// MARK: - PROPERTY

BOOL _initialRegionSet;
BOOL _initialCameraSet;

// MARK: - SETTER

#define RNMAP_QUICK_SETTER(cap, name, type) \
    - (void)set ## cap:(type)name {         \
        _ ## name = name;                   \
        self.mapView.name = name;           \
    }
#define RNMAP_REMAP_QUICK_SETTER(cap, name, view_prop, type) \
    - (void)set ## cap:(type)name {                          \
        _ ## name = name;                                    \
        self.view_prop = name;                               \
    }
RNMAP_QUICK_SETTER(MapType, mapType, NMFMapType)
RNMAP_REMAP_QUICK_SETTER(IsIndoorEnabled, isIndoorEnabled, mapView.indoorMapEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsNightModeEnabled, isNightModeEnabled, mapView.nightModeEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsLiteModeEnabled, isLiteModeEnabled, mapView.liteModeEnabled, BOOL)
RNMAP_QUICK_SETTER(Lightness, lightness, double)
RNMAP_QUICK_SETTER(BuildingHeight, buildingHeight, double)
RNMAP_QUICK_SETTER(SymbolScale, symbolScale, double)
RNMAP_QUICK_SETTER(SymbolPerspectiveRatio, symbolPerspectiveRatio, double)
RNMAP_REMAP_QUICK_SETTER(IsShowCompass, isShowCompass, showCompass, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsShowScaleBar, isShowScaleBar, showScaleBar, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsShowZoomControls, isShowZoomControls, showZoomControls, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsShowIndoorLevelPicker, isShowIndoorLevelPicker, showIndoorLevelPicker, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsShowLocationButton, isShowLocationButton, showLocationButton, BOOL)
RNMAP_QUICK_SETTER(LogoAlign, logoAlign, NMFLogoAlign)
RNMAP_REMAP_QUICK_SETTER(MinZoom, minZoom, mapView.minZoomLevel, double)
RNMAP_REMAP_QUICK_SETTER(MaxZoom, maxZoom, mapView.maxZoomLevel, double)
RNMAP_REMAP_QUICK_SETTER(IsScrollGesturesEnabled, isScrollGesturesEnabled, mapView.scrollGestureEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsZoomGesturesEnabled, isZoomGesturesEnabled, mapView.zoomGestureEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsTiltGesturesEnabled, isTiltGesturesEnabled, mapView.tiltGestureEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsRotateGesturesEnabled, isRotateGesturesEnabled, mapView.rotateGestureEnabled, BOOL)
RNMAP_REMAP_QUICK_SETTER(IsStopGesturesEnabled, isStopGesturesEnabled, mapView.stopGestureEnabled, BOOL)

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

- (void)setInitialCamera:(NSDictionary *)initialCamera
{
    if (!_initialCameraSet) {
        _initialCameraSet = YES;

        if (isValidNumber(initialCamera[@"latitude"])) {
            [self setCamera:initialCamera];
        }
    }
}

- (void)setRegion:(RNCNaverMapRegion *)region
{
    _region = region;

    NMFCameraUpdate *update = [NMFCameraUpdate
                               cameraUpdateWithFitBounds:[region convertToNMGLatLngBounds]];

    [self.mapView moveCamera:update];
}

- (void)setInitialRegion:(RNCNaverMapRegion *)initialRegion
{
    if (!_initialRegionSet) {
        _initialRegionSet = YES;

        if (isValidNumber(initialRegion.latitude)) {
            [self setRegion:initialRegion];
        }
    }
}

- (void)setMapPadding:(RNCNaverMapRect *)mapPadding
{
    self.mapView.contentInset = [mapPadding convertToUIEdgeInsets];
}

- (void)setLogoMargin:(RNCNaverMapRect *)logoMargin
{
    self.mapView.logoMargin = [logoMargin convertToUIEdgeInsets];
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

- (void)mapView:(NMFMapView *)mapView cameraIsChangingByReason:(NSInteger)reason
{
    NMFCameraPosition *pos = mapView.cameraPosition;

    self.onCameraChanged(@{
        @"latitude": @(pos.target.lat),
        @"longitude": @(pos.target.lng),
        @"zoom": @(pos.zoom),
        @"tilt": @(pos.tilt),
        @"bearing": @(pos.heading),
        @"reason": @(reason == NMFMapChangedByDeveloper ? 0 :
                     reason == NMFMapChangedByGesture ? 1 :
                     reason == NMFMapChangedByControl ? 2 :
                     reason == NMFMapChangedByLocation ? 3 :
                     0)
        });
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
