//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <Foundation/Foundation.h>
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

@implementation RNCNaverMapViewImpl

- (void)setMapType:(NMFMapType)mapType
{
  _mapType = mapType;
  self.mapView.mapType = mapType;
}

- (void)setIsIndoorEnabled:(BOOL)isIndoorEnabled
{
  [Utils debugE:@"Hello"];
  _isIndoorEnabled = isIndoorEnabled;
  self.mapView.indoorMapEnabled = isIndoorEnabled;
}

- (void)setIsNightModeEnabled:(BOOL)isNightModeEnabled
{
  _isNightModeEnabled = isNightModeEnabled;
  self.mapView.nightModeEnabled = isNightModeEnabled;
}

- (void)setLightness:(NSNumber *)lightness
{
  _lightness = lightness;
  self.mapView.lightness = [lightness floatValue];
}

@end
