//
//  RNCNaverMapPath.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPath.h"

using namespace facebook::react;
@interface RNCNaverMapPath () <RCTRNCNaverMapPathViewProtocol>

@end

@implementation RNCNaverMapPath {
  RNCNaverMapImageCanceller _imageCanceller;
}

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapPathEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapPathEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPath new];

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

- (void)dealloc {
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }
}

#ifdef RCT_NEW_ARCH_ENABLED

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
  if (!nmap::isImageEqual(prev.patternImage, next.patternImage)) {
    if (_imageCanceller) {
      _imageCanceller();
      _imageCanceller = nil;
    }

    _imageCanceller =
        nmap::getImage([self bridge], next.patternImage, ^(NMFOverlayImage* _Nullable image) {
          dispatch_async(dispatch_get_main_queue(),
                         [self, image]() { self.inner.patternIcon = image; });
        });
  }

  if (prev.progress != next.progress)
    _inner.progress = next.progress;
  if (prev.color != next.color)
    _inner.color = nmap::intToColor(next.color);
  if (prev.passedColor != next.passedColor)
    _inner.passedColor = nmap::intToColor(next.passedColor);
  if (prev.outlineColor != next.outlineColor)
    _inner.outlineColor = nmap::intToColor(next.outlineColor);
  if (prev.passedOutlineColor != next.passedOutlineColor)
    _inner.passedOutlineColor = nmap::intToColor(next.passedOutlineColor);
  if (prev.isHideCollidedSymbols != next.isHideCollidedSymbols)
    [_inner setIsHideCollidedSymbols:next.isHideCollidedSymbols];
  if (prev.isHideCollidedMarkers != next.isHideCollidedMarkers)
    [_inner setIsHideCollidedMarkers:next.isHideCollidedMarkers];
  if (prev.isHideCollidedCaptions != next.isHideCollidedCaptions)
    [_inner setIsHideCollidedCaptions:next.isHideCollidedCaptions];

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
      self.inner.path = [NMGLineString lineStringWithPoints:arr];
    }
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapPathCls(void) {
  return RNCNaverMapPath.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPathComponentDescriptor>();
}

#endif

@end
