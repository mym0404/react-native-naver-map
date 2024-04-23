package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.ImageRequestCanceller
import com.mjstudio.reactnativenavermap.util.getOverlayImage
import com.naver.maps.map.clustering.DefaultLeafMarkerUpdater
import com.naver.maps.map.clustering.LeafMarkerInfo
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.util.MarkerIcons

internal class RNCNaverMapLeafMarkerUpdater : DefaultLeafMarkerUpdater() {
  private var imageRequestCanceller: ImageRequestCanceller? = null

  override fun updateLeafMarker(
    info: LeafMarkerInfo,
    marker: Marker,
  ) {
    super.updateLeafMarker(info, marker)

    imageRequestCanceller?.invoke()
    (info.key as? RNCNaverMapClusterKey)?.let { (id, _, image, holder) ->
      imageRequestCanceller =
        getOverlayImage(holder.imageHolder, holder.context, image) {
          marker.icon = it ?: MarkerIcons.GREEN
        }
    }
  }
}
