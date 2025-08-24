package com.mjstudio.reactnativenavermap.overlay.multipath

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.image.RNCNaverMapImageRenderableOverlay
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.MultipartPathOverlay
import com.naver.maps.map.overlay.OverlayImage

@SuppressLint("ViewConstructor")
class RNCNaverMapMultiPath(
  val reactContext: ThemedReactContext,
) : RNCNaverMapImageRenderableOverlay<MultipartPathOverlay>(reactContext) {
  override val overlay: MultipartPathOverlay by lazy {
    MultipartPathOverlay().apply {
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

  fun setCoordParts(coordParts: List<List<LatLng>>) {
    overlay.coordParts = coordParts
  }

  fun setColorParts(colorParts: List<MultipartPathOverlay.ColorPart>) {
    overlay.colorParts = colorParts
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
    // MultipartPathOverlay doesn't support alpha directly
  }

  override fun setOverlayImage(image: OverlayImage?) {
    overlay.patternImage = image
  }
}