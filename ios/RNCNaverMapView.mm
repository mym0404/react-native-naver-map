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
  
  // New Architecture View Recycling으로 인한 상태 초기화
  // 모든 Boolean 설정들을 기본값으로 리셋
  [self.map setIndoorMapEnabled:NO];
  [self.map setNightModeEnabled:NO];
  [self.map setLiteModeEnabled:NO];
  [_view setShowCompass:NO];
  [_view setShowIndoorLevelPicker:NO];
  [_view setShowLocationButton:NO];
  [_view setShowScaleBar:NO];
  [_view setShowZoomControls:NO];
  [self.map setScrollGestureEnabled:YES];
  [self.map setZoomGestureEnabled:YES];
  [self.map setTiltGestureEnabled:YES];
  [self.map setRotateGestureEnabled:YES];
  [self.map setStopGestureEnabled:YES];
  
  // 기타 설정들도 기본값으로 리셋
  [self.map setMapType:NMFMapTypeBasic];
  [self.map setLightness:0.0];
  [self.map setBuildingHeight:1.0];
  [self.map setSymbolScale:1.0];
  [self.map setSymbolPerspectiveRatio:1.0];
  [self.map setLogoAlign:NMFLogoAlignLeftBottom];
  [self.map setMinZoomLevel:0.0];
  [self.map setMaxZoomLevel:21.0];
  [self.map setLocale:nil];
  [self.map setContentInset:UIEdgeInsetsZero];
  [self.map setLogoMargin:UIEdgeInsetsZero];
  [self.map setExtent:nil];
  
  // 레이어 그룹들도 기본값으로 리셋
  [self.map setLayerGroup:NMF_LAYER_GROUP_BUILDING isEnabled:YES];
  [self.map setLayerGroup:NMF_LAYER_GROUP_TRAFFIC isEnabled:NO];
  [self.map setLayerGroup:NMF_LAYER_GROUP_TRANSIT isEnabled:NO];
  [self.map setLayerGroup:NMF_LAYER_GROUP_BICYCLE isEnabled:NO];
  [self.map setLayerGroup:NMF_LAYER_GROUP_MOUNTAIN isEnabled:NO];
  [self.map setLayerGroup:NMF_LAYER_GROUP_CADASTRAL isEnabled:NO];
  
  // 클러스터링 정리
  for (const auto& [prevKey, _] : _clustererRecord) {
    [self removeClustererFor:prevKey];
  }
  _clustererRecord.clear();
  _clustererMarkerIdentifiers.clear();
  _clusterMarkerImageRequestCancelers.clear();
  
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

  // 재활용된 뷰이거나 값이 변경된 경우에만 설정 (기존 로직 유지하되 더 깔끔하게)
  if (_isRecycled || prev.isIndoorEnabled != next.isIndoorEnabled) {
    [self.map setIndoorMapEnabled:next.isIndoorEnabled];
  }
  
  if (_isRecycled || prev.isNightModeEnabled != next.isNightModeEnabled) {
    [self.map setNightModeEnabled:next.isNightModeEnabled];
  }
  
  if (_isRecycled || prev.isLiteModeEnabled != next.isLiteModeEnabled) {
    [self.map setLiteModeEnabled:next.isLiteModeEnabled];
  }
  
  if (prev.lightness != next.lightness)
    [self.map setLightness:next.lightness];
  if (prev.buildingHeight != next.buildingHeight)
    [self.map setBuildingHeight:next.buildingHeight];
  if (prev.symbolScale != next.symbolScale)
    [self.map setSymbolScale:next.symbolScale];
  if (prev.symbolPerspectiveRatio != next.symbolPerspectiveRatio)
    [self.map setSymbolPerspectiveRatio:next.symbolPerspectiveRatio];
    
  if (_isRecycled || prev.isShowCompass != next.isShowCompass) {
    [_view setShowCompass:next.isShowCompass];
  }
  
  if (_isRecycled || prev.isShowIndoorLevelPicker != next.isShowIndoorLevelPicker) {
    [_view setShowIndoorLevelPicker:next.isShowIndoorLevelPicker];
  }
  
  if (_isRecycled || prev.isShowLocationButton != next.isShowLocationButton) {
    [_view setShowLocationButton:next.isShowLocationButton];
  }
  
  if (_isRecycled || prev.isShowScaleBar != next.isShowScaleBar) {
    [_view setShowScaleBar:next.isShowScaleBar];
  }
  
  if (_isRecycled || prev.isShowZoomControls != next.isShowZoomControls) {
    [_view setShowZoomControls:next.isShowZoomControls];
  }

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

  if (_isRecycled || prev.isScrollGesturesEnabled != next.isScrollGesturesEnabled) {
    [self.map setScrollGestureEnabled:next.isScrollGesturesEnabled];
  }
  
  if (_isRecycled || prev.isZoomGesturesEnabled != next.isZoomGesturesEnabled) {
    [self.map setZoomGestureEnabled:next.isZoomGesturesEnabled];
  }
  
  if (_isRecycled || prev.isTiltGesturesEnabled != next.isTiltGesturesEnabled) {
    [self.map setTiltGestureEnabled:next.isTiltGesturesEnabled];
  }
  
  if (_isRecycled || prev.isRotateGesturesEnabled != next.isRotateGesturesEnabled) {
    [self.map setRotateGestureEnabled:next.isRotateGesturesEnabled];
  }
  
  if (_isRecycled || prev.isStopGesturesEnabled != next.isStopGesturesEnabled) {
    [self.map setStopGestureEnabled:next.isStopGesturesEnabled];
  }

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
  builder.minZoom = minZoom;
  builder.maxZoom = maxZoom;
  builder.animate = animate;

  RNCNaverMapClusterMarkerUpdater* clusterMarkerUpdater =
      [[RNCNaverMapClusterMarkerUpdater alloc] initWith:dict.width height:dict.height];
  RNCNaverMapLeafMarkerUpdater* leafMarkerUpdater =
      [[RNCNaverMapLeafMarkerUpdater alloc] init:&_clusterMarkerImageRequestCancelers];
  builder.clusterMarkerUpdater = clusterMarkerUpdater;
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
