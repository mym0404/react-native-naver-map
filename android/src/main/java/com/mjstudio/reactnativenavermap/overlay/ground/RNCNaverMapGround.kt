package com.mjstudio.reactnativenavermap.overlay.ground

import android.annotation.SuppressLint
import android.graphics.Bitmap
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.ImageRequestCanceller
import com.mjstudio.reactnativenavermap.util.createDraweeHierarchy
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.getOverlayImage
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.GroundOverlay
import com.naver.maps.map.overlay.OverlayImage
import com.naver.maps.map.util.MarkerIcons

@SuppressLint("ViewConstructor")
class RNCNaverMapGround(private val reactContext: ThemedReactContext) :
  RNCNaverMapOverlay<GroundOverlay>(reactContext) {
  private val imageHolder: DraweeHolder<GenericDraweeHierarchy>? by lazy {
    DraweeHolder.create(createDraweeHierarchy(resources), reactContext)?.apply {
      onAttach()
    }
  }
  private var lastImage: ReadableMap? = null
  private var imageRequestCanceller: ImageRequestCanceller? = null
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
    imageHolder?.onDetach()
    imageRequestCanceller?.invoke()
  }

  fun setImage(image: ReadableMap?) {
    lastImage = image
    overlay.alpha = 0f
    imageRequestCanceller?.invoke()
    imageRequestCanceller =
      getOverlayImage(imageHolder!!, context, image?.toHashMap()) {
        setOverlayImage(it)
        isImageSet = true
        overlay.alpha = 1f
      }
  }

  private fun setOverlayImage(image: OverlayImage?) {
    overlay.image =
      image ?: OverlayImage.fromBitmap(Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888))
  }
}
