//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import "RNCNaverMapViewImpl.h"

#ifdef RCT_NEW_ARCH_ENABLED
@interface RCTBridge (Private)
+ (RCTBridge*)currentBridge;
@end
#endif

NMFCameraUpdateAnimation getEasingAnimation(int easing) {
  if (easing == 1) {
    return NMFCameraUpdateAnimationNone;
  }

  if (easing == 2) {
    return NMFCameraUpdateAnimationLinear;
  }

  if (easing == 3) {
    return NMFCameraUpdateAnimationFly;
  }

  if (easing == 4) {
    return NMFCameraUpdateAnimationEaseOut;
  }

  return NMFCameraUpdateAnimationEaseIn;
}

@implementation RNCNaverMapViewImpl {
  BOOL _initialRegionSet;
  BOOL _initialCameraSet;
  BOOL _isFirstCameraAnimationRun;

  NSMutableDictionary<NSString*, NMCClusterer*>* _clustererRecord;
  NSMutableDictionary<NSString*, NSMutableArray*>* _clustererMarkerIdentifiers;
  NSMutableDictionary<NSString*, void (^)(void)>* _clusterMarkerImageRequestCancelers;
  NSString* _lastClustersPropKey;

  // Array to manually track RN subviews
  //
  // AIRMap implicitly creates subviews that aren't regular RN children
  // (SMCalloutView injects an overlay subview), which otherwise confuses RN
  // during component re-renders:
  // https://github.com/facebook/react-native/blob/v0.16.0/React/Modules/RCTUIManager.m#L657
  //
  // Implementation based on RCTTextField, another component with indirect children
  // https://github.com/facebook/react-native/blob/v0.16.0/Libraries/Text/RCTTextField.m#L20
  NSMutableArray<UIView*>* _reactSubviews;
}

/**
 https://github.com/software-mansion/react-native-screens/blob/a8bb418a8428befbb264ef958a5d7f7ea743048a/ios/RNSScreenStackHeaderSubview.mm#L100
 */
- (RCTBridge*)bridge {
#ifdef RCT_NEW_ARCH_ENABLED
  return [RCTBridge currentBridge];
#else
  return _bridge;
#endif
}

// MARK: - INIT & SETUP

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _reactSubviews = [NSMutableArray new];
    _clustererRecord = [NSMutableDictionary new];
    _clustererMarkerIdentifiers = [NSMutableDictionary new];
    _clusterMarkerImageRequestCancelers = [NSMutableDictionary new];

    [self.mapView addCameraDelegate:self];
    [self.mapView setTouchDelegate:self];
    [self.mapView addOptionDelegate:self];

    // run after _eventEmitter available(new arch), direct event block set(old arch)
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
      if (self.onInitialized) {
        self.onInitialized(@{});
      }
    });
  }

  return self;
}

- (void)dealloc {
  NSArray* allKeys = [_clustererRecord allKeys];
  for (id clustererKey in allKeys) {
    _clustererRecord[clustererKey].mapView = nil;
    for (id markerIdentifier in _clustererMarkerIdentifiers[clustererKey]) {
      if (_clusterMarkerImageRequestCancelers[markerIdentifier]) {
        _clusterMarkerImageRequestCancelers[markerIdentifier]();
        [_clusterMarkerImageRequestCancelers removeObjectForKey:markerIdentifier];
      }
    }
  }
  [_clustererMarkerIdentifiers removeAllObjects];
  [_clustererRecord removeAllObjects];
  [_reactSubviews removeAllObjects];
}

//- (NSArray<id<RCTComponent> > *)reactSubviews {
//    return std::dynamic_pointer_cast<NSArray<id<RCTComponent>> *>(_reactSubviews);
//}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)insertReactSubview:(id<RCTComponent>)subview atIndex:(NSInteger)atIndex {
  // Our desired API is to pass up markers/overlays as children to the mapview component.
  // This is where we intercept them and do the appropriate underlying mapview action.
  if ([subview isKindOfClass:[RNCNaverMapMarker class]]) {
    auto marker = static_cast<RNCNaverMapMarker*>(subview).inner;
    marker.mapView = self.mapView;
  } else if ([subview isKindOfClass:[RNCNaverMapCircle class]]) {
    auto marker = static_cast<RNCNaverMapCircle*>(subview).inner;
    marker.mapView = self.mapView;
  } else if ([subview isKindOfClass:[RNCNaverMapPolygon class]]) {
    auto marker = static_cast<RNCNaverMapPolygon*>(subview).inner;
    marker.mapView = self.mapView;
  } else if ([subview isKindOfClass:[RNCNaverMapPolyline class]]) {
    auto marker = static_cast<RNCNaverMapPolyline*>(subview).inner;
    marker.mapView = self.mapView;
  } else if ([subview isKindOfClass:[RNCNaverMapPath class]]) {
    auto marker = static_cast<RNCNaverMapPath*>(subview).inner;
    marker.mapView = self.mapView;
  } else {
    NSArray<id<RCTComponent>>* childSubviews = [subview reactSubviews];
    for (int i = 0; i < childSubviews.count; i++) {
      [self insertReactSubview:(UIView*)childSubviews[i] atIndex:atIndex];
    }
  }
  [_reactSubviews insertObject:(UIView*)subview atIndex:(NSUInteger)atIndex];
}

- (void)removeReactSubview:(UIView*)subview {
  // similarly, when the children are being removed we have to do the appropriate
  // underlying mapview action here.
  if ([subview isKindOfClass:[RNCNaverMapMarker class]]) {
    auto marker = static_cast<RNCNaverMapMarker*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else if ([subview isKindOfClass:[RNCNaverMapCircle class]]) {
    auto marker = static_cast<RNCNaverMapCircle*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else if ([subview isKindOfClass:[RNCNaverMapPolygon class]]) {
    auto marker = static_cast<RNCNaverMapPolygon*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else if ([subview isKindOfClass:[RNCNaverMapPolyline class]]) {
    auto marker = static_cast<RNCNaverMapPolyline*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else if ([subview isKindOfClass:[RNCNaverMapPath class]]) {
    auto marker = static_cast<RNCNaverMapPath*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else {
    NSArray<id<RCTComponent>>* childSubviews = [subview reactSubviews];
    for (int i = 0; i < childSubviews.count; i++) {
      [self removeReactSubview:(UIView*)childSubviews[i]];
    }
  }
  [_reactSubviews removeObject:(UIView*)subview];
}

- (NSArray<UIView*>*)reactSubviews {
  return _reactSubviews;
}

#pragma clang diagnostic pop

// MARK: - SETTER

NMAP_MAP_SETTER(M, m, apType, NMFMapType)
NMAP_SETTER(I, i, sIndoorEnabled, mapView.indoorMapEnabled, BOOL)
NMAP_SETTER(I, i, sNightModeEnabled, mapView.nightModeEnabled, BOOL)
NMAP_SETTER(I, i, sLiteModeEnabled, mapView.liteModeEnabled, BOOL)
NMAP_MAP_SETTER(L, l, ightness, double)
NMAP_MAP_SETTER(B, b, uildingHeight, double)
NMAP_MAP_SETTER(S, s, ymbolScale, double)
NMAP_MAP_SETTER(S, s, ymbolPerspectiveRatio, double)
NMAP_SETTER(I, i, sShowCompass, showCompass, BOOL)
NMAP_SETTER(I, i, sShowScaleBar, showScaleBar, BOOL)
NMAP_SETTER(I, i, sShowZoomControls, showZoomControls, BOOL)
NMAP_SETTER(I, i, sShowIndoorLevelPicker, showIndoorLevelPicker, BOOL)
NMAP_SETTER(I, i, sShowLocationButton, showLocationButton, BOOL)
NMAP_MAP_SETTER(L, l, ogoAlign, NMFLogoAlign)
NMAP_SETTER(M, m, inZoom, mapView.minZoomLevel, double)
NMAP_SETTER(M, m, axZoom, mapView.maxZoomLevel, double)
NMAP_SETTER(I, i, sScrollGesturesEnabled, mapView.scrollGestureEnabled, BOOL)
NMAP_SETTER(I, i, sZoomGesturesEnabled, mapView.zoomGestureEnabled, BOOL)
NMAP_SETTER(I, i, sTiltGesturesEnabled, mapView.tiltGestureEnabled, BOOL)
NMAP_SETTER(I, i, sRotateGesturesEnabled, mapView.rotateGestureEnabled, BOOL)
NMAP_SETTER(I, i, sStopGesturesEnabled, mapView.stopGestureEnabled, BOOL)
NMAP_MAP_SETTER(L, l, ocale, NSString*)

- (void)setLayerGroups:(NSInteger)layerGroups {
  BOOL building = layerGroups & (1 << 0);
  BOOL traffic = layerGroups & (1 << 1);
  BOOL transit = layerGroups & (1 << 2);
  BOOL bicycle = layerGroups & (1 << 3);
  BOOL mountain = layerGroups & (1 << 4);
  BOOL cadastral = layerGroups & (1 << 5);

  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_BUILDING] != building) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_BUILDING isEnabled:building];
  }
  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_TRAFFIC] != traffic) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_TRAFFIC isEnabled:traffic];
  }
  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_TRANSIT] != transit) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_TRANSIT isEnabled:transit];
  }
  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_BICYCLE] != bicycle) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_BICYCLE isEnabled:bicycle];
  }
  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_MOUNTAIN] != mountain) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_MOUNTAIN isEnabled:mountain];
  }
  if ([self.mapView getLayerGroupEnabled:NMF_LAYER_GROUP_CADASTRAL] != cadastral) {
    [self.mapView setLayerGroup:NMF_LAYER_GROUP_CADASTRAL isEnabled:cadastral];
  }
}

- (void)setCamera:(NSDictionary*)camera {
  _camera = camera;

  NMFCameraPosition* prev = self.mapView.cameraPosition;
  double latitude = getDoubleOrDefault(camera[@"latitude"], prev.target.lat);
  double longitude = getDoubleOrDefault(camera[@"longitude"], prev.target.lng);
  double zoom = getDoubleOrDefault(camera[@"zoom"], prev.zoom);
  double tilt = getDoubleOrDefault(camera[@"tilt"], prev.tilt);
  double heading = getDoubleOrDefault(camera[@"bearing"], prev.heading);

  NMGLatLng* p = NMGLatLngMake(latitude, longitude);
  NMFCameraPosition* cameraPosition = [NMFCameraPosition cameraPosition:p
                                                                   zoom:zoom
                                                                   tilt:tilt
                                                                heading:heading];
  NMFCameraUpdate* update = [NMFCameraUpdate cameraUpdateWithPosition:cameraPosition];

  if (_animationDuration > 0 && _isFirstCameraAnimationRun) {
    update.animationDuration = (NSTimeInterval)((double)_animationDuration) / 1000;
    update.animation = getEasingAnimation(_animationEasing);
  }

  [self.mapView moveCamera:update];
  _isFirstCameraAnimationRun = YES;
}

- (void)setInitialCamera:(NSDictionary*)initialCamera {
  if (!_initialCameraSet) {
    _initialCameraSet = YES;

    if (isValidNumber(initialCamera[@"latitude"])) {
      [self setCamera:initialCamera];
    }
  }
}

- (void)setRegion:(RNCNaverMapRegion*)region {
  _region = region;

  NMFCameraUpdate* update =
      [NMFCameraUpdate cameraUpdateWithFitBounds:[region convertToNMGLatLngBounds]];

  if (_animationDuration > 0 && _isFirstCameraAnimationRun) {
    update.animationDuration = (NSTimeInterval)((double)_animationDuration) / 1000;
    update.animation = getEasingAnimation(_animationEasing);
  }

  [self.mapView moveCamera:update];
  _isFirstCameraAnimationRun = YES;
}

- (void)setInitialRegion:(RNCNaverMapRegion*)initialRegion {
  if (!_initialRegionSet) {
    _initialRegionSet = YES;

    if (isValidNumber(initialRegion.latitude)) {
      [self setRegion:initialRegion];
    }
  }
}

- (void)setMapPadding:(RNCNaverMapRect*)mapPadding {
  self.mapView.contentInset = [mapPadding convertToUIEdgeInsets];
}

- (void)setLogoMargin:(RNCNaverMapRect*)logoMargin {
  self.mapView.logoMargin = [logoMargin convertToUIEdgeInsets];
}

- (void)setExtent:(RNCNaverMapRegion*)extent {
  _extent = extent;
  self.mapView.extent = [extent convertToNMGLatLngBounds];
}

- (void)setClusters:(NSDictionary*)clusters {
  NSString* propKey = clusters[@"key"];

  if ([_lastClustersPropKey isEqualToString:propKey]) {
    return;
  }
  _lastClustersPropKey = propKey;

  NSArray<NSDictionary*>* value = clusters[@"clusters"];

  // removeClustererFor mutates _clusterRecord. So get all keys first.
  for (id prevKey in [_clustererRecord allKeys]) {
    [self removeClustererFor:prevKey];
  }
  for (NSDictionary* clusterer in value) {
    [self addClusterer:clusterer];
  }
}

- (void)addClusterer:(nonnull NSDictionary*)dict {

  NSString* clustererKey = dict[@"key"];
  //  double screenDistance = clamp([dict[@"screenDistance"] doubleValue], 1, 69);
  double minZoom = clamp([dict[@"minZoom"] doubleValue], 1, 20);
  double maxZoom = clamp([dict[@"maxZoom"] doubleValue], 1, 20);
  BOOL animate = [dict[@"animate"] boolValue];
  NSDictionary* markers = dict[@"markers"];

  NSMutableDictionary<RNCNaverMapClusterKey*, NSNull*>* markerDict = [NSMutableDictionary new];

  NSMutableArray* markerIdentifiers = [NSMutableArray new];
  _clustererMarkerIdentifiers[clustererKey] = markerIdentifiers;

  for (NSDictionary* marker : markers) {
    NSString* identifier = marker[@"identifier"];
    double latitude = [marker[@"latitude"] doubleValue];
    double longitude = [marker[@"longitude"] doubleValue];
    double width = [marker[@"width"] doubleValue];
    double height = [marker[@"height"] doubleValue];
    NSDictionary* image = marker[@"image"];
    RNCNaverMapClusterKey* markerKey =
        [RNCNaverMapClusterKey markerKeyWithIdentifier:identifier
                                              position:NMGLatLngMake(latitude, longitude)
                                                bridge:[self bridge]
                                                 image:image
                                                 width:width
                                                height:height];
    markerDict[markerKey] = [NSNull null];

    [markerIdentifiers addObject:identifier];
  }

  NMCBuilder* builder = [[NMCBuilder alloc] init];
  // todo screenDistance not works. idk why
  //  builder.screenDistance = screenDistance;
  builder.minZoom = minZoom;
  builder.maxZoom = maxZoom;
  builder.animate = animate;

  //  RNCNaverMapClusterMarkerUpdater* clusterMarkerUpdater =
  //      [[RNCNaverMapClusterMarkerUpdater alloc] init];
  RNCNaverMapLeafMarkerUpdater* leafMarkerUpdater =
      [[RNCNaverMapLeafMarkerUpdater alloc] init:_clusterMarkerImageRequestCancelers];
  //  builder.clusterMarkerUpdater = clusterMarkerUpdater;
  builder.leafMarkerUpdater = leafMarkerUpdater;

  NMCClusterer* clusterer = [builder build];
  leafMarkerUpdater.clusterer = clusterer;
  [clusterer addAll:markerDict];

  _clustererRecord[clustererKey] = clusterer;
  clusterer.mapView = self.mapView;
}

- (void)removeClustererFor:(nonnull NSString*)key {
  NMCClusterer* clusterer = _clustererRecord[key];
  clusterer.mapView = nil;

  for (id markerIdentifier in _clustererMarkerIdentifiers[key]) {
    if (_clusterMarkerImageRequestCancelers[markerIdentifier]) {
      _clusterMarkerImageRequestCancelers[markerIdentifier]();
      [_clusterMarkerImageRequestCancelers removeObjectForKey:markerIdentifier];
    }
  }

  [_clustererMarkerIdentifiers removeObjectForKey:key];
  [_clustererRecord removeObjectForKey:key];
}

// MARK: - EVENT

- (void)mapViewOptionChanged:(NMFMapView*)mapView {
  if (self.onOptionChanged) {
    self.onOptionChanged(@{});
  }
}

- (void)mapView:(NMFMapView*)mapView cameraIsChangingByReason:(NSInteger)reason {
  NMFCameraPosition* pos = mapView.cameraPosition;
  if (!self.onCameraChanged)
    return;
  self.onCameraChanged(@{
    @"latitude" : @(pos.target.lat),
    @"longitude" : @(pos.target.lng),
    @"zoom" : @(pos.zoom),
    @"tilt" : @(pos.tilt),
    @"bearing" : @(pos.heading),
    @"reason" : @(reason == NMFMapChangedByDeveloper  ? 0
                  : reason == NMFMapChangedByGesture  ? 1
                  : reason == NMFMapChangedByControl  ? 2
                  : reason == NMFMapChangedByLocation ? 3
                                                      : 0),
  });
}

- (void)mapView:(NMFMapView*)mapView didTapMap:(NMGLatLng*)latlng point:(CGPoint)point {
  if (self.onTapMap) {
    self.onTapMap(@{
      @"latitude" : @(latlng.lat),
      @"longitude" : @(latlng.lng),
      @"x" : @(point.x),
      @"y" : @(point.y),
    });
  }
}

// MARK: - COMMAND

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
  [self.mapView moveCamera:update];
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
  [self.mapView moveCamera:update];
}

- (void)animateRegionTo:(double)latitude
              longitude:(double)longitude
          latitudeDelta:(double)latitudeDelta
         longitudeDelta:(double)longitudeDelta
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY {
  RNCNaverMapRegion* region =
      RNCNaverMapRegionMake(latitude, longitude, latitudeDelta, longitudeDelta);
  NMFCameraUpdate* update =
      [NMFCameraUpdate cameraUpdateWithFitBounds:[region convertToNMGLatLngBounds]];

  update.animation = getEasingAnimation(easing);
  update.animationDuration = (NSTimeInterval)((double)duration) / 1000;
  update.pivot = CGPointMake(pivotX, pivotY);

  [self.mapView moveCamera:update];
}

- (void)cancelAnimation {
  [self.mapView cancelTransitions];
}

- (void)setLocationTrackingMode:(NSString*)mode {
  if ([mode isEqualToString:@"NoFollow"]) {
    self.mapView.positionMode = NMFMyPositionNormal;
  } else if ([mode isEqualToString:@"Follow"]) {
    self.mapView.positionMode = NMFMyPositionDirection;
  } else if ([mode isEqualToString:@"Face"]) {
    self.mapView.positionMode = NMFMyPositionCompass;
  } else {
    self.mapView.positionMode = NMFMyPositionDisabled;
  }
}

@end
