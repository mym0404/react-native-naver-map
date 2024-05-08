//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterMarkerUpdater.h"
#import "RNCNaverMapClusterKey.h"
#import <NMapsMap/NMapsMap.h>

@implementation RNCNaverMapClusterMarkerUpdater
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-selector-name"
- (void)updateClusterMarker:(NMCClusterMarkerInfo*)info:(NMFMarker*)marker {
  [super updateClusterMarker:info:marker];
  if (info.size < 3) {
    marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY;
  } else {
    marker.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY;
  }
}
#pragma clang diagnostic pop
@end
