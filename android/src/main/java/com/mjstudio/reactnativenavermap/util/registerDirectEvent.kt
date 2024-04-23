package com.mjstudio.reactnativenavermap.util

internal fun registerDirectEvent(
  map: MutableMap<String, Any>,
  name: String,
) {
  map[name] = mapOf("registrationName" to name)
}
