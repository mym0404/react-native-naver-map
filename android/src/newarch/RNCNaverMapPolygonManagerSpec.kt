package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPolygonManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPolygonManagerInterface

abstract class RNCNaverMapPolygonManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapPolygonManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapPolygonManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
