//
//  RCTConvert+NMFMapView.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//



#import "RCTConvert+NMFMapView.h"

@implementation RCTConvert (NMFMapView)

RCT_ENUM_CONVERTER(NMFMapType, (@{
    @"Basic": @(NMFMapTypeBasic),
    @"Navi": @(NMFMapTypeNavi),
    @"Satellite": @(NMFMapTypeSatellite),
    @"Hybrid": @(NMFMapTypeHybrid),
    @"Terrain": @(NMFMapTypeTerrain),
    @"NaviHybrid": @(NMFMapTypeNaviHybrid),
    @"None": @(NMFMapTypeNone),
    }), NMFMapTypeBasic, integerValue)

+ (NMGLatLngBounds *)NMGLatLngBounds:(id)json
{
    json = [self NSDictionary:json];
    double lat = [self double:json[@"latitude"]];
    double latDelta = [self double:json[@"latitudeDelta"]];
    double lng = [self double:json[@"longitude"]];
    double lngDelta = [self double:json[@"longitudeDelta"]];
    return NMGLatLngBoundsMake(lat - latDelta / 2, lng - lngDelta / 2, // southwest
                               lat + latDelta / 2, lng + lngDelta / 2); // northeast
}

+ (NMFAlignType *)NMFAlignType:(id)json
{
    json = [self NSNumber:json];

    if ([json isEqual:@(0)]) {
        return NMFAlignType.center;
    }

    if ([json isEqual:@(1)]) {
        return NMFAlignType.left;
    }

    if ([json isEqual:@(2)]) {
        return NMFAlignType.right;
    }

    if ([json isEqual:@(3)]) {
        return NMFAlignType.top;
    }

    if ([json isEqual:@(4)]) {
        return NMFAlignType.bottom;
    }

    if ([json isEqual:@(5)]) {
        return NMFAlignType.topLeft;
    }

    if ([json isEqual:@(6)]) {
        return NMFAlignType.topRight;
    }

    if ([json isEqual:@(7)]) {
        return NMFAlignType.bottomRight;
    }

    if ([json isEqual:@(8)]) {
        return NMFAlignType.bottomLeft;
    }

    return NMFAlignType.bottom;
}

@end
