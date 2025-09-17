---
keywords: android-events,event-emission,RCTEventEmitter,native-to-js
language: kotlin
explanation: Android event emission using ReactContext and RCTEventEmitter
---

# Android Event Emission

## Usage

```kotlin
private fun emitCameraChangeEvent(view: RNCNaverMapViewWrapper, position: CameraPosition) {
  val event = Arguments.createMap().apply {
    putDouble("latitude", position.target.latitude)
    putDouble("longitude", position.target.longitude)
    putDouble("zoom", position.zoom)
  }

  (view.context as ReactContext)
    .getJSModule(RCTEventEmitter::class.java)
    .receiveEvent(view.id, "onCameraChanged", event)
}
```