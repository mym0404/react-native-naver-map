package com.mjstudio.reactnativenavermap.overlay.marker.cluster
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReactApplicationContext
import com.mjstudio.reactnativenavermap.util.image.createDraweeHierarchy

internal data class RNCNaverMapClusterDataHolder internal constructor(
  val context: ReactApplicationContext,
  val image: Map<*, *>? = null,
  val width: Double? = null,
  val height: Double? = null,
)
{
  val imageHolder: DraweeHolder<GenericDraweeHierarchy> by lazy {
    DraweeHolder.create(createDraweeHierarchy(context.resources), context).apply {
      onAttach()
    }
  }

  fun onDetach() {
    imageHolder.onDetach()
  }
}
