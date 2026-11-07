package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapClusterTapEvent(
  surfaceId: Int,
  viewId: Int,
  private val clusterIndex: Int,
  private val markerIdentifiers: List<String>,
) : Event<NaverMapClusterTapEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putInt("clusterIndex", clusterIndex)
      putArray(
        "markerIdentifiers",
        Arguments.createArray().apply {
          markerIdentifiers.forEach { pushString(it) }
        },
      )
    }

  companion object {
    const val EVENT_NAME = "topTapCluster"
  }
}
