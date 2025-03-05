package com.mjstudio.reactnativenavermap.util

import android.content.Context
import androidx.annotation.CallSuper
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReadableMap
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.OverlayImage

abstract class RNCNaverMapImageRenderableOverlay<T : Overlay>(
  private val context: Context,
) : RNCNaverMapOverlay<T>(context) {
  private val imageHolder: DraweeHolder<GenericDraweeHierarchy>? by lazy {
    DraweeHolder.create(createDraweeHierarchy(resources), context)?.apply {
      onAttach()
    }
  }
  private var imageRequestCanceller: ImageRequestCanceller? = null
  private var lastImage: ReadableMap? = null

  @CallSuper
  override fun onDropViewInstance() {
    imageHolder?.onDetach()
    imageRequestCanceller?.invoke()
  }

  protected abstract fun setOverlayAlpha(alpha: Float)

  protected abstract fun setOverlayImage(image: OverlayImage?)

  protected open fun skipTryRender() = false

  protected fun setImageWithLastImage() {
    setImage(lastImage)
  }

  fun setImage(image: ReadableMap?) {
    lastImage = image
    if (skipTryRender()) return
    setOverlayAlpha(0f)
    imageRequestCanceller?.invoke()
    imageRequestCanceller =
      getOverlayImage(imageHolder!!, context, image?.toHashMap()) {
        setOverlayImage(it)
        setOverlayAlpha(1f)
      }
  }
}
