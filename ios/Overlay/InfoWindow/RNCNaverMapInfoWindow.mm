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

@interface RNCNaverMapInfoWindow () <RCTRNCNaverMapInfoWindowViewProtocol>

@end

@implementation RNCNaverMapInfoWindow {
  NSString* _markerIdentifier;
  BOOL _shouldBeOpen;
  NMFMapView* _currentMapView;
  RNCNaverMapViewImpl* _parentMapViewImpl;
  NMFInfoWindowDefaultTextSource* _textDataSource;
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

    // Create text data source (iOS only supports text for now)
    _textDataSource = [NMFInfoWindowDefaultTextSource dataSource];
    _textDataSource.title = @"";
    _inner.dataSource = _textDataSource;
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

  // Text content only (iOS custom styling is not supported by NMFInfoWindow API)
  // For custom styling on iOS, consider using Marker with custom view instead
  if (prev.text != next.text) {
    _textDataSource.title = getNsStr(next.text);
  }

  // Note: fontWeight, borderRadius, borderWidth, borderColor, padding
  // are ignored on iOS due to NMFInfoWindow limitations
  // These props work on Android only

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapInfoWindowCls(void) {
  return RNCNaverMapInfoWindow.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapInfoWindowComponentDescriptor>();
}

@end
