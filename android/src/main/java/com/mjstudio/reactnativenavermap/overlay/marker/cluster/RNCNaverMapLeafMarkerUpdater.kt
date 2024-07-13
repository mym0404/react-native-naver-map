package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.image.getOverlayImage
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.clustering.DefaultLeafMarkerUpdater
import com.naver.maps.map.clustering.LeafMarkerInfo
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Marker.SIZE_AUTO
import com.naver.maps.map.util.MarkerIcons

internal class RNCNaverMapLeafMarkerUpdater : DefaultLeafMarkerUpdater() {
  override fun updateLeafMarker(
    info: LeafMarkerInfo,
    marker: Marker,
  ) {
    super.updateLeafMarker(info, marker)

    (info.key as? RNCNaverMapClusterKey)?.let { (holder) ->
      val (_, _, _, image, width, height) = holder

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

      marker.setOnClickListener {
        if (holder.onTapLeaf == null) {
          return@setOnClickListener false
        }
        holder.onTapLeaf.invoke()
        true
      }
    }
  }
}
