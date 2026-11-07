package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.UiThreadUtil
import com.mjstudio.reactnativenavermap.util.image.createDraweeHierarchy
import com.mjstudio.reactnativenavermap.util.image.getOverlayImage
import com.naver.maps.map.NaverMap
import com.naver.maps.map.clustering.Clusterer
import com.naver.maps.map.util.MarkerIcons

internal data class RNCNaverMapLeafDataHolder internal constructor(
  val identifier: String,
  val clusterer: Clusterer<RNCNaverMapClusterKey>,
  private val context: ReactApplicationContext,
  val markers: List<RNCNaverMapLeafMarkerHolder>,
  private val clusterDataHolder: RNCNaverMapClusterDataHolder,
) {
  private var imageHolder: DraweeHolder<GenericDraweeHierarchy>? = null
  private var isActive = true

  fun attach(
    map: NaverMap,
    hasImage: Boolean,
    image: Map<*, *>?,
    isCurrent: () -> Boolean,
  ) {
    if (!hasImage) {
      if (isActive && isCurrent()) {
        clusterer.map = map
      }
      return
    }

    val holder =
      DraweeHolder.create(createDraweeHierarchy(context.resources), context).apply {
        onAttach()
      }
    imageHolder = holder
    getOverlayImage(holder, context, image) { loadedImage ->
      val attachClusterer = {
        if (isActive && isCurrent()) {
          clusterDataHolder.image = loadedImage ?: MarkerIcons.GREEN
          clusterer.map = map
        }
      }
      if (UiThreadUtil.isOnUiThread()) {
        attachClusterer()
      } else {
        UiThreadUtil.runOnUiThread { attachClusterer() }
      }
    }
  }

  fun onDetach() {
    isActive = false
    imageHolder?.onDetach()
    imageHolder = null
    markers.forEach { it.onDetach() }
    clusterer.map = null
  }
}
