package com.mjstudio.reactnativenavermap.module

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.module.annotations.ReactModule
import com.mjstudio.reactnativenavermap.RNCNaverMapUtilSpec
import com.naver.maps.map.overlay.InfoWindow
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

@ReactModule(name = RNCNaverMapUtilModule.NAME)
class RNCNaverMapUtilModule(
  reactContext: ReactApplicationContext,
) : RNCNaverMapUtilSpec(reactContext) {
  companion object {
    const val NAME = "RNCNaverMapUtil"
  }

  private val infoWindows = mutableMapOf<String, InfoWindow>()
  private val infoWindowContents = mutableMapOf<String, InfoWindowContent>()

  override fun getName(): String = NAME

  @ReactMethod
  override fun createInfoWindow(id: String) {
    runOnUiThreadSync {
      if (infoWindows.containsKey(id)) return@runOnUiThreadSync

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
        }

      infoWindows[id] = infoWindow
    }
  }

  @ReactMethod
  override fun destroyInfoWindow(id: String) {
    runOnUiThreadSync {
      infoWindows[id]?.let { infoWindow ->
        infoWindow.close()
        infoWindows.remove(id)
        infoWindowContents.remove(id)
      }
    }
  }

  @ReactMethod
  override fun closeInfoWindow(id: String) {
    runOnUiThreadSync {
      infoWindows[id]?.close()
    }
  }

  @ReactMethod
  override fun setInfoWindowContent(
    id: String,
    title: String,
    subtitle: String?,
  ) {
    runOnUiThreadSync {
      infoWindowContents[id] = InfoWindowContent(title, subtitle)
      val infoWindow = infoWindows[id] ?: return@runOnUiThreadSync

      if (isInfoWindowActuallyOpen(infoWindow)) {
        infoWindow.invalidate()
      }
    }
  }

  @ReactMethod(isBlockingSynchronousMethod = true)
  override fun isInfoWindowOpen(id: String): Boolean =
    runOnUiThreadSync {
      infoWindows[id]?.let(::isInfoWindowActuallyOpen) ?: false
    }

  fun getInfoWindow(id: String): InfoWindow? = infoWindows[id]

  private fun isInfoWindowActuallyOpen(infoWindow: InfoWindow): Boolean = infoWindow.map != null || infoWindow.marker != null

  private fun <T> runOnUiThreadSync(block: () -> T): T {
    if (UiThreadUtil.isOnUiThread()) {
      return block()
    }

    val latch = CountDownLatch(1)
    var result: Result<T>? = null
    UiThreadUtil.runOnUiThread {
      result = runCatching(block)
      latch.countDown()
    }

    check(latch.await(2, TimeUnit.SECONDS)) {
      "Timed out waiting for the Android UI thread"
    }

    return checkNotNull(result).getOrThrow()
  }

  private data class InfoWindowContent(
    val title: String,
    val subtitle: String?,
  )
}
