//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import "RNCNaverMapViewImpl.h"

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
      if (self.onInitialized) {
        self.onInitialized(@{});
      }
    });
  }

  return self;
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
  }
  //  else if ([subview isKindOfClass:[RNNaverMapPolylineOverlay class]]) {
  //    RNNaverMapPolylineOverlay* overlay = (RNNaverMapPolylineOverlay*)subview;
  //    overlay.realOverlay.mapView = self.mapView;
  //  } else if ([subview isKindOfClass:[RNNaverMapPathOverlay class]]) {
  //    RNNaverMapPathOverlay* overlay = (RNNaverMapPathOverlay*)subview;
  //    overlay.realOverlay.mapView = self.mapView;
  //  } else if ([subview isKindOfClass:[RNNaverMapCircleOverlay class]]) {
  //    RNNaverMapCircleOverlay* overlay = (RNNaverMapCircleOverlay*)subview;
  //    overlay.realOverlay.mapView = self.mapView;
  //  } else if ([subview isKindOfClass:[RNNaverMapPolygonOverlay class]]) {
  //    RNNaverMapPolygonOverlay* overlay = (RNNaverMapPolygonOverlay*)subview;
  //    overlay.realOverlay.mapView = self.mapView;
  //  }
  else {
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
  }
  //  else if ([subview isKindOfClass:[RNNaverMapPolylineOverlay class]]) {
  //    RNNaverMapPolylineOverlay* overlay = (RNNaverMapPolylineOverlay*)subview;
  //    overlay.realOverlay.mapView = nil;
  //  } else if ([subview isKindOfClass:[RNNaverMapPathOverlay class]]) {
  //    RNNaverMapPathOverlay* overlay = (RNNaverMapPathOverlay*)subview;
  //    overlay.realOverlay.mapView = nil;
  //  } else if ([subview isKindOfClass:[RNNaverMapCircleOverlay class]]) {
  //    RNNaverMapCircleOverlay* overlay = (RNNaverMapCircleOverlay*)subview;
  //    overlay.realOverlay.mapView = nil;
  //  } else if ([subview isKindOfClass:[RNNaverMapPolygonOverlay class]]) {
  //    RNNaverMapPolygonOverlay* overlay = (RNNaverMapPolygonOverlay*)subview;
  //    overlay.realOverlay.mapView = nil;
  //  }
  else {
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

NMAP_QUICK_SETTER(MapType, mapType, NMFMapType)
NMAP_REMAP_QUICK_SETTER(IsIndoorEnabled, isIndoorEnabled, mapView.indoorMapEnabled, BOOL)
NMAP_REMAP_QUICK_SETTER(IsNightModeEnabled, isNightModeEnabled, mapView.nightModeEnabled, BOOL)
NMAP_REMAP_QUICK_SETTER(IsLiteModeEnabled, isLiteModeEnabled, mapView.liteModeEnabled, BOOL)
NMAP_QUICK_SETTER(Lightness, lightness, double)
NMAP_QUICK_SETTER(BuildingHeight, buildingHeight, double)
NMAP_QUICK_SETTER(SymbolScale, symbolScale, double)
NMAP_QUICK_SETTER(SymbolPerspectiveRatio, symbolPerspectiveRatio, double)
NMAP_REMAP_QUICK_SETTER(IsShowCompass, isShowCompass, showCompass, BOOL)
NMAP_REMAP_QUICK_SETTER(IsShowScaleBar, isShowScaleBar, showScaleBar, BOOL)
NMAP_REMAP_QUICK_SETTER(IsShowZoomControls, isShowZoomControls, showZoomControls, BOOL)
NMAP_REMAP_QUICK_SETTER(IsShowIndoorLevelPicker, isShowIndoorLevelPicker, showIndoorLevelPicker,
                        BOOL)
NMAP_REMAP_QUICK_SETTER(IsShowLocationButton, isShowLocationButton, showLocationButton, BOOL)
NMAP_QUICK_SETTER(LogoAlign, logoAlign, NMFLogoAlign)
NMAP_REMAP_QUICK_SETTER(MinZoom, minZoom, mapView.minZoomLevel, double)
NMAP_REMAP_QUICK_SETTER(MaxZoom, maxZoom, mapView.maxZoomLevel, double)
NMAP_REMAP_QUICK_SETTER(IsScrollGesturesEnabled, isScrollGesturesEnabled,
                        mapView.scrollGestureEnabled, BOOL)
NMAP_REMAP_QUICK_SETTER(IsZoomGesturesEnabled, isZoomGesturesEnabled, mapView.zoomGestureEnabled,
                        BOOL)
NMAP_REMAP_QUICK_SETTER(IsTiltGesturesEnabled, isTiltGesturesEnabled, mapView.tiltGestureEnabled,
                        BOOL)
NMAP_REMAP_QUICK_SETTER(IsRotateGesturesEnabled, isRotateGesturesEnabled,
                        mapView.rotateGestureEnabled, BOOL)
NMAP_REMAP_QUICK_SETTER(IsStopGesturesEnabled, isStopGesturesEnabled, mapView.stopGestureEnabled,
                        BOOL)

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

  [self.mapView moveCamera:update];
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

  [self.mapView moveCamera:update];
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
                 pivotY:(double)pivotY {
  NMFCameraUpdate* update =
      [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake(latitude, longitude)];

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

@end
