//
//  RNCNaverMapLeafMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapLeafMarkerUpdater.h"
#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>

@implementation RNCNaverMapLeafMarkerUpdater {
  std::unordered_map<std::string, RNCNaverMapImageCanceller>* _imgRequests;
}

- (id)init:(std::unordered_map<std::string, RNCNaverMapImageCanceller>*)markerImageRequestCanceler {
  if (self = [super init]) {
    _imgRequests = markerImageRequestCanceler;
  }
  return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-selector-name"
- (void)updateLeafMarker:(NMCLeafMarkerInfo* _Nonnull)info:(NMFMarker* _Nonnull)marker {
  [super updateLeafMarker:info:marker];

  RNCNaverMapClusterKey* key = (RNCNaverMapClusterKey*)info.key;

  NSString* identifier = key.identifier;
  facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct image = key.image;

  __weak NMFMarker* weakMarker = marker;

  if (key.width > 0 && isValidNumber(key.width)) {
    marker.width = key.width;
  }
  if (key.height > 0 && isValidNumber(key.height)) {
    marker.height = key.height;
  }

  std::string idStr = [identifier UTF8String];

  RCTBridge* bridge = [RCTBridge currentBridge];
  if (bridge) {
    marker.alpha = 0;
    if (_imgRequests->find(idStr) != _imgRequests->end()) {
      (*_imgRequests)[idStr]();
      _imgRequests->erase(idStr);
    }
    (*_imgRequests)[idStr] =
        nmap::getImage(bridge, image, ^(NMFOverlayImage* _Nullable overlayImage) {
          dispatch_async(dispatch_get_main_queue(), ^{
            if (weakMarker) {
              weakMarker.alpha = 1;
              weakMarker.iconImage = !overlayImage ? NMF_MARKER_IMAGE_GREEN : overlayImage;
            }
            self->_imgRequests->erase(idStr);
          });
        });
  }

  [marker setTouchHandler:^BOOL(NMFOverlay* __weak overlay) {
    if (key.onTapLeafMarker) {
      key.onTapLeafMarker();
      return YES;
    }
    return NO;
  }];
}
#pragma clang diagnostic pop

@end
