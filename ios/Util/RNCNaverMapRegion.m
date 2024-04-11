//
//  RNCNaverMapRegion.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/5/24.
//

#import "RNCNaverMapRegion.h"

@implementation RNCNaverMapRegion

- (instancetype)init:(double)lat
                 lng:(double)lng
            latDelta:(double)latDelta
            lngDelta:(double)lngDelta {
  self = [super init];

  if (self) {
    _latitude = lat;
    _longitude = lng;
    _latitudeDelta = latDelta;
    _longitudeDelta = lngDelta;
  }

  return self;
}

- (NMGLatLngBounds*)convertToNMGLatLngBounds {
  return NMGLatLngBoundsMake(_latitude, _longitude, _latitude + _latitudeDelta,
                             _longitude + _longitudeDelta);
}

@end
