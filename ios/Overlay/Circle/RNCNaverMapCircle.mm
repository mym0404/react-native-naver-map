//
//  RNCNaverMapCircle.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapCircle.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapCircle () <RCTRNCNaverMapCircleViewProtocol>

@end
#endif

@implementation RNCNaverMapCircle {
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFCircleOverlay new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapCircleEventEmitter const>(_eventEmitter);
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

NMAP_SETTER(C, c, oord, inner.center, NMGLatLng*)
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
NMAP_INNER_SETTER(R, r, adius, double)
NMAP_INNER_SETTER(O, o, utlineWidth, double)
- (void)setColor:(NSInteger)color {
  _color = color;
  _inner.fillColor = [Utils intToColor:color];
}
- (void)setOutlineColor:(NSInteger)outlineColor {
  _outlineColor = outlineColor;
  _inner.outlineColor = [Utils intToColor:outlineColor];
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapCircleComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapCircleProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapCircleProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapCircleProps const>(props);

  if (prev.coord.latitude != next.coord.latitude || prev.coord.longitude != next.coord.longitude) {
    self.coord = NMGLatLngMake(next.coord.latitude, next.coord.longitude);
  }

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(globalZIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);
  NMAP_REMAP_SELF_PROP(radius);
  NMAP_REMAP_SELF_PROP(outlineWidth);
  NMAP_REMAP_SELF_PROP(color);
  NMAP_REMAP_SELF_PROP(outlineColor);

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapCircleCls(void) {
  return RNCNaverMapCircle.class;
}

#endif

@end
