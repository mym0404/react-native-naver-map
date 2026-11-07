//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterKey.h"
#import <NMapsMap/NMapsMap.h>

typedef void (^OnTapClusterMarker)(NSArray<NSString*>* markerIdentifiers);

@interface RNCNaverMapClusterTagMergeStrategy : NSObject <NMCTagMergeStrategy>

@end

@interface RNCNaverMapClusterMarkerUpdater : NMCDefaultClusterMarkerUpdater

// invalid number means undefined in js
@property(nonatomic, assign) double width;
// invalid number means undefined in js
@property(nonatomic, assign) double height;
@property(nonatomic, strong, nullable) NMFOverlayImage* resolvedImage;
@property(nonatomic, assign) facebook::react::RNCNaverMapViewClustersClustersCaptionStruct caption;
@property(nonatomic, copy, nullable) OnTapClusterMarker onTapClusterMarker;

- (instancetype)initWith:(double)width
                  height:(double)height
                 caption:(facebook::react::RNCNaverMapViewClustersClustersCaptionStruct)caption
      onTapClusterMarker:(OnTapClusterMarker _Nullable)onTapClusterMarker;

@end
