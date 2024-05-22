#import "RNCNaverMapView.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTRNCNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
  BOOL _isRecycled;
  RNCNaverMapViewImpl* _view;

  std::unordered_map<std::string, NMCClusterer*> _clustererRecord;
  std::unordered_map<std::string, std::vector<std::string>> _clustererMarkerIdentifiers;
  std::unordered_map<std::string, RNCNaverMapImageCanceller> _clusterMarkerImageRequestCancelers;
}

+ (bool)shouldBeRecycled {
  return NO;
}

- (NMFMapView*)map {
  return _view.mapView;
}

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<facebook::react::RNCNaverMapViewEventEmitter const>)emitter {
  if (!_eventEmitter) {
    return nullptr;
  }
  return std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _isRecycled = YES;
    static const auto defaultProps = std::make_shared<const RNCNaverMapViewProps>();
    _props = defaultProps;

    _view = [[RNCNaverMapViewImpl alloc] init];
    _view.rncParent = self;

    self.contentView = _view;
  }

  return self;
}

- (void)dealloc {
  for (const auto& [key, clusterer] : _clustererRecord) {
    clusterer.mapView = nil;

    for (const std::string& markerIdentifier : _clustererMarkerIdentifiers[key]) {
      if (_clusterMarkerImageRequestCancelers.find(markerIdentifier) !=
          _clusterMarkerImageRequestCancelers.end()) {
        _clusterMarkerImageRequestCancelers[markerIdentifier]();
        _clusterMarkerImageRequestCancelers.erase(markerIdentifier);
      }
    }
  }

  _clustererMarkerIdentifiers.clear();
  _clustererRecord.clear();
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                          index:(NSInteger)index {
  [_view insertReactSubview:childComponentView atIndex:index];
}
- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                            index:(NSInteger)index {
  [_view removeReactSubview:childComponentView];
}
#pragma clang diagnostic pop

- (void)prepareForRecycle {
  [_view prepareForRecycle];
  _isRecycled = YES;
  [super prepareForRecycle];
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);

  if (prev.mapType != next.mapType) {
    if (next.mapType == RNCNaverMapViewMapType::Basic) {
      self.map.mapType = NMFMapTypeBasic;
    } else if (next.mapType == RNCNaverMapViewMapType::Navi) {
      self.map.mapType = NMFMapTypeNavi;
    } else if (next.mapType == RNCNaverMapViewMapType::Satellite) {
      self.map.mapType = NMFMapTypeSatellite;
    } else if (next.mapType == RNCNaverMapViewMapType::Hybrid) {
      self.map.mapType = NMFMapTypeHybrid;
    } else if (next.mapType == RNCNaverMapViewMapType::Terrain) {
      self.map.mapType = NMFMapTypeTerrain;
    } else if (next.mapType == RNCNaverMapViewMapType::NaviHybrid) {
      self.map.mapType = NMFMapTypeNaviHybrid;
    } else if (next.mapType == RNCNaverMapViewMapType::None) {
      self.map.mapType = NMFMapTypeNone;
    }
  }

  if (prev.layerGroups != next.layerGroups) {
    int layerGroups = next.layerGroups;
    BOOL building = layerGroups & (1 << 0);
    BOOL traffic = layerGroups & (1 << 1);
    BOOL transit = layerGroups & (1 << 2);
    BOOL bicycle = layerGroups & (1 << 3);
    BOOL mountain = layerGroups & (1 << 4);
    BOOL cadastral = layerGroups & (1 << 5);

    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_BUILDING] != building) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_BUILDING isEnabled:building];
    }
    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_TRAFFIC] != traffic) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_TRAFFIC isEnabled:traffic];
    }
    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_TRANSIT] != transit) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_TRANSIT isEnabled:transit];
    }
    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_BICYCLE] != bicycle) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_BICYCLE isEnabled:bicycle];
    }
    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_MOUNTAIN] != mountain) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_MOUNTAIN isEnabled:mountain];
    }
    if ([self.map getLayerGroupEnabled:NMF_LAYER_GROUP_CADASTRAL] != cadastral) {
      [self.map setLayerGroup:NMF_LAYER_GROUP_CADASTRAL isEnabled:cadastral];
    }
  }

  if (prev.isIndoorEnabled != next.isIndoorEnabled)
    [self.map setIndoorMapEnabled:next.isIndoorEnabled];
  if (prev.isNightModeEnabled != next.isNightModeEnabled)
    [self.map setNightModeEnabled:next.isNightModeEnabled];
  if (prev.isLiteModeEnabled != next.isLiteModeEnabled)
    [self.map setLiteModeEnabled:next.isLiteModeEnabled];
  if (prev.lightness != next.lightness)
    [self.map setLightness:next.lightness];
  if (prev.buildingHeight != next.buildingHeight)
    [self.map setBuildingHeight:next.buildingHeight];
  if (prev.symbolScale != next.symbolScale)
    [self.map setSymbolScale:next.symbolScale];
  if (prev.symbolPerspectiveRatio != next.symbolPerspectiveRatio)
    [self.map setSymbolPerspectiveRatio:next.symbolPerspectiveRatio];
  if (prev.isShowCompass != next.isShowCompass)
    [_view setShowCompass:next.isShowCompass];
  if (prev.isShowIndoorLevelPicker != next.isShowIndoorLevelPicker)
    [_view setShowIndoorLevelPicker:next.isShowIndoorLevelPicker];
  if (prev.isShowLocationButton != next.isShowLocationButton)
    [_view setShowLocationButton:next.isShowLocationButton];
  if (prev.isShowScaleBar != next.isShowScaleBar)
    [_view setShowScaleBar:next.isShowScaleBar];
  if (prev.isShowZoomControls != next.isShowZoomControls)
    [_view setShowZoomControls:next.isShowZoomControls];

  if (prev.logoAlign != next.logoAlign) {
    if (next.logoAlign == RNCNaverMapViewLogoAlign::TopLeft)
      [self.map setLogoAlign:NMFLogoAlignLeftTop];
    else if (next.logoAlign == RNCNaverMapViewLogoAlign::TopRight)
      [self.map setLogoAlign:NMFLogoAlignRightTop];
    else if (next.logoAlign == RNCNaverMapViewLogoAlign::BottomLeft)
      [self.map setLogoAlign:NMFLogoAlignLeftBottom];
    else if (next.logoAlign == RNCNaverMapViewLogoAlign::BottomRight)
      [self.map setLogoAlign:NMFLogoAlignRightBottom];
  }

  if (prev.minZoom != next.minZoom)
    [self.map setMinZoomLevel:next.minZoom];
  if (prev.maxZoom != next.maxZoom)
    [self.map setMaxZoomLevel:next.maxZoom];

  if (prev.isScrollGesturesEnabled != next.isScrollGesturesEnabled)
    [self.map setScrollGestureEnabled:next.isScrollGesturesEnabled];
  if (prev.isZoomGesturesEnabled != next.isZoomGesturesEnabled)
    [self.map setZoomGestureEnabled:next.isZoomGesturesEnabled];
  if (prev.isTiltGesturesEnabled != next.isTiltGesturesEnabled)
    [self.map setTiltGestureEnabled:next.isTiltGesturesEnabled];
  if (prev.isRotateGesturesEnabled != next.isRotateGesturesEnabled)
    [self.map setRotateGestureEnabled:next.isRotateGesturesEnabled];
  if (prev.isStopGesturesEnabled != next.isStopGesturesEnabled)
    [self.map setStopGestureEnabled:next.isStopGesturesEnabled];

  if (prev.animationDuration != next.animationDuration)
    _view.animationDuration = next.animationDuration;
  if (prev.animationEasing != next.animationEasing)
    _view.animationEasing = next.animationEasing;
  if (prev.locale != next.locale)
    [self.map setLocale:getNsStr(next.locale)];

  if (!nmap::isRectEqual(prev.mapPadding, next.mapPadding))
    [self.map setContentInset:UIEdgeInsetsMake(next.mapPadding.top, next.mapPadding.left,
                                               next.mapPadding.bottom, next.mapPadding.right)];

  if (!nmap::isRectEqual(prev.logoMargin, next.logoMargin)) {
    [self.map setLogoMargin:nmap::createUIEdgeInsets(next.logoMargin)];
  }

  if (!nmap::isRegionEqual(prev.extent, next.extent)) {
    [self.map setExtent:nmap::createLatLngBounds(next.extent)];
  }

  if (!nmap::isCameraEqual(prev.camera, next.camera) && isValidNumber(next.camera.latitude))
    _view.camera = nmap::createCameraDictionary(next.camera);
  if (isValidNumber(next.initialCamera.latitude))
    _view.initialCamera = nmap::createCameraDictionary(next.initialCamera);

  if (!nmap::isRegionEqual(prev.region, next.region) && isValidNumber(next.region.latitude))
    _view.region = nmap::createLatLngBounds(next.region);
  if (isValidNumber(next.initialRegion.latitude))
    _view.initialRegion = nmap::createLatLngBounds(next.initialRegion);

  {
    auto o1 = prev.locationOverlay, o2 = next.locationOverlay;
    if ((o1.isVisible != o2.isVisible || o1.position.latitude != o2.position.longitude ||
         o1.bearing != o2.bearing || !nmap::isImageEqual(o1.image, o2.image) ||
         o1.imageWidth != o2.imageWidth || o1.imageHeight != o2.imageHeight ||
         o1.anchor.x != o2.anchor.x || o1.anchor.y != o2.anchor.y ||
         !nmap::isImageEqual(o1.subImage, o2.subImage) || o1.subImageWidth != o2.subImageWidth ||
         o1.subImageHeight != o2.subImageHeight || o1.subAnchor.x != o2.subAnchor.x ||
         o1.subAnchor.y != o2.subAnchor.y || o1.circleRadius != o2.circleRadius ||
         o1.circleColor != o2.circleColor || o1.circleOutlineWidth != o2.circleOutlineWidth ||
         o1.circleOutlineColor != o2.circleOutlineColor) &&
        isValidNumber(o2.circleOutlineWidth)) {
      //      _view.locationOverlay = @{
      //        @"isVisible" : @(o2.isVisible),
      //        @"position" : nmap::createLatLngPropDictionary(o2.position),
      //        @"bearing" : @(o2.bearing),
      //        @"image" : nmap::createImagePropDictinary(o2.image),
      //        @"imageWidth" : @(o2.imageWidth),
      //        @"imageHeight" : @(o2.imageHeight),
      //        @"anchor" : nmap::createAnchorPropDictionary(o2.anchor),
      //        @"subImage" : nmap::createImagePropDictinary(o2.subImage),
      //        @"subImageWidth" : @(o2.subImageWidth),
      //        @"subImageHeight" : @(o2.subImageHeight),
      //        @"subAnchor" : nmap::createAnchorPropDictionary(o2.subAnchor),
      //        @"circleRadius" : @(o2.circleRadius),
      //        @"circleOutlineWidth" : @(o2.circleOutlineWidth),
      //        @"circleOutlineColor" : @(o2.circleOutlineColor),
      //      };
    }
  }

  if (prev.clusters.key != next.clusters.key) {
    for (const auto& [prevKey, _] : _clustererRecord) {
      [self removeClustererFor:prevKey];
    }
    _clustererRecord.clear();
    _clustererMarkerIdentifiers.clear();
    _clusterMarkerImageRequestCancelers.clear();

    for (const auto& clusterer : next.clusters.clusters) {
      [self addClusterer:clusterer isLeafTapCallbackExist:next.clusters.isLeafTapCallbackExist];
    }
  }

  [super updateProps:props oldProps:oldProps];
  _isRecycled = NO;
}
- (void)addClusterer:(const RNCNaverMapViewClustersClustersStruct)dict
    isLeafTapCallbackExist:(BOOL)isLeafTapCallbackExist {

  std::string clustererKey = dict.key;
  //  double screenDistance = clamp([dict[@"screenDistance"] doubleValue], 1, 69);
  double minZoom = clamp(dict.minZoom, 1, 20);
  double maxZoom = clamp(dict.maxZoom, 1, 20);
  bool animate = dict.animate;

  auto& markers = dict.markers;

  NSMutableDictionary<RNCNaverMapClusterKey*, NSNull*>* markerDict = [NSMutableDictionary new];

  std::vector<std::string> markerIdentifiers;

  for (const auto& marker : markers) {
    markerIdentifiers.push_back(marker.identifier);

    OnTapLeafMarker _Nullable onTapLeafMarker;
    std::string identifier = marker.identifier;
    if (isLeafTapCallbackExist) {
      __weak __typeof__(self) ws = self;
      onTapLeafMarker = ^{
        __strong __typeof__(self) ss = ws;
        if (ss && [ss emitter]) {
          [ss emitter]->onTapClusterLeaf({.markerIdentifier = identifier});
        }
      };
    }

    RNCNaverMapClusterKey* markerKey = [RNCNaverMapClusterKey
        markerKeyWithIdentifier:getNsStr(marker.identifier)
                       position:NMGLatLngMake(marker.latitude, marker.longitude)
                          image:marker.image
                          width:marker.width
                         height:marker.height
                onTapLeafMarker:onTapLeafMarker];
    markerDict[markerKey] = [NSNull null];
  }

  _clustererMarkerIdentifiers[clustererKey] = markerIdentifiers;

  NMCBuilder* builder = [[NMCBuilder alloc] init];
  // todo screenDistance not works. idk why
  //  builder.screenDistance = screenDistance;
  builder.minZoom = minZoom;
  builder.maxZoom = maxZoom;
  builder.animate = animate;

  //  RNCNaverMapClusterMarkerUpdater* clusterMarkerUpdater =
  //      [[RNCNaverMapClusterMarkerUpdater alloc] init];
  RNCNaverMapLeafMarkerUpdater* leafMarkerUpdater =
      [[RNCNaverMapLeafMarkerUpdater alloc] init:&_clusterMarkerImageRequestCancelers];
  //  builder.clusterMarkerUpdater = clusterMarkerUpdater;
  builder.leafMarkerUpdater = leafMarkerUpdater;

  NMCClusterer* clusterer = [builder build];
  leafMarkerUpdater.clusterer = clusterer;
  [clusterer addAll:markerDict];

  _clustererRecord[clustererKey] = clusterer;
  clusterer.mapView = self.map;
}

- (void)removeClustererFor:(std::string)key {
  NMCClusterer* clusterer = _clustererRecord[key];
  clusterer.mapView = nil;

  for (const auto& markerIdentifier : _clustererMarkerIdentifiers[key]) {
    if (_clusterMarkerImageRequestCancelers.find(markerIdentifier) !=
        _clusterMarkerImageRequestCancelers.end()) {
      _clusterMarkerImageRequestCancelers[markerIdentifier]();
    }
  }
}

- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
                   zoom:(double)zoom {
  NMFCameraUpdate* update =
      isValidNumber(zoom)
          ? [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)
                                               zoomTo:zoom]
          : [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)];

  update.animation = getEasingAnimation(easing);
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  update.pivot = CGPointMake(pivotX, pivotY);

  [self.map moveCamera:update];
}

- (void)animateCameraBy:(double)x
                      y:(double)y
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY {
  NMFCameraUpdate* update = [NMFCameraUpdate cameraUpdateWithScrollBy:CGPointMake(x, y)];

  update.animation = getEasingAnimation(easing);
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  update.pivot = CGPointMake(pivotX, pivotY);

  [self.map moveCamera:update];
}

- (void)animateRegionTo:(double)latitude
              longitude:(double)longitude
          latitudeDelta:(double)latitudeDelta
         longitudeDelta:(double)longitudeDelta
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY {
  NMFCameraUpdate* update = [NMFCameraUpdate
      cameraUpdateWithFitBounds:nmap::createLatLngBounds(latitude, longitude, latitudeDelta,
                                                         longitudeDelta)];

  update.animation = getEasingAnimation(easing);
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  update.pivot = CGPointMake(pivotX, pivotY);

  [self.map moveCamera:update];
}

- (void)cancelAnimation {
  [self.map cancelTransitions];
}

- (void)setLocationTrackingMode:(NSString*)mode {
  if ([mode isEqualToString:@"NoFollow"]) {
    self.map.positionMode = NMFMyPositionNormal;
  } else if ([mode isEqualToString:@"Follow"]) {
    self.map.positionMode = NMFMyPositionDirection;
  } else if ([mode isEqualToString:@"Face"]) {
    self.map.positionMode = NMFMyPositionCompass;
  } else {
    self.map.positionMode = NMFMyPositionDisabled;
  }
}

- (void)screenToCoordinate:(double)x y:(double)y {
  if (!self.emitter)
    return;
  NMFProjection* projection = self.map.projection;
  NMGLatLng* coord = [projection latlngFromPoint:CGPointMake(x, y)];

  [self emitter]->onScreenToCoordinate({
      .isValid = coord.isValid,
      .latitude = coord.isValid ? coord.lat : 0,
      .longitude = coord.isValid ? coord.lng : 0,
  });
}

- (void)coordinateToScreen:(double)latitude longitude:(double)longitude {
  if (!self.emitter)
    return;
  NMFProjection* projection = self.map.projection;
  CGPoint point = [projection pointFromLatLng:NMGLatLngMake(latitude, longitude)];
  bool isValid = !isinf(point.x) && !isinf(point.y);

  [self emitter]->onCoordinateToScreen({
      .isValid = isValid,
      .screenX = isValid ? point.x : 0,
      .screenY = isValid ? point.y : 0,
  });
}

@end

// MARK: Commands
@implementation RNCNaverMapView (Commands)

@end

// MARK: ReactNative
@implementation RNCNaverMapView (ReactNative)
Class<RCTComponentViewProtocol> RNCNaverMapViewCls(void) {
  return RNCNaverMapView.class;
}
+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapViewComponentDescriptor>();
}
- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}
@end
