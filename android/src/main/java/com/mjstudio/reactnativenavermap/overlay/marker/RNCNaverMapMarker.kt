package com.mjstudio.reactnativenavermap.overlay.marker

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.view.View
import androidx.core.graphics.createBitmap
import androidx.core.view.children
import androidx.core.view.isEmpty
import com.airbnb.android.react.maps.TrackableView
import com.airbnb.android.react.maps.ViewChangesTracker
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.image.RNCNaverMapImageRenderableOverlay
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.OverlayImage
import kotlin.math.max

@SuppressLint("ViewConstructor")
class RNCNaverMapMarker(
  val reactContext: ThemedReactContext,
) : RNCNaverMapImageRenderableOverlay<Marker>(reactContext),
  TrackableView {
  private var customView: View? = null
  private var customViewBitmap: Bitmap? = null

  private var isImageSetFromSubview = false

  override val overlay: Marker by lazy {
    Marker().apply {
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

  fun setCustomView(
    view: View,
    index: Int,
  ) {
    super.addView(view, index)
    isImageSetFromSubview = true
    if (view.layoutParams == null) {
      view.setLayoutParams(
        LayoutParams(
          LayoutParams.WRAP_CONTENT,
          LayoutParams.WRAP_CONTENT,
        ),
      )
    }
    ViewChangesTracker.getInstance().addMarker(this)
    customView = view
    updateCustomView()
    overlay.alpha = 1f
  }

  fun removeCustomView(index: Int) {
    customView = null
    ViewChangesTracker.getInstance().removeMarker(this)
    if (customViewBitmap != null && !customViewBitmap!!.isRecycled) customViewBitmap!!.recycle()
    isImageSetFromSubview = false
    setImageWithLastImage()
    super.removeView(children.elementAt(index))
  }

  override fun requestLayout() {
    super.requestLayout()
    if (isEmpty() && customView != null) {
      customView = null
      updateCustomView()
    }
  }

  private fun updateCustomView() {
    if (customViewBitmap == null ||
      customViewBitmap!!.isRecycled ||
      customViewBitmap?.width != overlay.width ||
      customViewBitmap?.height != overlay.height
    ) {
      customViewBitmap =
        createBitmap(max(1, overlay.width), max(1, overlay.height), Bitmap.Config.ARGB_4444)
    }
    if (customView != null) {
      customViewBitmap?.also { bitmap ->
        bitmap.eraseColor(Color.TRANSPARENT)
        val canvas = Canvas(bitmap)
        draw(canvas)
        setOverlayImage(OverlayImage.fromBitmap(bitmap))
      }
    }
  }

  override fun skipTryRender(): Boolean = isImageSetFromSubview

  override fun updateCustomForTracking(): Boolean = true

  override fun update(
    width: Int,
    height: Int,
  ) {
    updateCustomView()
  }

  override fun setOverlayAlpha(alpha: Float) {
    overlay.alpha = alpha
  }

  override fun setOverlayImage(image: OverlayImage?) {
    overlay.icon =
      image ?: OverlayImage.fromBitmap(createBitmap(0, 0))
  }
}
