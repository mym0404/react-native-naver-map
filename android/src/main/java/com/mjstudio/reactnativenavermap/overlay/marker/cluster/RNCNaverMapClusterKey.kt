package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.clustering.ClusteringKey

internal data class RNCNaverMapClusterKey(
  val holder: RNCNaverMapLeafMarkerHolder,
) : ClusteringKey {
  override fun getPosition(): LatLng = holder.latlng
}
