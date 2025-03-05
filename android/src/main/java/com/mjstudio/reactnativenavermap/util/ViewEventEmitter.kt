package com.mjstudio.reactnativenavermap.util

import com.facebook.react.bridge.ReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.events.Event

internal fun <T : Event<*>> ReactContext.emitEvent(
  reactTag: Int,
  callback: (surfaceId: Int, reactTag: Int) -> T,
) {
  val surfaceId = UIManagerHelper.getSurfaceId(this)
  UIManagerHelper
    .getEventDispatcherForReactTag(this, reactTag)
    ?.dispatchEvent(callback(surfaceId, reactTag))
}
