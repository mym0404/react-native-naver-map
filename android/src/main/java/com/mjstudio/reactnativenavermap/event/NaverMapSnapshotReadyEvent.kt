package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapSnapshotReadyEvent(
  surfaceId: Int,
  viewId: Int,
  private val uri: String,
  private val width: Int,
  private val height: Int,
) : Event<NaverMapSnapshotReadyEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putString("uri", uri)
      putInt("width", width)
      putInt("height", height)
    }

  companion object {
    const val EVENT_NAME = "topSnapshotReady"
  }
}
