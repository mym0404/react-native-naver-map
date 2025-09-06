package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapOptionChangeEvent(
  surfaceId: Int,
  viewId: Int,
  private val locationTrackingMode: String,
) : Event<NaverMapOptionChangeEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putString("locationTrackingMode", locationTrackingMode)
    }

  companion object {
    const val EVENT_NAME = "topOptionChanged"
  }
}
