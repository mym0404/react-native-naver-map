# ios-event-emission

# iOS Event Emission

[EXPLANATION] iOS event emission using generated event emitter for sending events to JavaScript

## Usage

```objc
- (void)onCameraChanged:(NMFCameraPosition *)position {
  if (auto emitter = [self emitter]) {
    facebook::react::RNCNaverMapViewEventEmitter::OnCameraChanged event;
    event.latitude = position.target.latitude;
    event.longitude = position.target.longitude;
    event.zoom = position.zoom;
    emitter->onCameraChanged(event);
  }
}
```