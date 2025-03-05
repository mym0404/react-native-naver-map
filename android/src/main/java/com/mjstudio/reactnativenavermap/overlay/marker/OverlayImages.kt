package com.mjstudio.reactnativenavermap.overlay.marker

import com.naver.maps.map.overlay.OverlayImage
import java.util.concurrent.ConcurrentHashMap

object OverlayImages {
  private val store: MutableMap<String, OverlayImage> = ConcurrentHashMap()

  fun put(
    uri: String,
    image: OverlayImage,
  ) {
    store[uri] = image
  }

  operator fun get(uri: String): OverlayImage? = store[uri]
}
