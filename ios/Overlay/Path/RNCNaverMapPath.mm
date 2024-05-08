//
//  RNCNaverMapPath.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPath.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapPath () <RCTRNCNaverMapPathViewProtocol>

@end

#endif

@implementation RNCNaverMapPath {
  void (^_imageCanceller)(void);
}

- (RCTBridge*)bridge {
#ifdef RCT_NEW_ARCH_ENABLED
  return [RCTBridge currentBridge];
#else
  return _bridge;
#endif
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPath new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapPathEventEmitter const>(_eventEmitter);
      emitter->onTapOverlay({});
    };
#endif

    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      // In New Arch, this always returns YES at now. should be fixed.
      if (self.onTapOverlay) {
        self.onTapOverlay(@{});
        return YES;
      }
      return NO;
    };
  }

  return self;
}

- (void)dealloc {
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }
}

NMAP_SETTER(Z, z, IndexValue, inner.zIndex, NSInteger)
NMAP_SETTER(I, i, sHidden, inner.hidden, BOOL)
NMAP_INNER_SETTER(M, m, inZoom, double)
NMAP_INNER_SETTER(M, m, axZoom, double)
NMAP_INNER_SETTER(I, i, sMinZoomInclusive, BOOL)
NMAP_INNER_SETTER(I, i, sMaxZoomInclusive, BOOL)

NMAP_INNER_SETTER(W, w, idth, double)

- (void)setPatternImage:(NSDictionary*)patternImage {
  _patternImage = patternImage;
  if (!patternImage) {
    _inner.patternIcon = nil;
    return;
  }

  // Cancel pending request
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }

  _imageCanceller = [Utils getImage:[self bridge]
                               json:patternImage
                           callback:^(NMFOverlayImage* image) {
                             dispatch_async(dispatch_get_main_queue(),
                                            [self, image]() { self.inner.patternIcon = image; });
                           }];
}
NMAP_INNER_SETTER(P, p, atternInterval, NSInteger)
NMAP_INNER_SETTER(P, p, rogress, double)

- (void)setColor:(NSInteger)color {
  _color = color;
  _inner.color = [Utils intToColor:color];
}
- (void)setPassedColor:(NSInteger)passedColor {
  _passedColor = passedColor;
  _inner.passedColor = [Utils intToColor:passedColor];
}
- (void)setOutlineColor:(NSInteger)outlineColor {
  _outlineColor = outlineColor;
  _inner.outlineColor = [Utils intToColor:outlineColor];
}
- (void)setPassedOutlineColor:(NSInteger)passedOutlineColor {
  _passedOutlineColor = passedOutlineColor;
  _inner.passedOutlineColor = [Utils intToColor:passedOutlineColor];
}
- (void)setOutlineWidth:(double)outlineWidth {
  _outlineWidth = outlineWidth;
  _inner.outlineWidth = outlineWidth;
}

NMAP_INNER_SETTER(I, i, sHideCollidedSymbols, BOOL)
NMAP_INNER_SETTER(I, i, sHideCollidedMarkers, BOOL)
NMAP_INNER_SETTER(I, i, sHideCollidedCaptions, BOOL)

- (void)setCoords:(NSArray*)coords {
  _coords = coords;
  auto arr = [NSMutableArray arrayWithCapacity:coords.count];

  for (NSDictionary* coord in coords) {
    [arr addObject:NMGLatLngMake([coord[@"latitude"] doubleValue],
                                 [coord[@"longitude"] doubleValue])];
  }

  self.inner.path = [NMGLineString lineStringWithPoints:arr];
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPathComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapPathProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPathProps const>(props);

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);

  NMAP_REMAP_SELF_PROP(width);
  NMAP_REMAP_SELF_PROP(outlineWidth);
  NMAP_REMAP_SELF_PROP(patternInterval);
  NMAP_REMAP_SELF_PROP(progress);
  NMAP_REMAP_SELF_PROP(color);
  NMAP_REMAP_SELF_PROP(passedColor);
  NMAP_REMAP_SELF_PROP(outlineColor);
  NMAP_REMAP_SELF_PROP(passedOutlineColor);
  NMAP_REMAP_SELF_PROP(isHideCollidedSymbols);
  NMAP_REMAP_SELF_PROP(isHideCollidedMarkers);
  NMAP_REMAP_SELF_PROP(isHideCollidedCaptions);

  // coords
  {
    bool isSame = true;
    if (prev.coords.size() != next.coords.size())
      isSame = false;
    for (int i = 0; i < prev.coords.size() && isSame; i++) {
      if (prev.coords[i].latitude != next.coords[i].latitude ||
          prev.coords[i].longitude != next.coords[i].longitude) {
        isSame = false;
      }
    }
    if (!isSame) {
      auto arr = [NSMutableArray arrayWithCapacity:next.coords.size()];
      for (const auto& [latitude, longitude] : next.coords) {
        [arr addObject:@{@"latitude" : @(latitude), @"longitude" : @(longitude)}];
      }
      self.coords = arr;
    }
  }

  NMAP_REMAP_IMAGE_PROP(patternImage, self.patternImage)
  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapPathCls(void) {
  return RNCNaverMapPath.class;
}

#endif

@end
