# android-native-utilities

# Android Native Utilities

[EXPLANATION] Android native utility functions for event emission, prop validation, and conversions

## Usage

### Event Emission Utility
```kotlin
import com.mjstudio.reactnativenavermap.util.emitEvent

// Emit custom events from React components
reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
  CustomEvent(surfaceId, reactTag, eventData)
}
```

### Direct Event Registration
```kotlin
import com.mjstudio.reactnativenavermap.util.registerDirectEvent

// Register direct events in ViewManager
override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
  return buildMap {
    registerDirectEvent(this, "topTapOverlay")
    registerDirectEvent(this, "topCameraChange")
  }
}
```

### ReadableMap Extensions
```kotlin
import com.mjstudio.reactnativenavermap.util.*

// Extract coordinates from ReadableMap
val latLng = props.getLatLng() // returns LatLng?
val point = props.getPoint() // returns PointF?
val region = props.getRegion() // returns RNCNaverMapRegion?

// Safe value extraction
val doubleValue = props.getDoubleOrNull("key")
val intValue = props.getIntOrNull("key")
val align = props.getAlign("alignKey") // returns Align enum
```

### Number Validation
```kotlin
import com.mjstudio.reactnativenavermap.util.isValidNumber

// Validate numbers before use
if (isValidNumber(latitude) && isValidNumber(longitude)) {
  // Use validated values
}
```

### Pixel/DP Conversion
```kotlin
import com.mjstudio.reactnativenavermap.util.*

// Convert DP to pixels
val pixels = dpValue.px
val pixelsFromDouble = doubleValue.px

// Convert pixels to DP  
val dp = pixelValue.dp
val dpFromFloat = floatValue.dp
```

### Rect Creation Utility
```kotlin
import com.mjstudio.reactnativenavermap.util.RectUtil

// Create Rect from padding props
val rect = RectUtil.getRect(
  padding = paddingProps,
  density = resources.displayMetrics.density,
  defaultValue = 0.0
) // returns Rect?
```

### Map Extensions
```kotlin
// Extract LatLng from Map<String, *>
val coords = mapData.getLatLng() // returns LatLng?
```