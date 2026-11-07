package com.mjstudio.reactnativenavermap.overlay.marker.cluster

import com.naver.maps.map.clustering.Cluster
import com.naver.maps.map.clustering.TagMergeStrategy

internal data class RNCNaverMapClusterTag(
  val markerIdentifiers: List<String>,
)

internal class RNCNaverMapClusterTagMergeStrategy : TagMergeStrategy {
  override fun mergeTag(cluster: Cluster): RNCNaverMapClusterTag =
    RNCNaverMapClusterTag(
      cluster.children.flatMap { child ->
        (child.tag as RNCNaverMapClusterTag).markerIdentifiers
      },
    )
}
