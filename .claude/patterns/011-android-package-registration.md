# android-package-registration

# Android Package Registration

## Usage

```kotlin
class RNCNaverMapPackage : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return listOf(RNCNaverMapUtilModule(reactContext))
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return listOf(RNCNaverMapViewManager())
  }
}
```