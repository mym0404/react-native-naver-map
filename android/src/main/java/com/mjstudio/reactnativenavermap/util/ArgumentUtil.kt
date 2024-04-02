package com.mjstudio.reactnativenavermap.util

import com.facebook.react.bridge.ReadableMap
import com.naver.maps.geometry.LatLng

fun ReadableMap?.getLatLng(): LatLng? {
    val latitude = this?.getDouble("latitude")
    val longitude = this?.getDouble("longitude")
    if (latitude != null && longitude != null) {
        return LatLng(latitude, longitude)
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