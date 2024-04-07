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
#endif

@implementation RNCNaverMapMarker {
  RCTImageLoaderCancellationBlock _reloadImageCancellationBlock;
  __weak UIImageView* _iconImageView;
  UIView* _iconView;
}

// static NSMutableDictionary* _overlayImageHolder;

//+ (void)initialize {
//  _overlayImageHolder = [[NSMutableDictionary alloc] init];
//}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMarker new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTap = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapMarkerEventEmitter const>(_eventEmitter);
      emitter->onTap({});
    };
#endif

    NSLog(@"%@", self.onTap);
    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      // In New Arch, this always returns YES at now. should be fixed.
      if (self.onTap) {
        self.onTap(@{});
        return YES;
      }
      return NO;
    };
  }

  return self;
}

- (void)setPosition:(NMGLatLng*)position {
  _position = position;
  _inner.position = position;
}

- (void)setZIndexValue:(NSInteger)zIndexValue {
  _zIndexValue = zIndexValue;
  _inner.zIndex = zIndexValue;
}

- (void)setIsHidden:(BOOL)isHidden {
  _isHidden = isHidden;
  _inner.hidden = isHidden;
}

- (void)setMinZoom:(double)minZoom {
  _minZoom = minZoom;
  _inner.minZoom = minZoom;
}

- (void)setMaxZoom:(double)maxZoom {
  _maxZoom = maxZoom;
  _inner.maxZoom = maxZoom;
}

- (void)setIsMinZoomInclusive:(BOOL)isMinZoomInclusive {
  _isMinZoomInclusive = isMinZoomInclusive;
  _inner.isMinZoomInclusive = isMinZoomInclusive;
}

- (void)setIsMaxZoomInclusive:(BOOL)isMaxZoomInclusive {
  _isMaxZoomInclusive = isMaxZoomInclusive;
  _inner.isMaxZoomInclusive = isMaxZoomInclusive;
}

- (void)setWidth:(double)width {
  _width = width;
  if (isValidNumber(width)) {
    _inner.width = width;
  } else {
    _inner.width = NMF_MARKER_SIZE_AUTO;
  }
}

- (void)setHeight:(double)height {
  _height = height;
  if (isValidNumber(height)) {
    _inner.height = height;
  } else {
    _inner.height = NMF_MARKER_SIZE_AUTO;
  }
}

- (void)setAnchor:(CGPoint)anchor {
  _anchor = anchor;
  _inner.anchor = anchor;
}

- (void)setAngle:(CGFloat)angle {
  _angle = angle;
  _inner.angle = angle;
}

- (void)setIsFlatEnabled:(BOOL)isFlatEnabled {
  _isFlatEnabled = isFlatEnabled;
  _inner.flat = isFlatEnabled;
}

- (void)setIsIconPerspectiveEnabled:(BOOL)isIconPerspectiveEnabled {
  _isIconPerspectiveEnabled = isIconPerspectiveEnabled;
  _inner.iconPerspectiveEnabled = isIconPerspectiveEnabled;
}

- (void)setAlpha:(CGFloat)alpha {
  _alpha = alpha;
  _inner.alpha = alpha;
}

- (void)setisHideCollidedSymbols:(BOOL)isHideCollidedSymbols {
  _isHideCollidedSymbols = isHideCollidedSymbols;
  _inner.isHideCollidedSymbols = isHideCollidedSymbols;
}

- (void)setIsHideCollidedMarkers:(BOOL)isHideCollidedMarkers {
  _isHideCollidedMarkers = isHideCollidedMarkers;
  _inner.isHideCollidedMarkers = isHideCollidedMarkers;
}

- (void)setIsHideCollidedCaptions:(BOOL)isHideCollidedCaptions {
  _isHideCollidedCaptions = isHideCollidedCaptions;
  _inner.isHideCollidedCaptions = isHideCollidedCaptions;
}

- (void)isForceShowIcon:(BOOL)isForceShowIcon {
  _isForceShowIcon = isForceShowIcon;
  _inner.isForceShowIcon = isForceShowIcon;
}

- (void)setTintColor:(UIColor*)tintColor {
  // In new arch, the default value is WHITE. This should be fixed.
  _tintColor = tintColor;
  _inner.iconTintColor = tintColor;
}

- (void)setImage:(NSString*)image {
  _image = image;

  if ([image isEqualToString:@"blue"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_BLUE;
  } else if ([image isEqualToString:@"gray"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_GRAY;
  } else if ([image isEqualToString:@"green"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_GREEN;
  } else if ([image isEqualToString:@"lightblue"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_LIGHTBLUE;
  } else if ([image isEqualToString:@"pink"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_PINK;
  } else if ([image isEqualToString:@"red"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_RED;
  } else if ([image isEqualToString:@"yellow"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_YELLOW;
  } else if ([image isEqualToString:@"black"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_BLACK;
  } else if ([image isEqualToString:@"lowDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY;
  } else if ([image isEqualToString:@"mediumDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY;
  } else if ([image isEqualToString:@"highDensityCluster"]) {
    _inner.iconImage = NMF_MARKER_IMAGE_CLUSTER_HIGH_DENSITY;
  } else {
    _inner.iconImage = NMF_MARKER_IMAGE_DEFAULT;
  }
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

- (void)setImage:(NSString*)image {
  _image = image;

  if (_reloadImageCancellationBlock) {
    _reloadImageCancellationBlock();
    _reloadImageCancellationBlock = nil;
  }

  if (!_image) {
    if (_iconImageView) {
      [_iconImageView removeFromSuperview];
    }

    return;
  }

  NMFOverlayImage* overlayImage = [_overlayImageHolder valueForKey:image];

  if (overlayImage != nil) {
    if (self->_iconImageView) {
      [self->_iconImageView removeFromSuperview];
    }

    self->_inner.iconImage = overlayImage;
    return;
  }

  _reloadImageCancellationBlock = [[_bridge moduleForClass:[RCTImageLoader class]]
      loadImageWithURLRequest:[RCTConvert NSURLRequest:_image]
                         size:self.bounds.size
                        scale:RCTScreenScale()
                      clipped:YES
                   resizeMode:RCTResizeModeCenter
                progressBlock:nil
             partialLoadBlock:nil
              completionBlock:^(NSError* error, UIImage* image) {
                if (error) {
                  NSLog(@"%@", error);
                  return;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                  if (self->_iconImageView) {
                    [self->_iconImageView removeFromSuperview];
                  }

                  NMFOverlayImage* overlayImage = [NMFOverlayImage overlayImageWithImage:image];
                  self->_inner.iconImage = overlayImage;

                  [_overlayImageHolder setObject:overlayImage forKey:self->_image];
                });
              }];
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

  if (prev.tintColor != next.tintColor) {
    self.tintColor = [Utils intToColor:*next.tintColor];
  }

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
