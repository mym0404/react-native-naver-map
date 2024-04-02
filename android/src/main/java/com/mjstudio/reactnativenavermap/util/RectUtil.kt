package com.mjstudio.reactnativenavermap.util

import android.graphics.Rect
import com.facebook.react.bridge.ReadableMap

object RectUtil {
    fun getRect(padding: ReadableMap?, density: Float): Rect? {
        var left = 0
        var top = 0
        var right = 0
        var bottom = 0
        if (padding != null) {
            if (padding.hasKey("left")) {
                left = Math.round(padding.getDouble("left").toFloat() * density)
            }
            if (padding.hasKey("top")) {
                top = Math.round(padding.getDouble("top").toFloat() * density)
            }
            if (padding.hasKey("right")) {
                right = Math.round(padding.getDouble("right").toFloat() * density)
            }
            if (padding.hasKey("bottom")) {
                bottom = Math.round(padding.getDouble("bottom").toFloat() * density)
            }
            return Rect(left, top, right, bottom)
        }
        return null
    }
}

