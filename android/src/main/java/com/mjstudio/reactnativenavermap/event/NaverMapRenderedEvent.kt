package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapRenderedEvent(
  surfaceId: Int,
  viewId: Int,
  private val isFullyRendered: Boolean,
  private val isRenderingStable: Boolean,
) : Event<NaverMapRenderedEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putBoolean("isFullyRendered", isFullyRendered)
      putBoolean("isRenderingStable", isRenderingStable)
    }

  companion object {
    const val EVENT_NAME = "topMapRendered"
  }
}
