//
//  RNCNaverMapMarker.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapMarker.h"
#import <React/RCTBridge+Private.h>
#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapMarker () <RCTRNCNaverMapMarkerViewProtocol>

@end
#endif

@implementation RNCNaverMapMarker {
  RNCNaverMapImageCanceller _imageCanceller;
  BOOL _isImageSetFromSubview;
}

+ (bool)shouldBeRecycled {
  return NO;
}

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapMarkerEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapMarkerEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMarker new];
    _isImageSetFromSubview = NO;

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
    static const auto defaultProps = std::make_shared<const RNCNaverMapMarkerProps>();
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

/**
 * Ensures that the touch handler is properly set up for the marker
 * This method checks if the touch handler exists and creates it if it doesn't
 * The touch handler is responsible for processing tap events on the marker
 */
- (void)ensureTouchHandler {
  if (!_inner.touchHandler) {
    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      if (self.emitter) {
        self.emitter->onTapOverlay({});
        return YES;
      }
      return NO;
    };
  }
}

- (void)setImage:(facebook::react::RNCNaverMapMarkerImageStruct)image {
  _image = image;
  // If subview exists for custom marker, then skip image
  if (_isImageSetFromSubview) {
    return;
  }
  _inner.alpha = 0;

  // Cancel pending request
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }

  _imageCanceller = nmap::getImage([self bridge], image, ^(NMFOverlayImage* _Nullable image) {
    dispatch_async(dispatch_get_main_queue(), [self, image]() {
      self.inner.alpha = 1;
      self.inner.iconImage = image;
      self->_imageCanceller = nil;
      [self ensureTouchHandler]; // Re-ensure touch handler after image is set
    });
  });
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                          index:(NSInteger)index {
  [self insertReactSubview:childComponentView atIndex:index];
}
- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                            index:(NSInteger)index {
  [self removeReactSubview:childComponentView];
}

- (void)insertReactSubview:(UIView*)subview atIndex:(NSInteger)atIndex {
  if (_imageCanceller) {
    _imageCanceller();
    _imageCanceller = nil;
  }
  _isImageSetFromSubview = YES;
  _inner.alpha = 0;
  // prevent default image is set after this logic in old arch
  dispatch_async(dispatch_get_main_queue(), [self, subview]() {
    self.inner.alpha = 1;
    self.inner.iconImage = [NMFOverlayImage overlayImageWithImage:[self captureView:subview]];
    [self ensureTouchHandler]; // Re-ensure touch handler after custom marker image is set
  });
}

- (void)removeReactSubview:(UIView*)subview {
  _isImageSetFromSubview = NO;

  // after custom marker is removed, set image from prop.
  self.image = _image;
}

- (UIImage*)captureView:(UIView*)view {
  UIGraphicsImageRenderer* renderer =
      [[UIGraphicsImageRenderer alloc] initWithSize:view.bounds.size];
  auto ret =
      [renderer imageWithActions:^(UIGraphicsImageRendererContext* _Nonnull rendererContext) {
        [view.layer renderInContext:rendererContext.CGContext];
      }];
  return ret;
}

#pragma clang diagnostic pop

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapMarkerProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapMarkerProps const>(props);

  if (!nmap::isCoordEqual(prev.coord, next.coord))
    _inner.position = nmap::createLatLng(next.coord);

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

  if (prev.width != next.width && isValidNumber(next.width))
    _inner.width = next.width;
  if (prev.height != next.height && isValidNumber(next.height))
    _inner.height = next.height;

  if (!nmap::isAnchorEqual(prev.anchor, next.anchor))
    _inner.anchor = nmap::createAnchorCGPoint(next.anchor);

  if (prev.angle != next.angle)
    _inner.angle = next.angle;
  if (prev.isFlatEnabled != next.isFlatEnabled)
    [_inner setFlat:next.isFlatEnabled];
  if (prev.isIconPerspectiveEnabled != next.isIconPerspectiveEnabled)
    [_inner setIconPerspectiveEnabled:next.isIconPerspectiveEnabled];
  if (prev.alpha != next.alpha)
    [_inner setAlpha:next.alpha];
  if (prev.isHideCollidedSymbols != next.isHideCollidedSymbols)
    [_inner setIsHideCollidedSymbols:next.isHideCollidedSymbols];
  if (prev.isHideCollidedMarkers != next.isHideCollidedMarkers)
    [_inner setIsHideCollidedMarkers:next.isHideCollidedMarkers];
  if (prev.isHideCollidedCaptions != next.isHideCollidedCaptions)
    [_inner setIsHideCollidedCaptions:next.isHideCollidedCaptions];
  if (prev.isForceShowIcon != next.isForceShowIcon)
    [_inner setIsForceShowIcon:next.isForceShowIcon];
  if (prev.tintColor != next.tintColor)
    [_inner setIconTintColor:nmap::intToColor(next.tintColor)];

  if (!nmap::isImageEqual(prev.image, next.image))
    self.image = next.image;

  if (next.caption.key != prev.caption.key) {
    auto caption = next.caption;
    _inner.captionText = getNsStr(caption.text);
    _inner.captionRequestedWidth = caption.requestedWidth;
    _inner.captionAligns = @[ nmap::createAlign(caption.align) ];
    _inner.captionOffset = caption.offset;
    _inner.captionColor = nmap::intToColor(caption.color);
    _inner.captionHaloColor = nmap::intToColor(caption.haloColor);
    _inner.captionTextSize = caption.textSize;
    _inner.captionMinZoom = caption.minZoom;
    _inner.captionMaxZoom = caption.maxZoom;
  }

  if (next.subCaption.key != prev.subCaption.key) {
    auto caption = next.subCaption;
    _inner.subCaptionText = getNsStr(caption.text);
    _inner.subCaptionRequestedWidth = caption.requestedWidth;
    _inner.subCaptionColor = nmap::intToColor(caption.color);
    _inner.subCaptionHaloColor = nmap::intToColor(caption.haloColor);
    _inner.subCaptionTextSize = caption.textSize;
    _inner.subCaptionMinZoom = caption.minZoom;
    _inner.subCaptionMaxZoom = caption.maxZoom;
  }

  [super updateProps:props oldProps:oldProps];

  // Ensure touch handler is properly set after marker properties are updated
  [self ensureTouchHandler];
}

Class<RCTComponentViewProtocol> RNCNaverMapMarkerCls(void) {
  return RNCNaverMapMarker.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapMarkerComponentDescriptor>();
}

@end
