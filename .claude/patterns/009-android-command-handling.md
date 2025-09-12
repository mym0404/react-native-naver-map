---
keywords: android, command, handling, kotlin, react-native
language: kotlin
explanation: Android command handling using receiveCommand method with command ID matching
---

# Android Command Handling

## Usage

```kotlin
override fun receiveCommand(root: RNCNaverMapViewWrapper, commandId: String, args: ReadableArray?) {
  when (commandId) {
    "screenToCoordinate" -> {
      val x = args?.getDouble(0) ?: 0.0
      val y = args?.getDouble(1) ?: 0.0
      // Convert and resolve promise
    }
    "animateCameraTo" -> {
      val latitude = args?.getDouble(0) ?: 0.0
      val longitude = args?.getDouble(1) ?: 0.0
      root.animateCameraTo(latitude, longitude)
    }
  }
}
```