package com.mjstudio.reactnativenavermap.util

import android.graphics.Rect
import com.facebook.react.bridge.ReadableMap
import kotlin.math.roundToInt

internal object RectUtil {
  internal fun getRect(
    padding: ReadableMap?,
    density: Float,
    defaultValue: Double = 0.0,
  ): Rect? {
    var left = 0
    var top = 0
    var right = 0
    var bottom = 0
    if (padding != null) {
      top = ((padding.getDoubleOrNull("top") ?: defaultValue) * density).roundToInt()
      right = ((padding.getDoubleOrNull("right") ?: defaultValue) * density).roundToInt()
      bottom = ((padding.getDoubleOrNull("bottom") ?: defaultValue) * density).roundToInt()
      left = ((padding.getDoubleOrNull("left") ?: defaultValue) * density).roundToInt()
      return Rect(left, top, right, bottom)
    }
    return null
  }
}
