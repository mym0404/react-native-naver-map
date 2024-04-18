//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterMarkerUpdater.h"
#import "RNCNaverMapClusterKey.h"
#import <NMapsMap/NMCBuilder.h>
#import <NMapsMap/NMCCluster.h>
#import <NMapsMap/NMCClusterMarkerInfo.h>
#import <NMapsMap/NMCClusterMarkerUpdater.h>
#import <NMapsMap/NMCClusterer.h>
#import <NMapsMap/NMCComplexBuilder.h>
#import <NMapsMap/NMCDefaultClusterMarkerUpdater.h>
#import <NMapsMap/NMCDefaultLeafMarkerUpdater.h>
#import <NMapsMap/NMCLeafMarkerInfo.h>
#import <NMapsMap/NMCLeafMarkerUpdater.h>
#import <NMapsMap/NMFMarker.h>

@implementation RNCNaverMapClusterMarkerUpdater
- (void)updateClusterMarker:(NMCClusterMarkerInfo*)info marker:(NMFMarker*)marker {
  [super updateClusterMarker:info:marker];
  if (info.size < 3) {
    marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY;
  } else {
    marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY;
  }
}
@end
