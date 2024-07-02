package com.mjstudio.reactnativenavermap.util.image

import com.naver.maps.map.overlay.OverlayImage
import java.util.concurrent.ConcurrentHashMap

object OverlayImageCache {
  private val store: MutableMap<String, OverlayImage> = ConcurrentHashMap()

  fun put(
    uri: String,
    image: OverlayImage,
  ) {
    store[uri] = image
  }

  operator fun get(uri: String): OverlayImage? {
    return store[uri]
  }
}
