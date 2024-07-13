package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReactApplicationContext
import com.mjstudio.reactnativenavermap.util.image.createDraweeHierarchy
import com.naver.maps.geometry.LatLng

internal data class RNCNaverMapLeafMarkerHolder(
  val identifier: String,
  val latlng: LatLng,
  val context: ReactApplicationContext,
  val image: Map<*, *>? = null,
  val width: Double?,
  val height: Double?,
  val onTapLeaf: (() -> Unit)?,
) {
  val imageHolder: DraweeHolder<GenericDraweeHierarchy> by lazy {
    DraweeHolder.create(createDraweeHierarchy(context.resources), context).apply {
      onAttach()
    }
  }

  fun onDetach() {
    imageHolder.onDetach()
  }
}
