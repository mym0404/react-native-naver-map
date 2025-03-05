package com.mjstudio.reactnativenavermap.overlay.polygon

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.PolygonOverlay

@SuppressLint("ViewConstructor")
class RNCNaverMapPolygon(
  val reactContext: ThemedReactContext,
) : RNCNaverMapOverlay<PolygonOverlay>(reactContext) {
  override val overlay: PolygonOverlay by lazy {
    PolygonOverlay().apply {
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
