package com.mjstudio.reactnativenavermap.util

import android.graphics.Color
import android.graphics.PointF
import com.facebook.react.bridge.ReadableMap
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds

fun ReadableMap?.getLatLng(): LatLng? {
    val latitude = this?.getDoubleOrNull("latitude")
    val longitude = this?.getDoubleOrNull("longitude")
    if (isValidNumber(latitude) && isValidNumber(longitude)) {
        return LatLng(latitude!!, longitude!!)
    }
    return null
}

fun ReadableMap?.getDoubleOrNull(key: String): Double? {
    if (this?.hasKey(key) == true) {
        return this.getDouble(key)
    }
    return null
}

fun ReadableMap?.getIntOrNull(key: String): Int? {
    if (this?.hasKey(key) == true) {
        return this.getInt(key)
    }
    return null
}

fun ReadableMap?.getLatLngBoundsOrNull(): LatLngBounds? {
    return getRegion()?.convertToBounds()
}

fun ReadableMap?.getRegion(): RNCNaverMapRegion? {
    if (this?.hasKey("latitude") == true && this.hasKey("longitude") && this.hasKey("latitudeDelta") && this.hasKey(
            "longitudeDelta"
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

fun ReadableMap?.getPoint(): PointF? {
    if (this?.hasKey("x") == true && this.hasKey("y")) {
        val x = getDouble("x")
        val y = getDouble("y")
        return PointF(x.toFloat(), y.toFloat())
    }
    return null
}

fun isValidNumber(value: Double?): Boolean {
    if (value == null) return false
    val invalid = -123123123.0
    return !(value < invalid + 1 && value > invalid - 1)
}

fun isValidNumber(value: Int?): Boolean {
    if (value == null) return false
    return isValidNumber(value.toDouble())
}

fun getColorFromInt(int: Int?): Int? {
    if (int == null) return null
    return Color.argb(Color.alpha(int), Color.red(int), Color.green(int), Color.blue(int))
}