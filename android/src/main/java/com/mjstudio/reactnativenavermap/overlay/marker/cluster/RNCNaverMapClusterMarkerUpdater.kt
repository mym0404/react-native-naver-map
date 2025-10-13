package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.image.getOverlayImage
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.clustering.ClusterMarkerInfo
import com.naver.maps.map.clustering.DefaultClusterMarkerUpdater
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Marker.SIZE_AUTO
import com.naver.maps.map.util.MarkerIcons

internal class RNCNaverMapClusterMarkerUpdater(
  private val holder: RNCNaverMapClusterDataHolder,
) : DefaultClusterMarkerUpdater() {
  override fun updateClusterMarker(
    info: ClusterMarkerInfo,
    marker: Marker,
  ) {
    super.updateClusterMarker(info, marker)
    val (_, image, width, height) = holder
    marker.width = width?.px ?: SIZE_AUTO
    marker.height = height?.px ?: SIZE_AUTO
    if (image != null) {
      marker.alpha = 0f
      getOverlayImage(holder.imageHolder, holder.context, image) {
        marker.icon = it ?: MarkerIcons.GREEN
        marker.alpha = 1f
      }
    } else {
      marker.alpha = 1f
    }
  }
}
