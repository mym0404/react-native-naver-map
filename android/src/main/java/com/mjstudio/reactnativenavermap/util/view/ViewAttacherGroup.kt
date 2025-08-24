package com.mjstudio.reactnativenavermap.util.view

import android.content.Context
import android.graphics.Rect
import com.facebook.react.views.view.ReactViewGroup

class ViewAttacherGroup(
  context: Context,
) : ReactViewGroup(context) {
  init {
    setWillNotDraw(true)
    visibility = VISIBLE
    alpha = 0.0f
    removeClippedSubviews = false
    clipBounds = Rect(0, 0, 0, 0)
    setOverflow("hidden") // Change to ViewProps.HIDDEN until RN 0.57 is base
  }

  // This should make it more performant, avoid trying to hard to overlap layers
  // with opacity.
  override fun hasOverlappingRendering(): Boolean = false
}
