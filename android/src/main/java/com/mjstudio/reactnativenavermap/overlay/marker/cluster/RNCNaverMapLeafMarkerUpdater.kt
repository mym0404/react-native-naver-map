package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.ImageRequestCanceller
import com.mjstudio.reactnativenavermap.util.getOverlayImage
import com.mjstudio.reactnativenavermap.util.px
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
    (info.key as? RNCNaverMapClusterKey)?.let {
        (
          id, _,
          image, width, height, holder,
        ),
      ->
      if (width != null) {
        marker.width = width.px
      }
      if (height != null) {
        marker.height = height.px
      }
      if (image != null) {
        marker.alpha = 0f
        imageRequestCanceller =
          getOverlayImage(holder.imageHolder, holder.context, image) {
            marker.icon = it ?: MarkerIcons.GREEN
            marker.alpha = 1f
          }
      } else {
        marker.alpha = 1f
      }
    }
  }
}
