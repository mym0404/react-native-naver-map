package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.clustering.ClusteringKey

data class RNCNaverMapClusterKey(val identifier: String, private val latlng: LatLng, val image: Map<*, *>? = null) : ClusteringKey {
  override fun getPosition(): LatLng {
    return latlng
  }
}
//
// class RNCNaverMapClusterKey(val id: Int, private val position: LatLng) : ClusteringKey {
//  override fun getPosition() = position
//
//  override fun equals(other: Any?): Boolean {
//    if (this === other) return true
//    if (other == null || javaClass != other.javaClass) return false
//    val itemKey = other as RNCNaverMapClusterKey
//    return id == itemKey.id
//  }
//
//  override fun hashCode() = id
// }
