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

- (void)setCenterPosition:(NSDictionary *)centerPosition
{
    double latitude = getDoubleOrZero(centerPosition[@"latitude"]);
    double longitude = getDoubleOrZero(centerPosition[@"longitude"]);
    double zoom = getDoubleOrZero(centerPosition[@"zoom"]);
    double tilt = getDoubleOrZero(centerPosition[@"tilt"]);
    double bearing = getDoubleOrZero(centerPosition[@"bearing"]);

    auto p = NMGLatLngMake(latitude, longitude);
    auto cameraPosition = [NMFCameraPosition cameraPosition:p
                                                       zoom:zoom
                                                       tilt:tilt
                                                    heading:bearing];
    auto update = [NMFCameraUpdate cameraUpdateWithPosition:cameraPosition];

    [self.mapView moveCamera:update];
}

- (void)mapViewOptionChanged:(NMFMapView *)mapView
{
    self.onOptionChanged(@{});
}

@end
