---
keywords: android, view-manager, kotlin, codegen, react-native
language: kotlin
explanation: Android ViewManager implementation using codegen delegate pattern
---

# Android ViewManager with Codegen

## Usage

### Spec Abstract Class
```kotlin
abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(), RNCNaverMapViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T> = RNCNaverMapViewManagerDelegate(this)
  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
```

### Manager Implementation
```kotlin
class RNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {

  override fun getName(): String = "RNCNaverMapView"

  override fun createViewInstance(reactContext: ThemedReactContext): RNCNaverMapViewWrapper {
    return RNCNaverMapViewWrapper(reactContext)
  }

  @ReactProp(name = "mapType", defaultValue = "Basic")
  override fun setMapType(view: RNCNaverMapViewWrapper?, value: String?) {
    view?.setMapType(value)
  }

  @ReactProp(name = "initialCamera")
  override fun setInitialCamera(view: RNCNaverMapViewWrapper?, value: ReadableMap?) {
    value?.let { view?.setInitialCamera(it) }
  }
}
```