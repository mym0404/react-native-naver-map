package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapCoordinateToScreenEvent(
  surfaceId: Int,
  viewId: Int,
  private val isValid: Boolean,
  private val screenX: Double,
  private val screenY: Double,
) : Event<NaverMapCoordinateToScreenEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putDouble("screenX", screenX)
      putDouble("screenY", screenY)
      putBoolean("isValid", isValid)
    }

  companion object {
    const val EVENT_NAME = "topCoordinateToScreen"
  }
}
