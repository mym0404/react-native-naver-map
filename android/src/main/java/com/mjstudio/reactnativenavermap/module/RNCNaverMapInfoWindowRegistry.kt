package com.mjstudio.reactnativenavermap.module

import android.graphics.PointF
import com.facebook.react.bridge.ReactApplicationContext
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.overlay.InfoWindow

class RNCNaverMapInfoWindowRegistry {
  private val infoWindows = mutableMapOf<String, InfoWindow>()
  private val infoWindowContents = mutableMapOf<String, String>()

  fun create(
    id: String,
    reactContext: ReactApplicationContext,
  ) {
    if (infoWindows.containsKey(id)) return

    val infoWindow =
      InfoWindow().apply {
        adapter =
          object : InfoWindow.DefaultTextAdapter(reactContext) {
            override fun getText(infoWindow: InfoWindow): CharSequence = infoWindowContents[id] ?: ""
          }
      }

    infoWindows[id] = infoWindow
  }

  fun destroy(id: String) {
    infoWindows[id]?.let { infoWindow ->
      infoWindow.close()
      infoWindows.remove(id)
      infoWindowContents.remove(id)
    }
  }

  fun close(id: String) {
    infoWindows[id]?.close()
  }

  fun setContent(
    id: String,
    text: String,
  ) {
    infoWindowContents[id] = text
    val infoWindow = infoWindows[id] ?: return

    if (isOpen(infoWindow)) {
      infoWindow.invalidate()
    }
  }

  fun setOptions(
    id: String,
    anchorX: Double,
    anchorY: Double,
    offsetX: Double,
    offsetY: Double,
    alpha: Double,
  ) {
    val infoWindow = infoWindows[id] ?: return

    infoWindow.anchor = PointF(anchorX.toFloat(), anchorY.toFloat())
    infoWindow.offsetX = offsetX.px
    infoWindow.offsetY = offsetY.px
    infoWindow.alpha = alpha.toFloat()
  }

  fun isOpen(id: String): Boolean = infoWindows[id]?.let(::isOpen) ?: false

  fun get(id: String): InfoWindow? = infoWindows[id]

  fun clear() {
    infoWindows.values.forEach { it.close() }
    infoWindows.clear()
    infoWindowContents.clear()
  }

  private fun isOpen(infoWindow: InfoWindow): Boolean = infoWindow.map != null || infoWindow.marker != null
}
