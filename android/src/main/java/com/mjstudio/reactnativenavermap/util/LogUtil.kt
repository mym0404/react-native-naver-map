package com.mjstudio.reactnativenavermap.util

import android.util.Log
import com.mjstudio.reactnativenavermap.BuildConfig

private fun debugE(
  tag: String,
  message: Any?,
) {
  if (BuildConfig.DEBUG) Log.e(tag, "⭐️" + message.toString())
}

internal fun debugE(vararg message: Any?) {
  var str = ""
  for (i in message) {
    str += i.toString() + ", "
  }
  debugE("RNCNaverMapView", str)
}
