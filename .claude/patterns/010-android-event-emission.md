# android-event-emission

# Android Event Emission

[EXPLANATION] Android event emission using ReactContext and RCTEventEmitter

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