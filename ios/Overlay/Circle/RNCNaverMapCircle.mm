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

- (std::shared_ptr<RNCNaverMapCircleEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapCircleEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFCircleOverlay new];

    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      // In New Arch, this always returns YES at now. should be fixed.
      if (self.emitter) {
        self.emitter->onTapOverlay({});
        return YES;
      }
      return NO;
    };
  }

  return self;
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

  if (!nmap::isCoordEqual(prev.coord, next.coord))
    _inner.center = nmap::createLatLng(next.coord);

  if (prev.zIndexValue != next.zIndexValue)
    _inner.zIndex = next.zIndexValue;
  if (prev.globalZIndexValue != next.globalZIndexValue && isValidNumber(next.globalZIndexValue))
    _inner.globalZIndex = next.globalZIndexValue;
  if (prev.isHidden != next.isHidden)
    _inner.hidden = next.isHidden;
  if (prev.minZoom != next.minZoom)
    _inner.minZoom = next.minZoom;
  if (prev.maxZoom != next.maxZoom)
    _inner.maxZoom = next.maxZoom;
  if (prev.isMinZoomInclusive != next.isMinZoomInclusive)
    _inner.isMinZoomInclusive = next.isMinZoomInclusive;
  if (prev.isMaxZoomInclusive != next.isMaxZoomInclusive)
    _inner.isMaxZoomInclusive = next.isMaxZoomInclusive;

  if (prev.radius != next.radius)
    _inner.radius = next.radius;
  if (prev.outlineWidth != next.outlineWidth)
    _inner.outlineWidth = next.outlineWidth;
  if (prev.color != next.color)
    _inner.fillColor = nmap::intToColor(next.color);
  if (prev.outlineColor != next.outlineColor)
    _inner.outlineColor = nmap::intToColor(next.outlineColor);

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapCircleCls(void) {
  return RNCNaverMapCircle.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapCircleComponentDescriptor>();
}

@end
