package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class NaverMapCameraChangeEvent(
  surfaceId: Int,
  viewId: Int,
  private val latitude: Double,
  private val longitude: Double,
  private val zoom: Double,
  private val tilt: Double,
  private val bearing: Double,
  private val reason: Int,
  private val regionLatitude: Double,
  private val regionLongitude: Double,
  private val regionLatitudeDelta: Double,
  private val regionLongitudeDelta: Double,
) : Event<NaverMapCameraChangeEvent>(surfaceId, viewId) {
  override fun getEventName(): String = EVENT_NAME

  override fun canCoalesce(): Boolean = false

  override fun getCoalescingKey(): Short = 0

  override fun getEventData(): WritableMap =
    Arguments.createMap().apply {
      putDouble("latitude", latitude)
      putDouble("longitude", longitude)
      putDouble("zoom", zoom)
      putDouble("tilt", tilt)
      putDouble("bearing", bearing)
      putInt("reason", reason)
      putDouble("regionLatitude", regionLatitude)
      putDouble("regionLongitude", regionLongitude)
      putDouble("regionLatitudeDelta", regionLatitudeDelta)
      putDouble("regionLongitudeDelta", regionLongitudeDelta)
    }

  companion object {
    const val EVENT_NAME = "topCameraChanged"
  }
}
