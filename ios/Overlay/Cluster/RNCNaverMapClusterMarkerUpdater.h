//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterKey.h"
#import <NMapsMap/NMapsMap.h>

@interface RNCNaverMapClusterMarkerUpdater : NMCDefaultClusterMarkerUpdater

// invalid number means undefined in js
@property(nonatomic, assign) double width;
// invalid number means undefined in js
@property(nonatomic, assign) double height;
@property(nonatomic, strong, nullable) NMFOverlayImage* resolvedImage;
@property(nonatomic, assign) facebook::react::RNCNaverMapViewClustersClustersCaptionStruct caption;

- (instancetype)initWith:(double)width
                  height:(double)height
                 caption:(facebook::react::RNCNaverMapViewClustersClustersCaptionStruct)caption;

@end
