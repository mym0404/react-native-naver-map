package com.mjstudio.reactnativenavermap.overlay.infowindow

import android.view.View
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapInfoWindowManagerSpec
import com.mjstudio.reactnativenavermap.module.RNCNaverMapInfoWindowRegistry

class RNCNaverMapInfoWindowManager(
  private val infoWindowRegistry: RNCNaverMapInfoWindowRegistry,
) : RNCNaverMapInfoWindowManagerSpec<RNCNaverMapInfoWindow>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapInfoWindow = RNCNaverMapInfoWindow(context, infoWindowRegistry)

  override fun onDropViewInstance(view: RNCNaverMapInfoWindow) {
    view.onDropViewInstance()
    super.onDropViewInstance(view)
  }

  override fun addView(
    parent: RNCNaverMapInfoWindow,
    child: View,
    index: Int,
  ) {
    parent.setContentView(child, index)
  }

  override fun removeViewAt(
    parent: RNCNaverMapInfoWindow,
    index: Int,
  ) {
    parent.removeContentView(index)
  }

  @ReactProp(name = "infoWindowId")
  override fun setInfoWindowId(
    view: RNCNaverMapInfoWindow,
    value: String?,
  ) {
    view.setInfoWindowId(value)
  }

  @ReactProp(name = "anchorX")
  override fun setAnchorX(
    view: RNCNaverMapInfoWindow,
    value: Double,
  ) {
    view.setAnchorX(value)
  }

  @ReactProp(name = "anchorY")
  override fun setAnchorY(
    view: RNCNaverMapInfoWindow,
    value: Double,
  ) {
    view.setAnchorY(value)
  }

  @ReactProp(name = "offsetX")
  override fun setOffsetX(
    view: RNCNaverMapInfoWindow,
    value: Double,
  ) {
    view.setOffsetX(value)
  }

  @ReactProp(name = "offsetY")
  override fun setOffsetY(
    view: RNCNaverMapInfoWindow,
    value: Double,
  ) {
    view.setOffsetY(value)
  }

  @ReactProp(name = "alpha")
  override fun setAlpha(
    view: RNCNaverMapInfoWindow,
    value: Double,
  ) {
    view.setOverlayAlpha(value)
  }

  override fun invalidateContent(view: RNCNaverMapInfoWindow) {
    view.scheduleInvalidation()
  }

  companion object {
    const val NAME = "RNCNaverMapInfoWindow"
  }
}
