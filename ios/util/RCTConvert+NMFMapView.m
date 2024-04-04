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

+ (NMFLogoAlign)NMFLogoAlign:(id)json
{
    json = [self NSString:json];
    
    if([json isEqualToString:@"TopLeft"]) {
        return NMFLogoAlignLeftTop;
    }
    
    if([json isEqualToString:@"TopRight"]) {
        return NMFLogoAlignRightTop;
    }
    
    if([json isEqualToString:@"BottomRight"]) {
        return NMFLogoAlignRightBottom;
    }

    return NMFLogoAlignLeftBottom;
}

+ (RNCNaverMapRegion *)RNCNaverMapRegion:(id)json
{
    json = [self NSDictionary:json];
    return RNCNaverMapRegionMake(
        [self double:json[@"latitude"]],
        [self double:json[@"longitude"]],
        [self double:json[@"latitudeDelta"]],
        [self double:json[@"longitudeDelta"]]);
}

+ (RNCNaverMapRect *)RNCNaverMapRect:(id)json
{
    json = [self NSDictionary:json];
    return RNCNaverMapRectMake(
                               [self double: json[@"top"]],
                               [self double: json[@"right"]],
                               [self double: json[@"bottom"]],
                               [self double: json[@"left"]]);
}

@end
