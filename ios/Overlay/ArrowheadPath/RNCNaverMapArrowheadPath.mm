//
//  RNCNaverMapArrowheadPath.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "RNCNaverMapArrowheadPath.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapArrowheadPath () <RCTRNCNaverMapArrowheadPathViewProtocol>

@end

#endif

@implementation RNCNaverMapArrowheadPath {
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFArrowheadPath new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter =
          std::static_pointer_cast<RNCNaverMapArrowheadPathEventEmitter const>(_eventEmitter);
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

- (void)setColor:(NSInteger)color {
  _color = color;
  _inner.color = [Utils intToColor:color];
}
- (void)setOutlineColor:(NSInteger)outlineColor {
  _outlineColor = outlineColor;
  _inner.outlineColor = [Utils intToColor:outlineColor];
}
- (void)setOutlineWidth:(double)outlineWidth {
  _outlineWidth = outlineWidth;
  _inner.outlineWidth = outlineWidth;
}

- (void)setCoords:(NSArray*)coords {
  _coords = coords;
  auto arr = [NSMutableArray arrayWithCapacity:coords.count];

  for (NSDictionary* coord in coords) {
    [arr addObject:NMGLatLngMake([coord[@"latitude"] doubleValue],
                                 [coord[@"longitude"] doubleValue])];
  }

  self.inner.points = arr;
}

- (void)setHeadSizeRatio:(double)headSizeRatio {
  _headSizeRatio = headSizeRatio;
  _inner.headSizeRatio = headSizeRatio;
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapArrowheadPathComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapArrowheadPathProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapArrowheadPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapArrowheadPathProps const>(props);

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(globalZIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);

  NMAP_REMAP_SELF_PROP(width);
  NMAP_REMAP_SELF_PROP(outlineWidth);
  NMAP_REMAP_SELF_PROP(color);
  NMAP_REMAP_SELF_PROP(outlineColor);
  NMAP_REMAP_SELF_PROP(headSizeRatio);

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

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapArrowheadPathCls(void) {
  return RNCNaverMapArrowheadPath.class;
}

#endif

@end
