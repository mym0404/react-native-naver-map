package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapTapEvent(
  surfaceId: Int,
  viewId: Int,
  private val latitude: Double,
  private val longitude: Double,
  private val x: Double,
  private val y: Double,
) : Event<NaverMapTapEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putDouble("latitude", latitude)
      putDouble("longitude", longitude)
      putDouble("x", x)
      putDouble("y", y)
    }

  companion object {
    const val EVENT_NAME = "topTapMap"
  }
}
