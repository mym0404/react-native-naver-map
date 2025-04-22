package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPolylineManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPolylineManagerInterface

abstract class RNCNaverMapPolylineManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapPolylineManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapPolylineManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
