package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.naver.maps.map.overlay.OverlayImage

internal data class RNCNaverMapClusterCaption(
  val usesDefaultText: Boolean,
  val text: String,
  val requestedWidth: Double,
  val align: Int,
  val offset: Double,
  val color: Int,
  val haloColor: Int,
  val textSize: Double,
  val minZoom: Double,
  val maxZoom: Double,
)

internal data class RNCNaverMapClusterDataHolder internal constructor(
  val width: Double?,
  val height: Double?,
  val caption: RNCNaverMapClusterCaption,
) {
  var image: OverlayImage? = null
}
