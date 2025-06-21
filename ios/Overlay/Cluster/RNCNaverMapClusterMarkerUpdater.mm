//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterMarkerUpdater.h"
#import "MacroUtil.h"
#import "RNCNaverMapClusterKey.h"

@implementation RNCNaverMapClusterMarkerUpdater

- (instancetype)initWith:(double)width height:(double)height {
  if (self = [super init]) {
    _width = width;
    _height = height;
  }
  return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-selector-name"
- (void)updateClusterMarker:(NMCClusterMarkerInfo*)info:(NMFMarker*)marker {
  [super updateClusterMarker:info:marker];
  marker.width = isValidNumber(_width) && _width ? _width : NMF_MARKER_SIZE_AUTO;
  marker.height = isValidNumber(_height) && _height ? _height : NMF_MARKER_SIZE_AUTO;
}
#pragma clang diagnostic pop

@end
