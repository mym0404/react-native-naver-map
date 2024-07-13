package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.clustering.ClusterMarkerInfo
import com.naver.maps.map.clustering.DefaultClusterMarkerUpdater
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Marker.SIZE_AUTO

internal class RNCNaverMapClusterMarkerUpdater(
  private val holder: RNCNaverMapClusterDataHolder,
) : DefaultClusterMarkerUpdater() {
  override fun updateClusterMarker(
    info: ClusterMarkerInfo,
    marker: Marker,
  ) {
    super.updateClusterMarker(info, marker)
    val (width, height) = holder
    marker.width = width?.px ?: SIZE_AUTO
    marker.height = height?.px ?: SIZE_AUTO
  }
}
