//
//  RNCNaverMapGround.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "RNCNaverMapGround.h"
#import <React/RCTBridge+Private.h>
using namespace facebook::react;
@interface RNCNaverMapGround () <RCTRNCNaverMapGroundViewProtocol>

@end

@implementation RNCNaverMapGround {
  RNCNaverMapImageCanceller _imageCanceller;
}
static NSMutableDictionary* _overlayImageHolder;

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapGroundEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapGroundEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFGroundOverlay new];
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
    static const auto defaultProps = std::make_shared<const RNCNaverMapGroundProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)dealloc {
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapGroundProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapGroundProps const>(props);

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

  if (!nmap::isRegionEqual(prev.region, next.region))
    _inner.bounds = nmap::createLatLngBounds(next.region);

  if (!nmap::isImageEqual(prev.image, next.image)) {
    _inner.alpha = 0;
    if (_imageCanceller) {
      _imageCanceller();
      _imageCanceller = nil;
    }

    _imageCanceller = nmap::getImage([self bridge], next.image, ^(NMFOverlayImage* image) {
      dispatch_async(dispatch_get_main_queue(), [self, image]() {
        self.inner.alpha = 1;
        self.inner.overlayImage = image;
        self->_imageCanceller = nil;
      });
    });
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapGroundCls(void) {
  return RNCNaverMapGround.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapGroundComponentDescriptor>();
}

@end
