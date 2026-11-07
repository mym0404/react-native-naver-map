//
//  RNCNaverMapClusterMarkerUpdater.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//
#import "RNCNaverMapClusterMarkerUpdater.h"
#import "ColorUtil.h"
#import "MacroUtil.h"
#import "RNCNaverMapClusterKey.h"

@implementation RNCNaverMapClusterMarkerUpdater

- (instancetype)initWith:(double)width
                  height:(double)height
                 caption:(facebook::react::RNCNaverMapViewClustersClustersCaptionStruct)caption {
  if (self = [super init]) {
    _width = width;
    _height = height;
    _caption = caption;
  }
  return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-selector-name"
- (void)updateClusterMarker:(NMCClusterMarkerInfo*)info:(NMFMarker*)marker {
  [super updateClusterMarker:info:marker];

  if (_resolvedImage)
    marker.iconImage = _resolvedImage;

  marker.width = isValidNumber(_width) && _width ? _width : NMF_MARKER_SIZE_AUTO;
  marker.height = isValidNumber(_height) && _height ? _height : NMF_MARKER_SIZE_AUTO;

  if (!_caption.usesDefaultText)
    marker.captionText = getNsStr(_caption.text);
  marker.captionRequestedWidth = _caption.requestedWidth;
  marker.captionAligns = @[ nmap::createAlign(_caption.align) ];
  marker.captionOffset = _caption.offset;
  marker.captionColor = nmap::intToColor(_caption.color);
  marker.captionHaloColor = nmap::intToColor(_caption.haloColor);
  marker.captionTextSize = _caption.textSize;
  marker.captionMinZoom = _caption.minZoom;
  marker.captionMaxZoom = _caption.maxZoom;
}
#pragma clang diagnostic pop

@end
