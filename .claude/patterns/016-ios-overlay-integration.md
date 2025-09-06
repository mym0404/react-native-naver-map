# ios-overlay-integration

# iOS Overlay Integration Pattern

## Usage

### 1. Add Header Import in RNCNaverMapViewImpl.h
```objc
#import "RNCNaverMapMarker.h"
#import "RNCNaverMapNewOverlay.h"  // Add your new overlay import
#import "RNCNaverMapPath.h"
```

### 2. Add insertReactSubview Logic
```objc
} else if ([subview isKindOfClass:[RNCNaverMapNewOverlay class]]) {
  auto marker = static_cast<RNCNaverMapNewOverlay*>(subview).inner;
  marker.mapView = self.mapView;
} else if ([subview isKindOfClass:[RNCNaverMapArrowheadPath class]]) {
```

### 3. Add removeReactSubview Logic
```objc
} else if ([subview isKindOfClass:[RNCNaverMapNewOverlay class]]) {
  auto marker = static_cast<RNCNaverMapNewOverlay*>(subview).inner;
  marker.mapView = nil;
  marker.touchHandler = nil;
} else if ([subview isKindOfClass:[RNCNaverMapArrowheadPath class]]) {
```

### 4. Update package.json codegenConfig
```json
"componentProvider": {
  "RNCNaverMapView": "RNCNaverMapView",
  "RNCNaverMapNewOverlay": "RNCNaverMapNewOverlay",
  "RNCNaverMapPath": "RNCNaverMapPath"
}
```