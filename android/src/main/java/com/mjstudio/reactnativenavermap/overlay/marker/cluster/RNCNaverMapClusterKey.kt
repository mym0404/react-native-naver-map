package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.clustering.ClusteringKey

internal data class RNCNaverMapClusterKey(
  val identifier: String,
  val latlng: LatLng,
  val image: Map<*, *>? = null,
  val width: Double?,
  val height: Double?,
  val holder: RNCNaverMapLeafMarkerHolder,
) : ClusteringKey {
  override fun getPosition(): LatLng = latlng
}
