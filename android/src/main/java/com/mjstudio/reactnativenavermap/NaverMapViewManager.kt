package com.mjstudio.reactnativenavermap

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = NaverMapViewManager.NAME)
class NaverMapViewManager :
  NaverMapViewManagerSpec<NaverMapView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): NaverMapView {
    return NaverMapView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: NaverMapView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "NaverMapView"
  }
}
