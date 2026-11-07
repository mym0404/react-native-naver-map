package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.mjstudio.reactnativenavermap.util.getAlign
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.clustering.ClusterMarkerInfo
import com.naver.maps.map.clustering.DefaultClusterMarkerUpdater
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Marker.SIZE_AUTO

internal class RNCNaverMapClusterMarkerUpdater(
  private val holder: RNCNaverMapClusterDataHolder,
  private val onTap: ((List<String>) -> Unit)?,
) : DefaultClusterMarkerUpdater() {
  override fun updateClusterMarker(
    info: ClusterMarkerInfo,
    marker: Marker,
  ) {
    super.updateClusterMarker(info, marker)
    val defaultOnClickListener = marker.onClickListener
    val (width, height, caption) = holder
    marker.width = width?.px ?: SIZE_AUTO
    marker.height = height?.px ?: SIZE_AUTO
    holder.image?.let { marker.icon = it }
    marker.captionText = if (caption.usesDefaultText) info.size.toString() else caption.text
    marker.captionRequestedWidth = caption.requestedWidth.px
    marker.setCaptionAligns(getAlign(caption.align))
    marker.captionOffset = caption.offset.px
    marker.captionColor = caption.color
    marker.captionHaloColor = caption.haloColor
    marker.captionTextSize = caption.textSize.toFloat()
    marker.captionMinZoom = caption.minZoom
    marker.captionMaxZoom = caption.maxZoom

    if (onTap != null) {
      val markerIdentifiers = (info.tag as RNCNaverMapClusterTag).markerIdentifiers
      marker.setOnClickListener { overlay ->
        onTap.invoke(markerIdentifiers)
        defaultOnClickListener?.onClick(overlay) ?: false
      }
    }
  }
}
