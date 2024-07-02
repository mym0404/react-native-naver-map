package com.mjstudio.reactnativenavermap.overlay.path

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.image.RNCNaverMapImageRenderableOverlay
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.OverlayImage
import com.naver.maps.map.overlay.PathOverlay

@SuppressLint("ViewConstructor")
class RNCNaverMapPath(val reactContext: ThemedReactContext) :
  RNCNaverMapImageRenderableOverlay<PathOverlay>(reactContext) {
  override val overlay: PathOverlay by lazy {
    PathOverlay().apply {
      setOnClickListener {
        reactContext.emitEvent(id) { surfaceId, reactTag ->
          NaverMapOverlayTapEvent(
            surfaceId,
            reactTag,
          )
        }
        true
      }
    }
  }

  override fun addToMap(map: NaverMap) {
    overlay.map = map
  }

  override fun removeFromMap(map: NaverMap) {
    overlay.map = null
  }

  override fun onDropViewInstance() {
    overlay.map = null
    overlay.onClickListener = null
    super.onDropViewInstance()
  }

  override fun setOverlayAlpha(alpha: Float) {
  }

  override fun setOverlayImage(image: OverlayImage?) {
    overlay.patternImage = image
  }
}
