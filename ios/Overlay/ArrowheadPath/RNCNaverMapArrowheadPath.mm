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

- (std::shared_ptr<RNCNaverMapArrowheadPathEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapArrowheadPathEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFArrowheadPath new];

    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
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
    static const auto defaultProps = std::make_shared<const RNCNaverMapArrowheadPathProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapArrowheadPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapArrowheadPathProps const>(props);

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

  if (prev.width != next.width)
    _inner.width = next.width;
  if (prev.outlineWidth != next.outlineWidth)
    _inner.outlineWidth = next.outlineWidth;
  if (prev.color != next.color)
    _inner.color = nmap::intToColor(next.color);
  if (prev.outlineColor != next.outlineColor)
    _inner.outlineColor = nmap::intToColor(next.outlineColor);
  if (prev.headSizeRatio != next.headSizeRatio)
    _inner.headSizeRatio = next.headSizeRatio;

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
      for (const auto& coord : next.coords) {
        [arr addObject:nmap::createLatLng(coord)];
      }
      self.inner.points = arr;
    }
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapArrowheadPathCls(void) {
  return RNCNaverMapArrowheadPath.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapArrowheadPathComponentDescriptor>();
}

@end
