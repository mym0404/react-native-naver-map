//
//  RNCNaverMapMarker.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapMarker.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapMarker () <RCTRNCNaverMapMarkerViewProtocol>

@end
@interface RCTBridge (Private)
+ (RCTBridge*)currentBridge;
@end
#endif

@implementation RNCNaverMapMarker {
  RCTImageLoaderCancellationBlock _reloadImageCancellationBlock;
  BOOL _isImageSetFromSubview;
  ;
}
static NSMutableDictionary* _overlayImageHolder;

/**
 https://github.com/software-mansion/react-native-screens/blob/a8bb418a8428befbb264ef958a5d7f7ea743048a/ios/RNSScreenStackHeaderSubview.mm#L100
 */
- (RCTBridge*)bridge {
#ifdef RCT_NEW_ARCH_ENABLED
  return [RCTBridge currentBridge];
#else
  return _bridge;
#endif
}

// static NSMutableDictionary* _overlayImageHolder;

//+ (void)initialize {
//  _overlayImageHolder = [[NSMutableDictionary alloc] init];
//}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMarker new];
    _isImageSetFromSubview = NO;
    if (!_overlayImageHolder) {
      _overlayImageHolder = [NSMutableDictionary new];
    }

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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)insertReactSubview:(UIView*)subview atIndex:(NSInteger)atIndex {
  NSLog(@"insertReactSubview");
  _inner.iconImage = [NMFOverlayImage overlayImageWithImage:[self captureView:subview]];
  _isImageSetFromSubview = YES;
}

- (void)removeReactSubview:(UIView*)subview {
  NSLog(@"removeReactSubview");
  _isImageSetFromSubview = NO;

  if (_image) {
    // after custom marker is removed, set image from prop.
    self.image = _image;
  } else {
    // or set default marker
    self.image = @"default";
  }
}

- (UIImage*)captureView:(UIView*)view {
  NSLog(@"%f %f", view.bounds.size.width, view.bounds.size.height);
  // 시작 이미지 컨텍스트
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
  // 뷰 계층 렌더링
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  // 이미지 컨텍스트에서 UIImage를 얻습니다.
  UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

#pragma clang diagnostic pop

NMAP_INNER_SETTER(P, p, osition, NMGLatLng*)
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

- (void)setImage:(nonnull NSString*)image {
  _image = image;

  // If subview exists for custom marker, then skip image
  if (_isImageSetFromSubview) {
    return;
  }

  // Cancel pending request
  if (_reloadImageCancellationBlock) {
    _reloadImageCancellationBlock();
    _reloadImageCancellationBlock = nil;
  }

  BOOL isSet = false;
  if ([image isEqualToString:@"blue"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_BLUE;
    isSet = true;
  } else if ([image isEqualToString:@"gray"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_GRAY;
    isSet = true;
  } else if ([image isEqualToString:@"green"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_GREEN;
    isSet = true;
  } else if ([image isEqualToString:@"lightblue"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_LIGHTBLUE;
    isSet = true;
  } else if ([image isEqualToString:@"pink"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_PINK;
    isSet = true;
  } else if ([image isEqualToString:@"red"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_RED;
    isSet = true;
  } else if ([image isEqualToString:@"yellow"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_YELLOW;
    isSet = true;
  } else if ([image isEqualToString:@"black"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_BLACK;
    isSet = true;
  } else if ([image isEqualToString:@"lowDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY;
    isSet = true;
  } else if ([image isEqualToString:@"mediumDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY;
    isSet = true;
  } else if ([image isEqualToString:@"highDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_HIGH_DENSITY;
    isSet = true;
  } else if ([image isEqualToString:@"default"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_DEFAULT;
    isSet = true;
  }

  if (isSet) {
    return;
  }

  NMFOverlayImage* cache = [_overlayImageHolder valueForKey:image];
  if (cache != nil) {
    _inner.iconImage = cache;
    return;
  }

  RCTImageLoader* _Nonnull imageLoader = [self.bridge moduleForClass:[RCTImageLoader class]];
  _reloadImageCancellationBlock = [imageLoader
      loadImageWithURLRequest:[RCTConvert NSURLRequest:image]
                         size:self.bounds.size
                        scale:RCTScreenScale()
                      clipped:YES
                   resizeMode:RCTResizeModeCenter
                progressBlock:nil
             partialLoadBlock:nil
              completionBlock:[self](NSError* error, UIImage* image) {
                dispatch_async(dispatch_get_main_queue(), [self, error, image]() {
                  if (error) {
                    NSLog(@"ERROR: %@", error);
                    // on error, set default
                    _inner.iconImage = NMF_MARKER_IMAGE_DEFAULT;
                  } else {
                    NMFOverlayImage* overlayImage = [NMFOverlayImage overlayImageWithImage:image];
                    self.inner.iconImage = overlayImage;
                    [_overlayImageHolder setObject:overlayImage forKey:self->_image];
                  }
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

  if (prev.position.latitude != next.position.latitude ||
      prev.position.longitude != next.position.longitude) {
    self.position = NMGLatLngMake(next.position.latitude, next.position.longitude);
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
  NMAP_REMAP_SELF_STR_PROP(image);

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
