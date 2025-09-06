//
//  RNCNaverMapMultiPath.mm
//  mj-studio-react-native-naver-map
//
//  Created by mj on 9/6/24.
//

#import "RNCNaverMapMultiPath.h"

using namespace facebook::react;
@interface RNCNaverMapMultiPath () <RCTRNCNaverMapMultiPathViewProtocol>

@end

@implementation RNCNaverMapMultiPath {
  RNCNaverMapImageCanceller _imageCanceller;
}

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapMultiPathEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapMultiPathEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMultipartPath new];

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
    static const auto defaultProps = std::make_shared<const RNCNaverMapMultiPathProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapMultiPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapMultiPathProps const>(props);

  // Basic overlay properties
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

  // MultiPath specific properties
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
  if (prev.patternInterval != next.patternInterval)
    _inner.patternInterval = next.patternInterval;
  if (prev.progress != next.progress)
    _inner.progress = next.progress;

  if (prev.isHideCollidedSymbols != next.isHideCollidedSymbols)
    [_inner setIsHideCollidedSymbols:next.isHideCollidedSymbols];
  if (prev.isHideCollidedMarkers != next.isHideCollidedMarkers)
    [_inner setIsHideCollidedMarkers:next.isHideCollidedMarkers];
  if (prev.isHideCollidedCaptions != next.isHideCollidedCaptions)
    [_inner setIsHideCollidedCaptions:next.isHideCollidedCaptions];

  // pathParts - most important part for MultiPath
  {
    bool pathPartsChanged = false;
    if (prev.pathParts.size() != next.pathParts.size()) {
      pathPartsChanged = true;
    } else {
      for (int i = 0; i < prev.pathParts.size() && !pathPartsChanged; i++) {
        const auto& prevPart = prev.pathParts[i];
        const auto& nextPart = next.pathParts[i];

        // Check if coordinates changed
        if (prevPart.coords.size() != nextPart.coords.size()) {
          pathPartsChanged = true;
        } else {
          for (int j = 0; j < prevPart.coords.size() && !pathPartsChanged; j++) {
            if (!nmap::isCoordEqual(prevPart.coords[j], nextPart.coords[j])) {
              pathPartsChanged = true;
            }
          }
        }

        // Check if colors changed
        if (!pathPartsChanged &&
            (prevPart.color != nextPart.color || prevPart.passedColor != nextPart.passedColor ||
             prevPart.outlineColor != nextPart.outlineColor ||
             prevPart.passedOutlineColor != nextPart.passedOutlineColor)) {
          pathPartsChanged = true;
        }
      }
    }

    if (pathPartsChanged) {
      NSLog(@"hello");
      NSMutableArray* lineParts = [NSMutableArray new];
      NSMutableArray* colorParts = [NSMutableArray new];

      for (const auto& pathPart : next.pathParts) {
        // Convert coords to NMGLineString
        NSMutableArray* coords = [NSMutableArray arrayWithCapacity:pathPart.coords.size()];
        for (const auto& coord : pathPart.coords) {
          [coords addObject:nmap::createLatLng(coord)];
        }
        [lineParts addObject:[NMGLineString lineStringWithPoints:coords]];

        // Convert colors to NMFPathColor
        NMFPathColor* pathColor =
            [NMFPathColor pathColorWithColor:nmap::intToColor(pathPart.color)
                                outlineColor:nmap::intToColor(pathPart.outlineColor)
                                 passedColor:nmap::intToColor(pathPart.passedColor)
                          passedOutlineColor:nmap::intToColor(pathPart.passedOutlineColor)];
        [colorParts addObject:pathColor];
      }

      _inner.lineParts = lineParts;
      _inner.colorParts = colorParts;
    }
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapMultiPathCls(void) {
  return RNCNaverMapMultiPath.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapMultiPathComponentDescriptor>();
}

#endif

@end
