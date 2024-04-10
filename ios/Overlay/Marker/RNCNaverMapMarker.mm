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
  _inner.iconImage = [NMFOverlayImage overlayImageWithImage:[self captureView:subview]];
}

- (void)removeReactSubview:(UIView*)subview {
  self.image = _image;
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
                if (error) {
                  NSLog(@"ERROR: %@", error);
                  return;
                }
                dispatch_async(dispatch_get_main_queue(), [self, image]() {
                  NMFOverlayImage* overlayImage = [NMFOverlayImage overlayImageWithImage:image];
                  self.inner.iconImage = overlayImage;
                  [_overlayImageHolder setObject:overlayImage forKey:self->_image];
                });
              }];
}

/*
- (void)setCaptionText:(NSString*)text {
  _inner.captionText = text;
}

- (void)setCaptionTextSize:(CGFloat)size {
  _inner.captionTextSize = size;
}

- (void)setCaptionColor:(UIColor*)color {
  _inner.captionColor = color == nil ? UIColor.blackColor : color;
}

- (void)setCaptionHaloColor:(UIColor*)haloColor {
  _inner.captionHaloColor = haloColor == nil ? UIColor.whiteColor : haloColor;
}

- (void)setCaptionAligns:(NSArray<NMFAlignType*>*)aligns {
  _inner.captionAligns = aligns;
}

- (void)setCaptionOffset:(CGFloat)offset {
  _inner.captionOffset = offset;
}

- (void)setCaptionRequestedWidth:(CGFloat)captionWidth {
  _inner.captionRequestedWidth = captionWidth;
}

- (void)setCaptionMinZoom:(double)minZoom {
  _inner.captionMinZoom = minZoom;
}

- (void)setCaptionMaxZoom:(double)maxZoom {
  _inner.captionMaxZoom = maxZoom;
}

- (void)setSubCaptionText:(NSString*)subText {
  _inner.subCaptionText = subText;
}

- (void)setSubCaptionTextSize:(CGFloat)subTextSize {
  _inner.subCaptionTextSize = subTextSize;
}

- (void)setSubCaptionColor:(UIColor*)subColor {
  _inner.subCaptionColor = subColor == nil ? UIColor.blackColor : subColor;
}

- (void)setSubCaptionHaloColor:(UIColor*)subHaloColor {
  _inner.subCaptionHaloColor = subHaloColor == nil ? UIColor.whiteColor : subHaloColor;
}

- (void)setSubCaptionRequestedWidth:(CGFloat)subCaptionWidth {
  _inner.subCaptionRequestedWidth = subCaptionWidth;
}

- (void)setSubCaptionMinZoom:(double)subMinZoom {
  _inner.subCaptionMinZoom = subMinZoom;
}

- (void)setSubCaptionMaxZoom:(double)subMaxZoom {
  _inner.subCaptionMaxZoom = subMaxZoom;
}
*/

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

  if (prev.image != next.image) {
    self.image = [NSString stringWithUTF8String:next.image.c_str()];
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapMarkerCls(void) {
  return RNCNaverMapMarker.class;
}

#endif

@end
