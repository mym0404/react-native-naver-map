package com.mjstudio.reactnativenavermap.module

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.mjstudio.reactnativenavermap.RNCNaverMapUtilSpec
import com.naver.maps.map.overlay.InfoWindow

@ReactModule(name = RNCNaverMapUtilModule.NAME)
class RNCNaverMapUtilModule(
  reactContext: ReactApplicationContext,
) : RNCNaverMapUtilSpec(reactContext) {
  companion object {
    const val NAME = "RNCNaverMapUtil"
  }

  private val infoWindows = mutableMapOf<String, InfoWindow>()
  private val infoWindowContents = mutableMapOf<String, InfoWindowContent>()
  private val openInfoWindows = mutableSetOf<String>()

  override fun getName(): String = NAME

  @ReactMethod
  override fun createInfoWindow(id: String) {
    if (infoWindows.containsKey(id)) return

    val infoWindow =
      InfoWindow().apply {
        adapter =
          object : InfoWindow.DefaultTextAdapter(reactApplicationContext) {
            override fun getText(infoWindow: InfoWindow): CharSequence {
              val content = infoWindowContents[id]
              return content?.let {
                if (it.subtitle.isNullOrEmpty()) {
                  it.title
                } else {
                  "${it.title}\n${it.subtitle}"
                }
              } ?: ""
            }
          }
        // todo
//        setOnClickListener {
//          true
//        }
      }

    infoWindows[id] = infoWindow
  }

  @ReactMethod
  override fun destroyInfoWindow(id: String) {
    infoWindows[id]?.let { infoWindow ->
      infoWindow.close()
      infoWindows.remove(id)
      infoWindowContents.remove(id)
      openInfoWindows.remove(id)
    }
  }

  @ReactMethod
  override fun closeInfoWindow(id: String) {
    infoWindows[id]?.let { infoWindow ->
      infoWindow.close()
      openInfoWindows.remove(id)
    }
  }

  @ReactMethod
  override fun setInfoWindowContent(
    id: String,
    title: String,
    subtitle: String?,
  ) {
    infoWindowContents[id] = InfoWindowContent(title, subtitle)

    // 이미 열려있다면 업데이트
    if (openInfoWindows.contains(id)) {
      infoWindows[id]?.invalidate()
    }
  }

  @ReactMethod(isBlockingSynchronousMethod = true)
  override fun isInfoWindowOpen(id: String): Boolean = openInfoWindows.contains(id)

  // ViewManager에서 접근할 내부 메서드들
  fun getInfoWindow(id: String): InfoWindow? = infoWindows[id]

  fun markAsOpen(id: String) {
    openInfoWindows.add(id)
  }

  fun markAsClosed(id: String) {
    openInfoWindows.remove(id)
  }

  private data class InfoWindowContent(
    val title: String,
    val subtitle: String?,
  )
}
