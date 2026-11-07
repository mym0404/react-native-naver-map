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

@implementation RNCNaverMapClusterTagMergeStrategy

- (NSObject*)mergeTag:(NMCCluster*)cluster {
  NSMutableArray<NSString*>* markerIdentifiers = [NSMutableArray arrayWithCapacity:cluster.size];
  for (NMCNode* node in cluster.children) {
    if ([node.tag isKindOfClass:[NSArray class]])
      [markerIdentifiers addObjectsFromArray:(NSArray<NSString*>*)node.tag];
  }
  return [markerIdentifiers copy];
}

@end

@implementation RNCNaverMapClusterMarkerUpdater

- (instancetype)initWith:(double)width
                  height:(double)height
                 caption:(facebook::react::RNCNaverMapViewClustersClustersCaptionStruct)caption
      onTapClusterMarker:(OnTapClusterMarker _Nullable)onTapClusterMarker {
  if (self = [super init]) {
    _width = width;
    _height = height;
    _caption = caption;
    _onTapClusterMarker = onTapClusterMarker;
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

  NMFOverlayTouchHandler defaultTouchHandler = marker.touchHandler;
  if (!_onTapClusterMarker || !defaultTouchHandler || ![info.tag isKindOfClass:[NSArray class]])
    return;

  NSArray<NSString*>* markerIdentifiers = [(NSArray<NSString*>*)info.tag copy];
  OnTapClusterMarker onTapClusterMarker = _onTapClusterMarker;
  marker.touchHandler = ^BOOL(NMFOverlay* overlay) {
    onTapClusterMarker(markerIdentifiers);
    return defaultTouchHandler(overlay);
  };
}
#pragma clang diagnostic pop

@end
