# ios-native-utilities

# iOS Native Utilities

[EXPLANATION] iOS native utility functions for color conversion, validation, and object creation

## Usage

### Color Utilities
```objc
#import "ColorUtil.h"

// Convert hex string to UIColor
UIColor* color = nmap::hexToColor(@"#FF0000");
UIColor* colorWithAlpha = nmap::hexToColor(@"#FF0000FF");

// Convert integer to UIColor
UIColor* color = nmap::intToColor(0xFF0000FF);
```

### Number Validation
```objc
#import "FnUtil.h"

// Validate NSNumber
if (isValidNumber(value)) {
  // Use validated value
}

// Get number or nil
NSNumber* safeNumber = getNumberOrNil(value);

// Get double with default
double result = getDoubleOrDefault(value, 0.0);
double resultFromDouble = getDoubleOrDefault(doubleValue, 0.0);
```

### String Utilities
```objc
#import "FnUtil.h"

// Convert C++ string to NSString
NSString* nsString = getNsStr(cppString);

// Validate non-empty string
if (isNotEmptyString(str)) {
  // Use validated string
}
```

### Math Utilities
```objc
#import "FnUtil.h"

// Clamp value between min and max
double result = clamp(value, minValue, maxValue);
```

### Template-based Props Validation (C++)
```objc
#import "FnUtil.h"

// Image prop equality check
bool equal = nmap::isImageEqual(newImage, prevImage);

// Coordinate equality check  
bool equal = nmap::isCoordEqual(newCoord, prevCoord);

// Camera equality check
bool equal = nmap::isCameraEqual(newCamera, prevCamera);

// Region equality check
bool equal = nmap::isRegionEqual(newRegion, prevRegion);

// Rect equality check
bool equal = nmap::isRectEqual(newRect, prevRect);

// Anchor equality check
bool equal = nmap::isAnchorEqual(newAnchor, prevAnchor);
```

### Dictionary Creation from Props
```objc
#import "FnUtil.h"

// Create image dictionary
NSDictionary* imageDict = nmap::createImageDictinary(imageProp);

// Create anchor dictionary
NSDictionary* anchorDict = nmap::createAnchorDictionary(anchorProp);

// Create coordinate dictionary
NSDictionary* coordDict = nmap::createLatLngDictionary(coordProp);

// Create camera dictionary
NSDictionary* cameraDict = nmap::createCameraDictionary(cameraProp);
```

### Native Object Creation
```objc
#import "FnUtil.h"

// Create NMGLatLng from props
NMGLatLng* latLng = nmap::createLatLng(coordProp);

// Create NMGLatLng from dictionary
NMGLatLng* latLng = nmap::createLatLngFromDictionary(dict);

// Create NMGLatLngBounds
NMGLatLngBounds* bounds = nmap::createLatLngBounds(regionProp);

// Create UIEdgeInsets
UIEdgeInsets insets = nmap::createUIEdgeInsets(rectProp);

// Create CGPoint
CGPoint point = nmap::createAnchorCGPoint(anchorProp);
```

### Enum Conversion
```objc
#import "FnUtil.h"

// Create NMFAlignType from integer
NMFAlignType* align = nmap::createAlign(alignValue);

// Create NMFLogoAlign from string
NMFLogoAlign logoAlign = nmap::createLogoAlign("TopLeft");
```

### Image Loading Utilities
```objc
#import "ImageUtil.h"

// Load image with callback
RNCNaverMapImageCanceller canceller = nmap::getImage(bridge, imageProp, ^(NMFOverlayImage* image) {
  // Handle loaded image
  if (image) {
    marker.iconImage = image;
  }
});

// Cancel image loading if needed
if (canceller) {
  canceller();
}
```