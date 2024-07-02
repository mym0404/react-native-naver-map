package com.mjstudio.reactnativenavermap.overlay.circle

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.CircleOverlay

@SuppressLint("ViewConstructor")
class RNCNaverMapCircle(
  private val reactContext: ThemedReactContext,
) : RNCNaverMapOverlay<CircleOverlay>(reactContext) {
  override val overlay: CircleOverlay by lazy {
    CircleOverlay().apply {
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
  }
}
