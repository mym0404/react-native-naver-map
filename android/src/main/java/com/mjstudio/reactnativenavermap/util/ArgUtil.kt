package com.mjstudio.reactnativenavermap.util

import android.graphics.PointF
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.PixelUtil
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.overlay.Align

internal fun ReadableMap?.getLatLng(): LatLng? {
  val latitude = this?.getDoubleOrNull("latitude")
  val longitude = this?.getDoubleOrNull("longitude")
  if (isValidNumber(latitude) && isValidNumber(longitude)) {
    return LatLng(latitude!!, longitude!!)
  }
  return null
}

internal fun Map<String, *>.getLatLng(): LatLng? {
  val latitude = getValue("latitude")
  val longitude = getValue("longitude")
  if (isValidNumber(latitude) && isValidNumber(longitude)) {
    return LatLng((latitude as Number).toDouble(), (longitude as Number).toDouble())
  }
  return null
}

internal fun ReadableMap?.getDoubleOrNull(key: String): Double? {
  if (this?.hasKey(key) == true) {
    return this.getDouble(key)
  }
  return null
}

internal fun ReadableMap.getIntOrNull(key: String): Int? {
  if (hasKey(key)) {
    return this.getInt(key)
  }
  return null
}

internal fun ReadableMap.getAlign(key: String): Align {
  if (!hasKey(key)) {
    return Align.Bottom
  }
  return when (getInt(key)) {
    0 -> Align.Center
    1 -> Align.Left
    2 -> Align.Right
    3 -> Align.Top
    5 -> Align.TopLeft
    6 -> Align.TopRight
    7 -> Align.BottomRight
    8 -> Align.BottomLeft
    else -> Align.Bottom
  }
}

internal fun ReadableMap?.getLatLngBoundsOrNull(): LatLngBounds? = getRegion()?.convertToBounds()

internal fun ReadableMap?.getRegion(): RNCNaverMapRegion? {
  if (this?.hasKey("latitude") == true &&
    this.hasKey("longitude") &&
    this.hasKey("latitudeDelta") &&
    this.hasKey(
      "longitudeDelta",
    )
  ) {
    val lat = getDouble("latitude")
    val lng = getDouble("longitude")
    val latDelta = getDouble("latitudeDelta")
    val lngDelta = getDouble("longitudeDelta")
    if (!isValidNumber(lat)) return null
    return RNCNaverMapRegion(lat, lng, latDelta, lngDelta)
  }
  return null
}

internal fun ReadableMap?.getPoint(): PointF? {
  if (this?.hasKey("x") == true && this.hasKey("y")) {
    val x = getDouble("x")
    val y = getDouble("y")
    return PointF(x.toFloat(), y.toFloat())
  }
  return null
}

internal fun isValidNumber(value: Double?): Boolean {
  if (value == null) return false
  val invalid = -123123123.0
  return !(value < invalid + 1 && value > invalid - 1)
}

internal fun isValidNumber(value: Int?): Boolean {
  if (value == null) return false
  return isValidNumber(value.toDouble())
}

internal fun isValidNumber(value: Any?): Boolean {
  if (value == null || value !is Number) return false
  return isValidNumber(value.toDouble())
}

internal val Double?.px: Int
  get() = if (this == null) 0 else PixelUtil.toPixelFromDIP(this).toInt()
internal val Int?.px: Int
  get() = if (this == null) 0 else PixelUtil.toPixelFromDIP(toDouble()).toInt()
internal val Double?.dp: Int
  get() = if (this == null) 0 else PixelUtil.toDIPFromPixel(toFloat()).toInt()
internal val Int?.dp: Int
  get() = if (this == null) 0 else PixelUtil.toDIPFromPixel(toFloat()).toInt()
internal val Float?.dp: Int
  get() = if (this == null) 0 else PixelUtil.toDIPFromPixel(this).toInt()
