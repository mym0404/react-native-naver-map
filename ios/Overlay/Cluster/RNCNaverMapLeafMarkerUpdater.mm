//
//  RNCNaverMapLeafMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapLeafMarkerUpdater.h"

@implementation RNCNaverMapLeafMarkerUpdater
- (void)updateLeafMarker:(NMCLeafMarkerInfo* _Nonnull)info marker:(NMFMarker* _Nonnull)marker {
  [super updateLeafMarker:info:marker];
  RNCNaverMapClusterKey* key = (RNCNaverMapClusterKey*)info.key;
  NSArray<NMFOverlayImage*>* icons = @[
    NMF_MARKER_IMAGE_BLUE, NMF_MARKER_IMAGE_GREEN, NMF_MARKER_IMAGE_RED, NMF_MARKER_IMAGE_YELLOW
  ];
  //  marker.iconImage = icons[key.identifier % icons.count];
  //  __block typeof(self) weakSelf = self;
  //  marker.touchHandler = ^BOOL(NMFOverlay* _Nonnull __weak overlay) {
  //    [weakSelf.clusterer remove:(RNCNaverMapClusterKey*)info.key];
  //    return YES;
  //  };
}
@end
