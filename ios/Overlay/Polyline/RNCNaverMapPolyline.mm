//
//  RNCNaverMapPolyline.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPolyline.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapPolyline () <RCTRNCNaverMapPolylineViewProtocol>

@end

#endif

@implementation RNCNaverMapPolyline {
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPolylineOverlay new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapPolylineEventEmitter const>(_eventEmitter);
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

NMAP_SETTER(Z, z, IndexValue, inner.zIndex, NSInteger)
- (void)setGlobalZIndexValue:(NSInteger)globalZIndexValue {
  _globalZIndexValue = globalZIndexValue;
  if (isValidNumber(globalZIndexValue))
    self.inner.globalZIndex = globalZIndexValue;
}
NMAP_SETTER(I, i, sHidden, inner.hidden, BOOL)
NMAP_INNER_SETTER(M, m, inZoom, double)
NMAP_INNER_SETTER(M, m, axZoom, double)
NMAP_INNER_SETTER(I, i, sMinZoomInclusive, BOOL)
NMAP_INNER_SETTER(I, i, sMaxZoomInclusive, BOOL)

NMAP_INNER_SETTER(W, w, idth, double)
NMAP_INNER_SETTER(C, c, apType, NMFOverlayLineCap)
NMAP_INNER_SETTER(J, j, oinType, NMFOverlayLineJoin)

- (void)setColor:(NSInteger)color {
  _color = color;
  _inner.color = [Utils intToColor:color];
}

- (void)setCoords:(NSArray*)coords {
  _coords = coords;
  auto arr = [NSMutableArray arrayWithCapacity:coords.count];

  for (NSDictionary* coord in coords) {
    [arr addObject:NMGLatLngMake([coord[@"latitude"] doubleValue],
                                 [coord[@"longitude"] doubleValue])];
  }

  self.inner.line = [NMGLineString lineStringWithPoints:arr];
}

- (void)setPattern:(NSArray*)pattern {
  _pattern = pattern;
  self.inner.pattern = pattern;
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPolylineComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapPolylineProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPolylineProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPolylineProps const>(props);

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(globalZIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);

  NMAP_REMAP_SELF_PROP(width);
  NMAP_REMAP_SELF_PROP(color);

  // capType
  {
    if (prev.capType != next.capType) {
      if (next.capType == RNCNaverMapPolylineCapType::Butt) {
        self.capType = NMFOverlayLineCapButt;
      }
      if (next.capType == RNCNaverMapPolylineCapType::Square) {
        self.capType = NMFOverlayLineCapSquare;
      }
      if (next.capType == RNCNaverMapPolylineCapType::Round) {
        self.capType = NMFOverlayLineCapRound;
      }
    }
  }

  // joinType
  {
    if (prev.joinType != next.joinType) {
      if (next.joinType == RNCNaverMapPolylineJoinType::Bevel) {
        self.joinType = NMFOverlayLineJoinBevel;
      }
      if (next.joinType == RNCNaverMapPolylineJoinType::Miter) {
        self.joinType = NMFOverlayLineJoinMiter;
      }
      if (next.joinType == RNCNaverMapPolylineJoinType::Round) {
        self.joinType = NMFOverlayLineJoinRound;
      }
    }
  }

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

  // pattern
  if (prev.pattern != next.pattern) {
    auto arr = [NSMutableArray arrayWithCapacity:next.pattern.size()];
    for (int p : next.pattern)
      [arr addObject:@(p)];
    self.pattern = arr;
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapPolylineCls(void) {
  return RNCNaverMapPolyline.class;
}

#endif

@end
