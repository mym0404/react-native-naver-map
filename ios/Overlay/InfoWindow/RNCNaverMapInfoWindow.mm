//
//  RNCNaverMapInfoWindow.mm
//  mj-studio-react-native-naver-map
//
//  Created by AI Assistant
//

#import "RNCNaverMapInfoWindow.h"
#import "RNCNaverMapMarker.h"
#import "RNCNaverMapViewImpl.h"
#import <React/RCTBridge+Private.h>

using namespace facebook::react;

// Custom data source for InfoWindow with styling support
@interface RNCNaverMapInfoWindowDataSource : NSObject <NMFOverlayImageDataSource>
@property(nonatomic, strong) NSString* text;
@property(nonatomic, assign) CGFloat textSize;
@property(nonatomic, strong) UIColor* textColor;
@property(nonatomic, assign) NSInteger fontWeight;
@property(nonatomic, strong) UIColor* backgroundColor;
@property(nonatomic, assign) CGFloat borderRadius;
@property(nonatomic, assign) CGFloat borderWidth;
@property(nonatomic, strong) UIColor* borderColor;
@property(nonatomic, assign) CGFloat padding;
@end

@implementation RNCNaverMapInfoWindowDataSource

- (instancetype)init {
  if (self = [super init]) {
    _text = @"";
    _textSize = 14.0;
    _textColor = [UIColor blackColor];
    _fontWeight = 400;
    _backgroundColor = [UIColor whiteColor];
    _borderRadius = 5.0;
    _borderWidth = 1.0;
    _borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    _padding = 10.0;
  }
  return self;
}

- (UIView*)viewWithOverlay:(NMFOverlay*)overlay {
  // Return the styled view directly
  return [self createStyledView];
}

- (UIView*)createStyledView {
  // Create label with text
  UILabel* label = [[UILabel alloc] init];
  NSString* displayText = (_text && _text.length > 0) ? _text : @" ";
  label.text = displayText;
  label.font = [self createFont];
  label.textColor = _textColor;
  label.textAlignment = NSTextAlignmentCenter;
  label.numberOfLines = 0;

  // Calculate label size
  CGSize maxSize = CGSizeMake(300, CGFLOAT_MAX);
  CGSize labelSize = [displayText boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName : label.font}
                                               context:nil]
                         .size;

  // Ensure minimum size for empty or very small text
  CGFloat minWidth = 20.0;
  CGFloat minHeight = _textSize;
  labelSize.width = MAX(ceil(labelSize.width), minWidth);
  labelSize.height = MAX(ceil(labelSize.height), minHeight);

  // Add padding
  CGFloat totalPadding = _padding * 2;
  CGSize containerSize =
      CGSizeMake(labelSize.width + totalPadding, labelSize.height + totalPadding);

  // Create container view
  UIView* containerView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
  containerView.backgroundColor = _backgroundColor;
  containerView.layer.cornerRadius = _borderRadius;
  containerView.layer.borderWidth = _borderWidth;
  containerView.layer.borderColor = _borderColor.CGColor;
  containerView.clipsToBounds = YES;

  // Add label to container with padding
  label.frame = CGRectMake(_padding, _padding, labelSize.width, labelSize.height);
  [containerView addSubview:label];

  return containerView;
}

- (UIFont*)createFont {
  CGFloat fontSize = _textSize;

  if (_fontWeight >= 700) {
    return [UIFont boldSystemFontOfSize:fontSize];
  } else if (_fontWeight >= 600) {
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
  } else if (_fontWeight >= 500) {
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
  } else {
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
  }
}

@end

@interface RNCNaverMapInfoWindow () <RCTRNCNaverMapInfoWindowViewProtocol>

@end

@implementation RNCNaverMapInfoWindow {
  NSString* _markerIdentifier;
  BOOL _shouldBeOpen;
  NMFMapView* _currentMapView;
  RNCNaverMapViewImpl* _parentMapViewImpl;
  RNCNaverMapInfoWindowDataSource* _customDataSource;
}

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapInfoWindowEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapInfoWindowEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFInfoWindow new];
    _shouldBeOpen = YES; // Default isOpen = true

    // Create custom data source with styling support
    _customDataSource = [[RNCNaverMapInfoWindowDataSource alloc] init];
    _inner.dataSource = _customDataSource;
  }

  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapInfoWindowProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)setCurrentMapView:(NMFMapView*)mapView {
  _currentMapView = mapView;
  [self updateInfoWindowState];
}

- (void)setParentMapViewImpl:(RNCNaverMapViewImpl*)mapViewImpl {
  _parentMapViewImpl = mapViewImpl;
  [self updateInfoWindowState];
}

- (void)updateInfoWindowState {
  if (!_shouldBeOpen) {
    [_inner close];
    return;
  }

  if (!_currentMapView)
    return;

  // Try to find marker by identifier first
  if (_markerIdentifier && _markerIdentifier.length > 0 && _parentMapViewImpl) {
    RNCNaverMapMarker* markerView = _parentMapViewImpl.markerRegistry[_markerIdentifier];
    if (markerView) {
      // Open on marker (marker position is used automatically)
      [_inner openWithMarker:markerView.inner];
      return;
    }
  }

  // Fall back to position
  _inner.mapView = _currentMapView;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(props);

  if (!nmap::isCoordEqual(prev.coord, next.coord)) {
    _inner.position = nmap::createLatLng(next.coord);
    [self updateInfoWindowState];
  }

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

  if (!nmap::isAnchorEqual(prev.anchor, next.anchor))
    _inner.anchor = nmap::createAnchorCGPoint(next.anchor);

  if (prev.offsetX != next.offsetX)
    _inner.offsetX = next.offsetX;
  if (prev.offsetY != next.offsetY)
    _inner.offsetY = next.offsetY;

  if (prev.alpha != next.alpha)
    _inner.alpha = next.alpha;

  // Identifier handling
  if (prev.identifier != next.identifier) {
    _markerIdentifier = getNsStr(next.identifier);
    [self updateInfoWindowState];
  }

  // IsOpen handling
  if (prev.isOpen != next.isOpen) {
    _shouldBeOpen = next.isOpen;
    [self updateInfoWindowState];
  }

  // Text content and styling (now supported via custom data source!)
  BOOL needsRedraw = NO;

  if (prev.text != next.text) {
    _customDataSource.text = getNsStr(next.text);
    needsRedraw = YES;
  }

  if (prev.textSize != next.textSize) {
    _customDataSource.textSize = next.textSize;
    needsRedraw = YES;
  }

  if (prev.textColor != next.textColor) {
    _customDataSource.textColor = nmap::intToColor(next.textColor);
    needsRedraw = YES;
  }

  if (prev.fontWeight != next.fontWeight) {
    _customDataSource.fontWeight = next.fontWeight;
    needsRedraw = YES;
  }

  if (prev.infoWindowBackgroundColor != next.infoWindowBackgroundColor) {
    _customDataSource.backgroundColor = nmap::intToColor(next.infoWindowBackgroundColor);
    needsRedraw = YES;
  }

  if (prev.infoWindowBorderRadius != next.infoWindowBorderRadius) {
    _customDataSource.borderRadius = next.infoWindowBorderRadius;
    needsRedraw = YES;
  }

  if (prev.infoWindowBorderWidth != next.infoWindowBorderWidth) {
    _customDataSource.borderWidth = next.infoWindowBorderWidth;
    needsRedraw = YES;
  }

  if (prev.infoWindowBorderColor != next.infoWindowBorderColor) {
    _customDataSource.borderColor = nmap::intToColor(next.infoWindowBorderColor);
    needsRedraw = YES;
  }

  if (prev.infoWindowPadding != next.infoWindowPadding) {
    _customDataSource.padding = next.infoWindowPadding;
    needsRedraw = YES;
  }

  // Redraw the info window if any styling property changed
  if (needsRedraw) {
    [_inner invalidate];
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapInfoWindowCls(void) {
  return RNCNaverMapInfoWindow.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapInfoWindowComponentDescriptor>();
}

@end
