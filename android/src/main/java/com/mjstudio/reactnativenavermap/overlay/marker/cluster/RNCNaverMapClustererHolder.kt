package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReactApplicationContext
import com.mjstudio.reactnativenavermap.util.image.createDraweeHierarchy
import com.naver.maps.map.clustering.Clusterer

internal data class RNCNaverMapClustererHolder internal constructor(
  val identifier: String,
  val clusterer: Clusterer<RNCNaverMapClusterKey>,
  val context: ReactApplicationContext,
  val markers: List<RNCNaverMapLeafMarkerHolder>,
) {
  private val imageHolder: DraweeHolder<GenericDraweeHierarchy> by lazy {
    DraweeHolder.create(createDraweeHierarchy(context.resources), context).apply {
      onAttach()
    }
  }

  fun onDetach() {
    markers.forEach { it.onDetach() }
    clusterer.map = null
    imageHolder.onDetach()
  }
}
