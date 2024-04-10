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

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFPolygonOverlay new];

#ifdef RCT_NEW_ARCH_ENABLED
    self.onTapOverlay = [self](NSDictionary* dict) {
      if (_eventEmitter == nil) {
        return;
      }

      auto emitter = std::static_pointer_cast<RNCNaverMapPolygonEventEmitter const>(_eventEmitter);
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

NMAP_SETTER(Z, z, IndexValue, inner.zIndex, NSInteger)
NMAP_SETTER(I, i, sHidden, inner.hidden, BOOL)
NMAP_INNER_SETTER(M, m, inZoom, double)
NMAP_INNER_SETTER(M, m, axZoom, double)
NMAP_INNER_SETTER(I, i, sMinZoomInclusive, BOOL)
NMAP_INNER_SETTER(I, i, sMaxZoomInclusive, BOOL)

- (void)setGeometries:(NSDictionary*)geometries {
  _geometries = geometries;
  NSDictionary* dic = [RCTConvert NSDictionary:geometries];

  // process exterior ring
  NSArray* exteriorRing = [RCTConvert NSArray:dic[@"coords"]];
  NSUInteger size = exteriorRing.count;
  NSMutableArray<NMGLatLng*>* points = [NSMutableArray arrayWithCapacity:size];
  for (int i = 0; i < size; i++) {
    [points addObject:[RCTConvert NMGLatLng:exteriorRing[i]]];
  }
  NMGLineString* exRing = [NMGLineString lineStringWithPoints:points];

  // process interior rings
  NSArray<NSArray*>* interiorRings = [RCTConvert NSArrayArray:dic[@"holes"]];
  NSMutableArray<NMGLineString*>* inRings = [[NSMutableArray alloc] init];
  for (NSArray* interiorRing in interiorRings) {
    NSMutableArray<NMGLatLng*>* ring = [[NSMutableArray alloc] init];
    for (id coord in interiorRing) {
      [ring addObject:[RCTConvert NMGLatLng:coord]];
    }
    [inRings addObject:[NMGLineString lineStringWithPoints:ring]];
  }

  self.inner.polygon = [NMGPolygon polygonWithRing:exRing interiorRings:inRings];
}

- (void)setColor:(NSInteger)color {
  _color = color;
  _inner.fillColor = [Utils intToColor:color];
}
- (void)setOutlineColor:(NSInteger)outlineColor {
  _outlineColor = outlineColor;
  _inner.outlineColor = [Utils intToColor:outlineColor];
}
NMAP_INNER_SETTER(O, o, utlineWidth, double)

#ifdef RCT_NEW_ARCH_ENABLED

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapPolygonComponentDescriptor>();
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

  NMAP_REMAP_SELF_PROP(zIndexValue);
  NMAP_REMAP_SELF_PROP(isHidden);
  NMAP_REMAP_SELF_PROP(minZoom);
  NMAP_REMAP_SELF_PROP(maxZoom);
  NMAP_REMAP_SELF_PROP(isMinZoomInclusive);
  NMAP_REMAP_SELF_PROP(isMaxZoomInclusive);
  NMAP_REMAP_SELF_PROP(outlineWidth);
  NMAP_REMAP_SELF_PROP(color);
  NMAP_REMAP_SELF_PROP(outlineColor);

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
    auto coords = [NSMutableArray arrayWithCapacity:next.geometries.coords.size()];
    for (auto& coord : next.geometries.coords) {
      [coords addObject:@{@"latitude" : @(coord.latitude), @"longitude" : @(coord.longitude)}];
    }

    auto holesArray = [NSMutableArray arrayWithCapacity:std::size(next.geometries.holes)];
    for (auto& hole : next.geometries.holes) {
      auto innerArr = [NSMutableArray arrayWithCapacity:std::size(hole)];
      for (auto& coord : hole) {
        [innerArr addObject:@{@"latitude" : @(coord.latitude), @"longitude" : @(coord.longitude)}];
      }
      [holesArray addObject:innerArr];
    }

    self.geometries = @{@"coords" : coords, @"holes" : holesArray};
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapPolygonCls(void) {
  return RNCNaverMapPolygon.class;
}
// todo remove
Class<RCTComponentViewProtocol> RNCNaverMapPolylineCls(void) {
  return RNCNaverMapPolygon.class;
}
// todo remove
Class<RCTComponentViewProtocol> RNCNaverMapPathCls(void) {
  return RNCNaverMapPolygon.class;
}

#endif

@end
