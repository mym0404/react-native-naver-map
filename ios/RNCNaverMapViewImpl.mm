//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <Foundation/Foundation.h>
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"


CGFloat clamp(CGFloat value, CGFloat min, CGFloat max) {
    return MIN(MAX(value, min), max);
}


@implementation RNCNaverMapViewImpl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        // run after _eventEmitter available(new arch), direct event block set(old arch)
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
    self.mapView.lightness = clamp([lightness floatValue], 0, 1);
}

- (void)setBuildingHeight:(NSNumber *)buildingHeight
{
    _buildingHeight = buildingHeight;
    self.mapView.buildingHeight = clamp([buildingHeight floatValue], 0, 1);
}

- (void)setSymbolScale:(NSNumber *)symbolScale
{
    _symbolScale = symbolScale;
    self.mapView.symbolScale = clamp([symbolScale floatValue], 0, 2);
}

- (void)setSymbolPerspectiveRatio:(NSNumber *)symbolPerspectiveRatio
{
    _symbolPerspectiveRatio = symbolPerspectiveRatio;
    self.mapView.symbolPerspectiveRatio = clamp([symbolPerspectiveRatio floatValue], 0, 1);
}

@end
