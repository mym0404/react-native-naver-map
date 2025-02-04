package com.mjstudio.reactnativenavermap.overlay.marker

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.core.view.children
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
  private var isUpdating = false
  private var pendingMap: NaverMap? = null

  override val overlay: Marker by lazy {
    Marker().apply {
      icon = OverlayImage.fromBitmap(
        Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888).apply {
          eraseColor(Color.TRANSPARENT)
        }
      )
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
    if (customView != null) {
      // 커스텀 뷰가 있는 경우 맵 추가를 보류
      pendingMap = map
      scheduleUpdate()
    } else {
      // 일반 마커의 경우 바로 추가
      overlay.map = map
    }
  }

  override fun removeFromMap(map: NaverMap) {
    pendingMap = null
    overlay.map = null
  }

  private fun recycleBitmap() {
    customViewBitmap?.let { bitmap ->
      if (!bitmap.isRecycled) {
        bitmap.recycle()
      }
      customViewBitmap = null
    }
  }

  @Synchronized
  private fun updateCustomView() {
    if (isUpdating) return

    try {
      isUpdating = true

      val needNewBitmap = customViewBitmap == null ||
              customViewBitmap!!.isRecycled ||
              customViewBitmap?.width != overlay.width ||
              customViewBitmap?.height != overlay.height

      if (needNewBitmap) {
        val newBitmap = Bitmap.createBitmap(
          max(1, overlay.width),
          max(1, overlay.height),
          Bitmap.Config.ARGB_8888
        )

        val oldBitmap = customViewBitmap
        customViewBitmap = newBitmap
        oldBitmap?.recycle()
      }

      customView?.let { view ->
        customViewBitmap?.let { bitmap ->
          bitmap.eraseColor(Color.TRANSPARENT)
          val canvas = Canvas(bitmap)
          view.draw(canvas)

          overlay.icon = OverlayImage.fromBitmap(bitmap)

          // 커스텀 뷰가 준비된 후에 맵에 추가
          pendingMap?.let { map ->
            overlay.map = map
            pendingMap = null
          }
        }
      }
    } catch (e: Exception) {
      Log.e("RNCNaverMapMarker", "Failed to update custom view", e)
    } finally {
      isUpdating = false
    }
  }

  // 디바운스 처리를 위한 핸들러
  private val updateHandler = Handler(Looper.getMainLooper())
  private var pendingUpdate: Runnable? = null

  private fun scheduleUpdate() {
    pendingUpdate?.let { updateHandler.removeCallbacks(it) }
    pendingUpdate = Runnable {
      updateCustomView()
      pendingUpdate = null
    }.also { runnable ->
      updateHandler.postDelayed(runnable, 16)  // 약 1프레임 딜레이
    }
  }

  override fun onDropViewInstance() {
    updateHandler.removeCallbacksAndMessages(null)  // pending 업데이트 제거
    pendingUpdate = null
    recycleBitmap()
    customView = null
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
      view.layoutParams = LayoutParams(
        LayoutParams.WRAP_CONTENT,
        LayoutParams.WRAP_CONTENT,
      )
    }

    ViewChangesTracker.getInstance().addMarker(this)
    customView = view
    scheduleUpdate()
  }

  fun removeCustomView(index: Int) {
    customView = null
    ViewChangesTracker.getInstance().removeMarker(this)
    recycleBitmap()
    isImageSetFromSubview = false
    setImageWithLastImage()
    super.removeView(children.elementAt(index))
  }

  override fun requestLayout() {
    super.requestLayout()
    if (childCount == 0 && customView != null) {
      customView = null
      updateCustomView()
    }
  }

  override fun update(width: Int, height: Int) {
    scheduleUpdate()
  }

  override fun skipTryRender(): Boolean = isImageSetFromSubview

  override fun updateCustomForTracking(): Boolean = true

  override fun setOverlayAlpha(alpha: Float) {
    overlay.alpha = alpha
  }

  override fun setOverlayImage(image: OverlayImage?) {
    overlay.icon = image ?: OverlayImage.fromBitmap(
      Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
    )
  }
}
