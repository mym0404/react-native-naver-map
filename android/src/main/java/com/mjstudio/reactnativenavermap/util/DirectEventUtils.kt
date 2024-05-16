package com.mjstudio.reactnativenavermap.util

internal fun registerDirectEvent(
  map: MutableMap<String, Any>,
  name: String,
) {
  map[name] = mutableMapOf("registrationName" to name.replace(Regex("""^top"""), "on"))
}
