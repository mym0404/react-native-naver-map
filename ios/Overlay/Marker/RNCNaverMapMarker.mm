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
  void (^_imageCanceller)(void);
  BOOL _isImageSetFromSubview;
}

- (RCTBridge*)bridge {
#ifdef RCT_NEW_ARCH_ENABLED
  return [RCTBridge currentBridge];
#else
  return _bridge;
#endif
}

//+ (void)initialize {
//  _overlayImageHolder = [[NSMutableDictionary alloc] init];
//}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMarker new];
    _isImageSetFromSubview = NO;

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapMarkerEventEmitter const>(_eventEmitter);
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
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

NMAP_SETTER(C, c, oord, inner.position, NMGLatLng*)
NMAP_SETTER(Z, z, IndexValue, inner.zIndex, NSInteger)
NMAP_SETTER(I, i, sHidden, inner.hidden, BOOL)
NMAP_INNER_SETTER(M, m, inZoom, double)
NMAP_INNER_SETTER(M, m, axZoom, double)
NMAP_INNER_SETTER(I, i, sMinZoomInclusive, BOOL)
NMAP_INNER_SETTER(I, i, sMaxZoomInclusive, BOOL)

NMAP_INNER_SETTER(A, a, nchor, CGPoint)
NMAP_INNER_SETTER(A, a, ngle, double)
NMAP_SETTER(I, i, sFlatEnabled, inner.flat, BOOL)
NMAP_SETTER(I, i, sIconPerspectiveEnabled, inner.iconPerspectiveEnabled, BOOL)
NMAP_INNER_SETTER(A, a, lpha, double)
NMAP_INNER_SETTER(I, i, sHideCollidedSymbols, BOOL)
NMAP_INNER_SETTER(I, i, sHideCollidedMarkers, BOOL)
NMAP_INNER_SETTER(I, i, sHideCollidedCaptions, BOOL)
NMAP_INNER_SETTER(I, i, sForceShowIcon, BOOL)
- (void)setTintColor:(NSInteger)tintColor {
  _tintColor = tintColor;
  _inner.iconTintColor = [Utils intToColor:tintColor];
}

- (void)setWidth:(double)width {
  _width = width;
  _inner.width = getDoubleOrDefault(width, NMF_MARKER_SIZE_AUTO);
}

- (void)setHeight:(double)height {
  _height = height;
  _inner.height = getDoubleOrDefault(height, NMF_MARKER_SIZE_AUTO);
}

- (void)setImage:(NSDictionary*)image {
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

  _imageCanceller = [Utils getImage:[self bridge]
                               json:image
                           callback:^(NMFOverlayImage* image) {
                             dispatch_async(dispatch_get_main_queue(), [self, image]() {
                               self.inner.alpha = 1;
                               self.inner.iconImage = image;
                             });
                           }];
}

- (void)setCaption:(NSDictionary*)value {
  if ([_caption[@"key"] isEqualToString:value[@"key"]]) {
    return;
  }
  _caption = value;

  _inner.captionText = value[@"text"];
  _inner.captionRequestedWidth = [value[@"requestedWidth"] floatValue];
  _inner.captionAligns = @[ [RCTConvert NMFAlignType:value[@"align"]] ];
  _inner.captionOffset = [value[@"offset"] floatValue];
  _inner.captionColor = [Utils intToColor:[value[@"color"] intValue]];
  _inner.captionHaloColor = [Utils intToColor:[value[@"haloColor"] intValue]];
  _inner.captionTextSize = [value[@"textSize"] floatValue];
  _inner.captionMinZoom = [value[@"minZoom"] doubleValue];
  _inner.captionMaxZoom = [value[@"maxZoom"] doubleValue];
}
- (void)setSubCaption:(NSDictionary*)value {
  if ([_subCaption[@"key"] isEqualToString:value[@"key"]]) {
    return;
  }
  _subCaption = value;

  _inner.subCaptionText = value[@"text"];
  _inner.subCaptionRequestedWidth = [value[@"requestedWidth"] floatValue];
  _inner.subCaptionColor = [Utils intToColor:[value[@"color"] intValue]];
  _inner.subCaptionHaloColor = [Utils intToColor:[value[@"haloColor"] intValue]];
  _inner.subCaptionTextSize = [value[@"textSize"] floatValue];
  _inner.subCaptionMinZoom = [value[@"minZoom"] doubleValue];
  _inner.subCaptionMaxZoom = [value[@"maxZoom"] doubleValue];
}

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapMarkerComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapMarkerProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                          index:(NSInteger)index {
  [self insertReactSubview:childComponentView atIndex:index];
}
- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                            index:(NSInteger)index {
  [self removeReactSubview:childComponentView];
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapMarkerProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapMarkerProps const>(props);

  if (prev.coord.latitude != next.coord.latitude || prev.coord.longitude != next.coord.longitude) {
    self.coord = NMGLatLngMake(next.coord.latitude, next.coord.longitude);
  }

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);

  NMAP_REMAP_SELF_PROP(width);
  NMAP_REMAP_SELF_PROP(height);

  if (prev.anchor.x != next.anchor.x || prev.anchor.y != next.anchor.y) {
    self.anchor = CGPointMake(next.anchor.x, next.anchor.y);
  }
  NMAP_REMAP_SELF_PROP(angle);
  NMAP_REMAP_SELF_PROP(isFlatEnabled);
  NMAP_REMAP_SELF_PROP(isIconPerspectiveEnabled);
  NMAP_REMAP_SELF_PROP(alpha);
  NMAP_REMAP_SELF_PROP(isHideCollidedSymbols);
  NMAP_REMAP_SELF_PROP(isHideCollidedMarkers);
  NMAP_REMAP_SELF_PROP(isHideCollidedCaptions);
  NMAP_REMAP_SELF_PROP(isForceShowIcon);
  NMAP_REMAP_SELF_PROP(tintColor);

  NMAP_REMAP_IMAGE_PROP(image, self.image)

  if (next.caption.key != prev.caption.key) {
    self.caption = @{
      @"key" : getNsStr(next.caption.key),
      @"text" : getNsStr(next.caption.text),
      @"requestedWidth" : @(next.caption.requestedWidth),
      @"align" : @(next.caption.align),
      @"offset" : @(next.caption.offset),
      @"color" : @(next.caption.color),
      @"haloColor" : @(next.caption.haloColor),
      @"textSize" : @(next.caption.textSize),
      @"minZoom" : @(next.caption.minZoom),
      @"maxZoom" : @(next.caption.maxZoom)
    };
  }

  if (next.subCaption.key != prev.subCaption.key) {
    self.subCaption = @{
      @"key" : getNsStr(next.subCaption.key),
      @"text" : getNsStr(next.subCaption.text),
      @"requestedWidth" : @(next.subCaption.requestedWidth),
      @"color" : @(next.subCaption.color),
      @"haloColor" : @(next.subCaption.haloColor),
      @"textSize" : @(next.subCaption.textSize),
      @"minZoom" : @(next.subCaption.minZoom),
      @"maxZoom" : @(next.subCaption.maxZoom)
    };
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapMarkerCls(void) {
  return RNCNaverMapMarker.class;
}

#endif

@end
