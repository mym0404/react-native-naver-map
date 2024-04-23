#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapView.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTRNCNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
  RNCNaverMapViewImpl* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapViewComponentDescriptor>();
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

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapViewProps>();
    _props = defaultProps;

    _view = [[RNCNaverMapViewImpl alloc] init];

    _view.onInitialized = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
      emitter->onInitialized({});
    };

    _view.onOptionChanged = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
      emitter->onOptionChanged({});
    };

    _view.onCameraChanged = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
      emitter->onCameraChanged({.latitude = [dict[@"latitude"] doubleValue],
                                .longitude = [dict[@"longitude"] doubleValue],
                                .zoom = [dict[@"zoom"] doubleValue],
                                .tilt = [dict[@"tilt"] doubleValue],
                                .bearing = [dict[@"bearing"] doubleValue],
                                .reason = [dict[@"reason"] intValue]});
    };

    _view.onTapMap = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
      emitter->onTapMap({
          .latitude = [dict[@"latitude"] doubleValue],
          .longitude = [dict[@"longitude"] doubleValue],
          .x = [dict[@"x"] doubleValue],
          .y = [dict[@"y"] doubleValue],
      });
    };

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);

  if (prev.mapType != next.mapType) {
    if (next.mapType == RNCNaverMapViewMapType::Basic) {
      _view.mapType = NMFMapTypeBasic;
    } else if (next.mapType == RNCNaverMapViewMapType::Navi) {
      _view.mapType = NMFMapTypeNavi;
    } else if (next.mapType == RNCNaverMapViewMapType::Satellite) {
      _view.mapType = NMFMapTypeSatellite;
    } else if (next.mapType == RNCNaverMapViewMapType::Hybrid) {
      _view.mapType = NMFMapTypeHybrid;
    } else if (next.mapType == RNCNaverMapViewMapType::Terrain) {
      _view.mapType = NMFMapTypeTerrain;
    } else if (next.mapType == RNCNaverMapViewMapType::NaviHybrid) {
      _view.mapType = NMFMapTypeNaviHybrid;
    } else if (next.mapType == RNCNaverMapViewMapType::None) {
      _view.mapType = NMFMapTypeNone;
    }
  }

  NMAP_REMAP_PROP(layerGroups)
  NMAP_REMAP_PROP(isIndoorEnabled)
  NMAP_REMAP_PROP(isNightModeEnabled)
  NMAP_REMAP_PROP(isLiteModeEnabled)
  NMAP_REMAP_PROP(lightness)
  NMAP_REMAP_PROP(buildingHeight)
  NMAP_REMAP_PROP(symbolScale)
  NMAP_REMAP_PROP(symbolPerspectiveRatio)
  NMAP_REMAP_PROP(isShowCompass)
  NMAP_REMAP_PROP(isShowIndoorLevelPicker)
  NMAP_REMAP_PROP(isShowLocationButton)
  NMAP_REMAP_PROP(isShowScaleBar)
  NMAP_REMAP_PROP(isShowZoomControls)
  NMAP_REMAP_PROP(minZoom)
  NMAP_REMAP_PROP(maxZoom)
  NMAP_REMAP_RECT_PROP(mapPadding)
  NMAP_REMAP_RECT_PROP(logoMargin)
  NMAP_REMAP_PROP(isScrollGesturesEnabled)
  NMAP_REMAP_PROP(isZoomGesturesEnabled)
  NMAP_REMAP_PROP(isTiltGesturesEnabled)
  NMAP_REMAP_PROP(isRotateGesturesEnabled)
  NMAP_REMAP_PROP(isStopGesturesEnabled)
  NMAP_REMAP_PROP(animationDuration)
  NMAP_REMAP_PROP(animationEasing)
  NMAP_REMAP_STR_PROP(locale)

  auto c1 = prev.camera, c2 = next.camera;

  if (c1.latitude != c2.latitude || c1.longitude != c2.longitude || c1.tilt != c2.tilt ||
      c1.bearing != c2.bearing || c1.zoom != c2.zoom) {
    _view.camera = @{
      @"latitude" : @(c2.latitude),
      @"longitude" : @(c2.longitude),
      @"zoom" : @(c2.zoom),
      @"tilt" : @(c2.tilt),
      @"bearing" : @(c2.bearing),
    };
  }

  _view.initialCamera = @{
    @"latitude" : @(next.initialCamera.latitude),
    @"longitude" : @(next.initialCamera.longitude),
    @"zoom" : @(next.initialCamera.zoom),
    @"tilt" : @(next.initialCamera.tilt),
    @"bearing" : @(next.initialCamera.bearing)
  };

  auto r1 = prev.region, r2 = next.region;

  if (r1.latitude != r2.latitude || r1.longitude != r2.longitude ||
      r1.latitudeDelta != r2.latitudeDelta || r1.longitudeDelta != r2.longitudeDelta) {
    _view.region =
        RNCNaverMapRegionMake(r2.latitude, r2.longitude, r2.latitudeDelta, r2.longitudeDelta);
  }

  _view.initialRegion =
      RNCNaverMapRegionMake(next.initialRegion.latitude, next.initialRegion.longitude,
                            next.initialRegion.latitudeDelta, next.initialRegion.longitudeDelta);

  if (prev.logoAlign != next.logoAlign) {
    if (next.logoAlign == RNCNaverMapViewLogoAlign::TopLeft) {
      _view.logoAlign = NMFLogoAlignLeftTop;
    } else if (next.logoAlign == RNCNaverMapViewLogoAlign::TopRight) {
      _view.logoAlign = NMFLogoAlignRightTop;
    } else if (next.logoAlign == RNCNaverMapViewLogoAlign::BottomLeft) {
      _view.logoAlign = NMFLogoAlignLeftBottom;
    } else if (next.logoAlign == RNCNaverMapViewLogoAlign::BottomRight) {
      _view.logoAlign = NMFLogoAlignRightBottom;
    }
  }

  if (prev.clusters.key != next.clusters.key) {
    NSMutableArray* arr = [NSMutableArray new];
    for (const auto& c : next.clusters.clusters) {
      NSMutableArray* m = [NSMutableArray new];

      for (const auto& marker : c.markers) {
        [m addObject:@{
          @"identifier" : getNsStr(marker.identifier),
          @"latitude" : @(marker.latitude),
          @"longitude" : @(marker.longitude),
          @"width" : @(marker.width),
          @"height" : @(marker.height),
          @"image" : @{
            @"reuseIdentifier" : getNsStr(marker.image.reuseIdentifier),
            @"assetName" : getNsStr(marker.image.assetName),
            @"httpUri" : getNsStr(marker.image.httpUri),
            @"rnAssetUri" : getNsStr(marker.image.rnAssetUri),
            @"symbol" : getNsStr(marker.image.symbol),
          },
        }];
      }

      [arr addObject:@{
        @"key" : getNsStr(c.key),
        @"screenDistance" : @(c.screenDistance),
        @"minZoom" : @(c.minZoom),
        @"maxZoom" : @(c.maxZoom),
        @"animate" : @(c.animate),
        @"markers" : m,
      }];
    }
    _view.clusters = @{
      @"key" : getNsStr(next.clusters.key),
      @"clusters" : arr,
    };
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
                   zoom:(double)zoom {
  [_view animateCameraTo:latitude
               longitude:longitude
                duration:duration
                  easing:easing
                  pivotX:pivotX
                  pivotY:pivotY
                    zoom:zoom];
}

- (void)animateCameraBy:(double)x
                      y:(double)y
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY {
  [_view animateCameraBy:x y:y duration:duration easing:easing pivotX:pivotX pivotY:pivotY];
}

- (void)animateRegionTo:(double)latitude
              longitude:(double)longitude
          latitudeDelta:(double)latitudeDelta
         longitudeDelta:(double)longitudeDelta
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY {
  [_view animateRegionTo:latitude
               longitude:longitude
           latitudeDelta:latitudeDelta
          longitudeDelta:longitudeDelta
                duration:duration
                  easing:easing
                  pivotX:pivotX
                  pivotY:pivotY];
}

- (void)cancelAnimation {
  [_view cancelAnimation];
}

- (void)setLocationTrackingMode:(NSString*)mode {
  [_view setLocationTrackingMode:mode];
}

- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}

Class<RCTComponentViewProtocol> RNCNaverMapViewCls(void) {
  return RNCNaverMapView.class;
}

@end
#endif /* ifdef RCT_NEW_ARCH_ENABLED */
