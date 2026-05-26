package com.mjstudio.reactnativenavermap.module

import com.facebook.react.bridge.ReactApplicationContext
import com.naver.maps.map.overlay.InfoWindow

class RNCNaverMapInfoWindowRegistry {
  private val infoWindows = mutableMapOf<String, InfoWindow>()
  private val infoWindowContents = mutableMapOf<String, InfoWindowContent>()

  fun create(
    id: String,
    reactContext: ReactApplicationContext,
  ) {
    if (infoWindows.containsKey(id)) return

    val infoWindow =
      InfoWindow().apply {
        adapter =
          object : InfoWindow.DefaultTextAdapter(reactContext) {
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
    title: String,
    subtitle: String?,
  ) {
    infoWindowContents[id] = InfoWindowContent(title, subtitle)
    val infoWindow = infoWindows[id] ?: return

    if (isOpen(infoWindow)) {
      infoWindow.invalidate()
    }
  }

  fun isOpen(id: String): Boolean = infoWindows[id]?.let(::isOpen) ?: false

  fun get(id: String): InfoWindow? = infoWindows[id]

  fun clear() {
    infoWindows.values.forEach { it.close() }
    infoWindows.clear()
    infoWindowContents.clear()
  }

  private fun isOpen(infoWindow: InfoWindow): Boolean = infoWindow.map != null || infoWindow.marker != null

  private data class InfoWindowContent(
    val title: String,
    val subtitle: String?,
  )
}
