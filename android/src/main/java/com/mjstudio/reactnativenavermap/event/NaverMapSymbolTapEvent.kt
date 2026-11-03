package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapSymbolTapEvent(
  surfaceId: Int,
  viewId: Int,
  private val caption: String,
  private val latitude: Double,
  private val longitude: Double,
) : Event<NaverMapSymbolTapEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putString("caption", caption)
      putDouble("latitude", latitude)
      putDouble("longitude", longitude)
    }

  companion object {
    const val EVENT_NAME = "topTapSymbol"
  }
}
