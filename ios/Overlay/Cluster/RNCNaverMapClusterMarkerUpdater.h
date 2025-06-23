//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "ImageUtil.h"
#import "RNCNaverMapClusterKey.h"
#import <NMapsMap/NMapsMap.h>

@interface RNCNaverMapClusterMarkerUpdater : NMCDefaultClusterMarkerUpdater

// invalid number means undefined in js
@property(nonatomic, assign) double width;
// invalid number means undefined in js
@property(nonatomic, assign) double height;
@property(nonatomic, assign)
    facebook::react::RNCNaverMapViewClustersClustersImageStruct image;

- (instancetype)initWith:(double)width height:(double)height
                   image:
(facebook::react::RNCNaverMapViewClustersClustersImageStruct)image;

@end
