package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapCustomStyleLoadFailedEvent(
  surfaceId: Int,
  viewTag: Int,
  private val message: String,
) : Event<NaverMapCustomStyleLoadFailedEvent>(surfaceId, viewTag) {
  companion object {
    const val EVENT_NAME = "onCustomStyleLoadFailed"
  }

  override fun getEventName(): String = EVENT_NAME

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putString("message", message)
    }
}
