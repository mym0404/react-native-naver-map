//
//  FnUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//
#import <NMapsMap/NMapsMap.h>
#import <string>
#import <utility>

static inline BOOL isValidNumber(NSNumber* value) {
  if (!value || [value isKindOfClass:[NSNull class]]) {
    return false;
  }

  double INVALID = -123123123.0;

  if ([value doubleValue]<INVALID + 1 && [value doubleValue]> INVALID - 1) {
    return false;
  }

  return true;
}

static inline BOOL isValidNumber(double value) {
  return isValidNumber([NSNumber numberWithDouble:value]);
}

static inline NSNumber* getNumberOrNil(NSNumber* value) {
  if (!isValidNumber(value)) {
    return nil;
  }

  return value;
}

static inline double getDoubleOrDefault(NSNumber* value, double def) {
  if (!isValidNumber(value)) {
    return def;
  }

  return [value doubleValue];
}

static inline double getDoubleOrDefault(double value, double def) {
  if (!isValidNumber(value)) {
    return def;
  }

  return value;
}

static inline NSString* getNsStr(std::string str) {
  return [NSString stringWithUTF8String:str.c_str()];
}

static inline BOOL isNotEmptyString(NSString* str) {
  return ![str isKindOfClass:[NSNull class]] && str && str.length > 0;
}

static inline double clamp(double a, double b, double c) {
  return MIN(MAX(a, b), c);
}

namespace nmap {

template <typename T> concept IsImageProp = requires(T t) {
  requires std::same_as<std::remove_cvref_t<decltype(t.symbol)>, std::string>;
  requires std::same_as<std::remove_cvref_t<decltype(t.rnAssetUri)>, std::string>;
  requires std::same_as<std::remove_cvref_t<decltype(t.httpUri)>, std::string>;
  requires std::same_as<std::remove_cvref_t<decltype(t.assetName)>, std::string>;
  requires std::same_as<std::remove_cvref_t<decltype(t.reuseIdentifier)>, std::string>;
};
template <typename T> concept IsCoordProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.latitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.longitude)>>;
};
template <typename T> concept IsAnchorProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.x)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.y)>>;
};
template <typename T> concept IsLatLngProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.latitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.longitude)>>;
};
template <typename T> concept IsCameraProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.latitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.longitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.zoom)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.tilt)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.bearing)>>;
};
template <typename T> concept IsRegionProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.latitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.longitude)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.latitudeDelta)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.longitudeDelta)>>;
};
template <typename T> concept IsRectProp = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.top)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.right)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.left)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.bottom)>>;
};

template <IsImageProp T> bool isImageEqual(T n, T p) {
  return !(p.reuseIdentifier != n.reuseIdentifier || p.assetName != n.assetName ||
           p.httpUri != n.httpUri || p.rnAssetUri != n.rnAssetUri || p.symbol != n.symbol);
}

template <IsImageProp T> NSDictionary* createImageDictinary(const T& prop) {
  return @{
    @"reuseIdentifier" : getNsStr(prop.reuseIdentifier),
    @"assetName" : getNsStr(prop.assetName),
    @"httpUri" : getNsStr(prop.httpUri),
    @"rnAssetUri" : getNsStr(prop.rnAssetUri),
    @"symbol" : getNsStr(prop.symbol),
  };
}

template <IsAnchorProp T> bool isAnchorEqual(const T& lhs, const T& rhs) {
  return lhs.x == rhs.x && lhs.y == rhs.y;
}
template <IsAnchorProp T> NSDictionary* createAnchorDictionary(const T& prop) {
  return @{@"x" : @(prop.x), @"y" : @(prop.y)};
}
template <IsAnchorProp T> CGPoint createAnchorCGPoint(const T& prop) {
  return CGPointMake(prop.x, prop.y);
}

template <IsLatLngProp T> NSDictionary* createLatLngDictionary(const T& prop) {
  return @{@"latitude" : @(prop.latitude), @"longitude" : @(prop.longitude)};
}

static inline NMGLatLng* createLatLngFromDictionary(const NSDictionary* dict) {
  return NMGLatLngMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
};

template <IsCoordProp T> bool isCoordEqual(const T& c1, const T& c2) {
  return !(c1.latitude != c2.latitude || c1.longitude != c2.longitude);
}
template <IsCoordProp T> NMGLatLng* createLatLng(const T& c) {
  return NMGLatLngMake(c.latitude, c.longitude);
}

template <IsCameraProp T> bool isCameraEqual(const T& c1, const T& c2) {
  return !(c1.latitude != c2.latitude || c1.longitude != c2.longitude || c1.tilt != c2.tilt ||
           c1.bearing != c2.bearing || c1.zoom != c2.zoom);
}

template <IsCameraProp T> NSDictionary* createCameraDictionary(const T& c) {
  return @{
    @"latitude" : @(c.latitude),
    @"longitude" : @(c.longitude),
    @"zoom" : @(c.zoom),
    @"tilt" : @(c.tilt),
    @"bearing" : @(c.bearing),
  };
}

template <IsRegionProp T> bool isRegionEqual(const T& r1, const T& r2) {
  return !(r1.latitude != r2.latitude || r1.longitude != r2.longitude ||
           r1.latitudeDelta != r2.latitudeDelta || r1.longitudeDelta != r2.longitudeDelta);
}

static NMGLatLngBounds* createLatLngBounds(double latitude, double longitude, double latitudeDelta,
                                           double longitudeDelta) {
  return NMGLatLngBoundsMake(latitude, longitude, latitude + latitudeDelta,
                             longitude + longitudeDelta);
}
template <IsRegionProp T> NMGLatLngBounds* createLatLngBounds(const T& r) {
  return createLatLngBounds(r.latitude, r.longitude, r.latitudeDelta, r.longitudeDelta);
}
template <IsRectProp T> bool isRectEqual(const T& r1, const T& r2) {
  return !(r1.top != r2.top || r1.right != r2.right || r1.bottom != r2.bottom ||
           r1.left != r2.left);
}
template <IsRectProp T> UIEdgeInsets createUIEdgeInsets(const T& r) {
  return UIEdgeInsetsMake(r.top, r.left, r.bottom, r.right);
}

static NMFAlignType* createAlign(int v) {
  if (v == 0)
    return NMFAlignType.center;
  else if (v == 1)
    return NMFAlignType.left;
  else if (v == 2)
    return NMFAlignType.right;
  else if (v == 3)
    return NMFAlignType.top;
  else if (v == 4)
    return NMFAlignType.bottom;
  else if (v == 5)
    return NMFAlignType.topLeft;
  else if (v == 6)
    return NMFAlignType.topRight;
  else if (v == 7)
    return NMFAlignType.bottomRight;
  else if (v == 8)
    return NMFAlignType.bottomLeft;
  return NMFAlignType.bottom;
}

static NMFLogoAlign createLogoAlign(std::string v) {
  if (v == "TopLeft")
    return NMFLogoAlignLeftTop;
  else if (v == "TopRight")
    return NMFLogoAlignRightTop;
  else if (v == "BottomRight")
    return NMFLogoAlignRightBottom;
  return NMFLogoAlignLeftBottom;
}

} // namespace nmap
