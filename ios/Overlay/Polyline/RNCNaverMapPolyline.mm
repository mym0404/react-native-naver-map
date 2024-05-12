//
//  RNCNaverMapPolyline.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPolyline.h"

using namespace facebook::react;
@interface RNCNaverMapPolyline () <RCTRNCNaverMapPolylineViewProtocol>

@end

@implementation RNCNaverMapPolyline

- (std::shared_ptr<RNCNaverMapPolylineEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapPolylineEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPolylineOverlay new];

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
    static const auto defaultProps = std::make_shared<const RNCNaverMapPolylineProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPolylineProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPolylineProps const>(props);

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
  if (prev.color != next.color)
    _inner.color = nmap::intToColor(next.color);

  // capType
  if (prev.capType != next.capType) {
    if (next.capType == RNCNaverMapPolylineCapType::Butt)
      _inner.capType = NMFOverlayLineCapButt;
    if (next.capType == RNCNaverMapPolylineCapType::Square)
      _inner.capType = NMFOverlayLineCapSquare;
    if (next.capType == RNCNaverMapPolylineCapType::Round)
      _inner.capType = NMFOverlayLineCapRound;
  }

  // joinType
  if (prev.joinType != next.joinType) {
    if (next.joinType == RNCNaverMapPolylineJoinType::Bevel)
      _inner.joinType = NMFOverlayLineJoinBevel;
    if (next.joinType == RNCNaverMapPolylineJoinType::Miter)
      _inner.joinType = NMFOverlayLineJoinMiter;
    if (next.joinType == RNCNaverMapPolylineJoinType::Round)
      _inner.joinType = NMFOverlayLineJoinRound;
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

      for (const auto& coord : next.coords) {
        [arr addObject:nmap::createLatLng(coord)];
      }

      self.inner.line = [NMGLineString lineStringWithPoints:arr];
    }
  }

  // pattern
  if (prev.pattern != next.pattern) {
    auto arr = [NSMutableArray arrayWithCapacity:next.pattern.size()];
    for (int p : next.pattern)
      [arr addObject:@(p)];
    _inner.pattern = arr;
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapPolylineCls(void) {
  return RNCNaverMapPolyline.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPolylineComponentDescriptor>();
}
@end
