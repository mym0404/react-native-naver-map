package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapCustomStyleLoadedEvent(
  surfaceId: Int,
  viewTag: Int,
) : Event<NaverMapCustomStyleLoadedEvent>(surfaceId, viewTag) {
  companion object {
    const val EVENT_NAME = "onCustomStyleLoaded"
  }

  override fun getEventName(): String = EVENT_NAME

  override fun getEventData(): WritableMap = Arguments.createMap()
}
