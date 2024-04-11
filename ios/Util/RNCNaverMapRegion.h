//
//  RNCNaverMapRegion.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/5/24.
//

#ifndef RNCNaverMapRegion_h
#define RNCNaverMapRegion_h

#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMGLatLngBounds.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapRegion : NSObject

@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double latitudeDelta;
@property(nonatomic, assign) double longitudeDelta;

- (instancetype)init:(double)lat
                 lng:(double)lng
            latDelta:(double)latDelta
            lngDelta:(double)lngDelta;

- (NMGLatLngBounds*)convertToNMGLatLngBounds;

@end

static inline RNCNaverMapRegion* _Nonnull RNCNaverMapRegionMake(double latitude, double longitude,
                                                                double latitudeDelta,
                                                                double longitudeDelta) {
  return [[RNCNaverMapRegion alloc] init:latitude
                                     lng:longitude
                                latDelta:latitudeDelta
                                lngDelta:longitudeDelta];
}

NS_ASSUME_NONNULL_END

#endif /* ifndef RNCNaverMapRegion_h */
