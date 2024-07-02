//
//  RNCNaverMapPolygon.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapPolygon.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
@interface RNCNaverMapPolygon () <RCTRNCNaverMapPolygonViewProtocol>

@end

#endif

@implementation RNCNaverMapPolygon {
}

- (std::shared_ptr<RNCNaverMapPolygonEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapPolygonEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPolygonOverlay new];

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
    static const auto defaultProps = std::make_shared<const RNCNaverMapPolygonProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapPolygonProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapPolygonProps const>(props);

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

  if (prev.outlineWidth != next.outlineWidth)
    _inner.outlineWidth = next.outlineWidth;
  if (prev.color != next.color)
    _inner.fillColor = nmap::intToColor(next.color);
  if (prev.outlineColor != next.outlineColor)
    _inner.outlineColor = nmap::intToColor(next.outlineColor);

  bool isSame = false;
  if (prev.geometries.coords.size() == next.geometries.coords.size() &&
      prev.geometries.holes.size() == next.geometries.holes.size()) {
    isSame = true;
    for (int i = 0; i < prev.geometries.holes.size() && isSame; i++) {
      if (prev.geometries.holes[i].size() != next.geometries.holes[i].size()) {
        isSame = false;
      }
    }
    for (int i = 0; i < prev.geometries.coords.size() && isSame; i++) {
      if (prev.geometries.coords[i].latitude != next.geometries.coords[i].latitude) {
        isSame = false;
      }
      if (prev.geometries.coords[i].longitude != next.geometries.coords[i].longitude) {
        isSame = false;
      }
    }
    for (int i = 0; i < prev.geometries.holes.size() && isSame; i++) {
      for (int j = 0; j < prev.geometries.holes[i].size() && isSame; j++) {
        if (prev.geometries.holes[i][j].latitude != next.geometries.holes[i][j].latitude) {
          isSame = false;
        }
        if (prev.geometries.holes[i][j].longitude != next.geometries.holes[i][j].longitude) {
          isSame = false;
        }
      }
    }
  }

  if (!isSame) {
    const auto& coords = next.geometries.coords;
    const auto& holes = next.geometries.holes;

    // process exterior ring
    NSMutableArray<NMGLatLng*>* points = [NSMutableArray arrayWithCapacity:coords.size()];
    for (const auto& coord : coords) {
      [points addObject:nmap::createLatLng(coord)];
    }
    NMGLineString* exRing = [NMGLineString lineStringWithPoints:points];

    // process interior rings
    NSMutableArray<NMGLineString*>* inRings = [[NSMutableArray alloc] init];
    for (const auto& hole : holes) {
      NSMutableArray<NMGLatLng*>* points = [[NSMutableArray alloc] init];
      for (const auto& p : hole) {
        [points addObject:nmap::createLatLng(p)];
      }
      [inRings addObject:[NMGLineString lineStringWithPoints:points]];
    }

    self.inner.polygon = [NMGPolygon polygonWithRing:exRing interiorRings:inRings];
  }

  [super updateProps:props oldProps:oldProps];
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPolygonComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RNCNaverMapPolygonCls(void) {
  return RNCNaverMapPolygon.class;
}

@end
