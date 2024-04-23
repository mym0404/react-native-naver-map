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
    if (padding != null) {
      val top = ((padding.getDoubleOrNull("top") ?: defaultValue) * density).roundToInt()
      val right = ((padding.getDoubleOrNull("right") ?: defaultValue) * density).roundToInt()
      val bottom = ((padding.getDoubleOrNull("bottom") ?: defaultValue) * density).roundToInt()
      val left = ((padding.getDoubleOrNull("left") ?: defaultValue) * density).roundToInt()
      return Rect(left, top, right, bottom)
    }
    return null
  }
}
