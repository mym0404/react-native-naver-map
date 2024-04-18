//
//  RNCNaverMapLeafMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapLeafMarkerUpdater.h"

@implementation RNCNaverMapLeafMarkerUpdater

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-selector-name"
- (void)updateLeafMarker:(NMCLeafMarkerInfo* _Nonnull)info:(NMFMarker* _Nonnull)marker {
  [super updateLeafMarker:info:marker];

  RNCNaverMapClusterKey* key = (RNCNaverMapClusterKey*)info.key;

  NSDictionary* image = key.image;

  __weak NMFMarker* weakMarker = marker;
  if (key.bridge) {
    /**
     Fire-forget strategy for cluster leaf marker image at now.
     TODO - handle image request canceller for each markers.
     */
    [Utils getImage:key.bridge
               json:image
           callback:^(NMFOverlayImage* overlayImage) {
             dispatch_async(dispatch_get_main_queue(), ^() {
               if (weakMarker) {
                 weakMarker.iconImage = overlayImage;
               }
             });
           }];
  }
}
#pragma clang diagnostic pop
@end
