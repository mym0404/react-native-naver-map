package com.mjstudio.reactnativenavermap.overlay.ground

import android.annotation.SuppressLint
import android.graphics.Bitmap
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.image.RNCNaverMapImageRenderableOverlay
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.GroundOverlay
import com.naver.maps.map.overlay.OverlayImage
import com.naver.maps.map.util.MarkerIcons

@SuppressLint("ViewConstructor")
class RNCNaverMapGround(private val reactContext: ThemedReactContext) :
  RNCNaverMapImageRenderableOverlay<GroundOverlay>(reactContext) {
  private var isImageSet = false

  override val overlay: GroundOverlay by lazy {
    GroundOverlay().apply {
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
    if (!isImageSet) {
      overlay.image = MarkerIcons.GREEN
      overlay.alpha = 0f
    }
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
    overlay.alpha = alpha
  }

  override fun setOverlayImage(image: OverlayImage?) {
    isImageSet = true
    overlay.image =
      image ?: OverlayImage.fromBitmap(Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888))
  }
}
