//
//  RNCNaverMapGround.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/1/24.
//

#import "RNCNaverMapGround.h"
#import <React/RCTBridge+Private.h>
#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapGround () <RCTRNCNaverMapGroundViewProtocol>

@end
#endif

@implementation RNCNaverMapGround {
  void (^_imageCanceller)(void);
}
static NSMutableDictionary* _overlayImageHolder;

- (RCTBridge*)bridge {
#ifdef RCT_NEW_ARCH_ENABLED
  return [RCTBridge currentBridge];
#else
  return _bridge;
#endif
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFGroundOverlay new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapGroundEventEmitter const>(_eventEmitter);
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

- (void)setRegion:(RNCNaverMapRegion*)region {
  _region = region;
  _inner.bounds = [region convertToNMGLatLngBounds];
}

- (void)setImage:(NSDictionary*)image {
  _image = image;
  _inner.alpha = 0;
  // Cancel pending request
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }

  _imageCanceller = [Utils getImage:[self bridge]
                               json:image
                           callback:^(NMFOverlayImage* image) {
                             dispatch_async(dispatch_get_main_queue(), [self, image]() {
                               self.inner.alpha = 1;
                               self.inner.overlayImage = image;
                             });
                           }];
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapGroundComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapGroundProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapGroundProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapGroundProps const>(props);

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(globalZIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);

  {
    auto r1 = prev.region, r2 = next.region;
    if (r1.latitude != r2.latitude || r1.longitude != r2.longitude ||
        r1.latitudeDelta != r2.latitudeDelta || r1.longitudeDelta != r2.longitudeDelta) {
      self.region =
          RNCNaverMapRegionMake(r2.latitude, r2.longitude, r2.latitudeDelta, r2.longitudeDelta);
    }
  }

  NMAP_REMAP_IMAGE_PROP(image, self.image)

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapGroundCls(void) {
  return RNCNaverMapGround.class;
}

#endif

@end
