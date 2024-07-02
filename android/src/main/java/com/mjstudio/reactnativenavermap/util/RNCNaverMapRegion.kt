package com.mjstudio.reactnativenavermap.util

import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds

internal data class RNCNaverMapRegion(
  val latitude: Double,
  val longitude: Double,
  val latitudeDelta: Double,
  val longitudeDelta: Double,
) {
  fun convertToBounds(): LatLngBounds =
    LatLngBounds(
      LatLng(latitude, longitude),
      LatLng(
        latitude + latitudeDelta,
        longitude + longitudeDelta,
      ),
    )
}
