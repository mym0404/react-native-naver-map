package com.mjstudio.reactnativenavermap.util.image

import android.content.Context
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReadableMap
import com.naver.maps.map.overlay.OverlayImage

internal class RNCNaverMapTaggedImageRenderer(private val context: Context) {
  private var imageHolder: DraweeHolder<GenericDraweeHierarchy>? = null
  private var lastImage: ReadableMap? = null

  fun onAttach() {
    imageHolder =
      DraweeHolder.create(createDraweeHierarchy(context.resources), context)?.apply {
        onAttach()
      }
  }

  fun onDetach() {
    imageHolder?.onDetach()
  }

  fun setImage(
    image: ReadableMap?,
    onImageLoaded: (OverlayImage?) -> Unit,
  ) {
    lastImage = image
    getOverlayImage(imageHolder!!, context, image?.toHashMap(), onImageLoaded)
  }
}
