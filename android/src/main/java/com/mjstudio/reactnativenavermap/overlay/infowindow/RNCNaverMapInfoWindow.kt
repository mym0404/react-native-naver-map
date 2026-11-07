package com.mjstudio.reactnativenavermap.overlay.infowindow

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.PointF
import android.view.View
import androidx.core.graphics.createBitmap
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.module.RNCNaverMapInfoWindowRegistry
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.InfoWindow
import com.naver.maps.map.overlay.OverlayImage

@SuppressLint("ViewConstructor")
class RNCNaverMapInfoWindow(
  context: ThemedReactContext,
  private val infoWindowRegistry: RNCNaverMapInfoWindowRegistry,
) : RNCNaverMapOverlay<InfoWindow>(context) {
  private var contentView: View? = null
  private var infoWindowId: String? = null
  private var isInvalidationScheduled = false
  private var anchorX = 0.5f
  private var anchorY = 1f

  private val invalidateContent =
    Runnable {
      isInvalidationScheduled = false
      if (isContentReady()) {
        overlay.invalidate()
      } else {
        overlay.close()
      }
    }

  override val overlay: InfoWindow =
    InfoWindow(
      object : InfoWindow.Adapter() {
        override fun getImage(infoWindow: InfoWindow): OverlayImage {
          val view = checkNotNull(contentView)
          // ViewAdapter remeasures with UNSPECIFIED specs, which React views reject.
          val bitmap = createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
          view.draw(Canvas(bitmap))
          return OverlayImage.fromBitmap(bitmap)
        }
      },
    )

  fun setInfoWindowId(value: String?) {
    if (infoWindowId == value) return

    infoWindowId?.let { infoWindowRegistry.unregisterCustom(it, overlay) }
    infoWindowId = value
    value?.let {
      infoWindowRegistry.registerCustom(it, overlay, ::isContentReady)
    }
  }

  fun setAnchorX(value: Double) {
    anchorX = value.toFloat()
    updateAnchor()
  }

  fun setAnchorY(value: Double) {
    anchorY = value.toFloat()
    updateAnchor()
  }

  fun setOffsetX(value: Double) {
    overlay.offsetX = value.px
  }

  fun setOffsetY(value: Double) {
    overlay.offsetY = value.px
  }

  fun setOverlayAlpha(value: Double) {
    overlay.alpha = value.toFloat()
  }

  fun setContentView(
    view: View,
    index: Int,
  ) {
    super.addView(view, index)
    contentView = view
    scheduleInvalidation()
  }

  fun removeContentView(index: Int) {
    overlay.close()
    contentView = null
    super.removeViewAt(index)
  }

  fun scheduleInvalidation() {
    if (isInvalidationScheduled) return
    isInvalidationScheduled = true
    postOnAnimation(invalidateContent)
  }

  override fun onLayout(
    changed: Boolean,
    left: Int,
    top: Int,
    right: Int,
    bottom: Int,
  ) {
    super.onLayout(changed, left, top, right, bottom)
    if (changed) scheduleInvalidation()
  }

  override fun addToMap(map: NaverMap) = Unit

  override fun removeFromMap(map: NaverMap) = Unit

  override fun onDropViewInstance() {
    removeCallbacks(invalidateContent)
    isInvalidationScheduled = false
    infoWindowId?.let { infoWindowRegistry.unregisterCustom(it, overlay) }
    infoWindowId = null
    overlay.close()
    overlay.adapter = InfoWindow.DEFAULT_ADAPTER
    contentView = null
  }

  private fun updateAnchor() {
    overlay.anchor = PointF(anchorX, anchorY)
  }

  private fun isContentReady(): Boolean = contentView?.let { it.width > 0 && it.height > 0 } == true
}
