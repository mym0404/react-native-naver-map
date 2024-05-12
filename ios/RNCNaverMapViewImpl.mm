//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import "RNCNaverMapViewImpl.h"
#import "RNCNaverMapView.h"

@implementation RNCNaverMapViewImpl {
  BOOL _initialRegionSet;
  BOOL _initialCameraSet;
  BOOL _isFirstCameraAnimationRun;

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

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

// MARK: - INIT & SETUP

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _reactSubviews = [NSMutableArray new];

    [self.mapView addCameraDelegate:self];
    [self.mapView setTouchDelegate:self];
    [self.mapView addOptionDelegate:self];

    // run after _eventEmitter available(new arch), direct event block set(old arch)
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
      if (!self.rncParent.emitter)
        return;
      self.rncParent.emitter->onInitialized({});
    });
  }

  return self;
}

- (void)dealloc {
  [_reactSubviews removeAllObjects];
}

- (void)prepareForRecycle {
  [super prepareForRecycle];
  _initialRegionSet = NO;
  _initialCameraSet = NO;
  _isFirstCameraAnimationRun = NO;
}

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
  } else if ([subview isKindOfClass:[RNCNaverMapArrowheadPath class]]) {
    auto marker = static_cast<RNCNaverMapArrowheadPath*>(subview).inner;
    marker.mapView = self.mapView;
  } else if ([subview isKindOfClass:[RNCNaverMapGround class]]) {
    auto marker = static_cast<RNCNaverMapGround*>(subview).inner;
    if (!marker.overlayImage) {
      marker.overlayImage = NMF_MARKER_IMAGE_GREEN;
    }
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
  } else if ([subview isKindOfClass:[RNCNaverMapArrowheadPath class]]) {
    auto marker = static_cast<RNCNaverMapArrowheadPath*>(subview).inner;
    marker.mapView = nil;
    marker.touchHandler = nil;
  } else if ([subview isKindOfClass:[RNCNaverMapGround class]]) {
    auto marker = static_cast<RNCNaverMapGround*>(subview).inner;
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

- (void)setCamera:(NSDictionary*)camera {
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

- (void)setRegion:(NMGLatLngBounds*)region {
  _region = region;

  NMFCameraUpdate* update = [NMFCameraUpdate cameraUpdateWithFitBounds:region];

  if (_animationDuration > 0 && _isFirstCameraAnimationRun) {
    update.animationDuration = (NSTimeInterval)((double)_animationDuration) / 1000;
    update.animation = getEasingAnimation(_animationEasing);
  }

  [self.mapView moveCamera:update];
  _isFirstCameraAnimationRun = YES;
}

- (void)setInitialRegion:(NMGLatLngBounds*)initialRegion {
  if (!_initialRegionSet) {
    _initialRegionSet = YES;

    if (isValidNumber(initialRegion.southWestLat)) {
      [self setRegion:initialRegion];
    }
  }
}

- (void)setFpsLimit:(NSInteger)fpsLimit {
  // noop
}

- (void)setLocationOverlay:(NSDictionary*)locationOverlay {
  auto o = self.mapView.locationOverlay;
  if (!o)
    return;

  o.hidden = ![locationOverlay[@"isVisible"] boolValue];
  if (locationOverlay[@"position"]) {
    o.location = nmap::createLatLngFromDictionary(locationOverlay[@"position"]);
  }
}

// MARK: - EVENT

- (void)mapViewOptionChanged:(NMFMapView*)mapView {
  if (!_rncParent.emitter)
    return;
  _rncParent.emitter->onOptionChanged({});
}

- (void)mapView:(NMFMapView*)mapView cameraIsChangingByReason:(NSInteger)reason {
  if (!_rncParent.emitter)
    return;
  NMFCameraPosition* pos = mapView.cameraPosition;

  _rncParent.emitter->onCameraChanged({.latitude = pos.target.lat,
                                       .longitude = pos.target.lng,
                                       .zoom = pos.zoom,
                                       .tilt = pos.tilt,
                                       .bearing = pos.heading,
                                       .reason = reason == NMFMapChangedByDeveloper  ? 0
                                                 : reason == NMFMapChangedByGesture  ? 1
                                                 : reason == NMFMapChangedByControl  ? 2
                                                 : reason == NMFMapChangedByLocation ? 3
                                                                                     : 0});
}

- (void)mapView:(NMFMapView*)mapView didTapMap:(NMGLatLng*)latlng point:(CGPoint)point {
  if (!_rncParent.emitter)
    return;
  _rncParent.emitter->onTapMap({
      .latitude = latlng.lat,
      .longitude = latlng.lng,
      .x = point.x,
      .y = point.y,
  });
}

@end
