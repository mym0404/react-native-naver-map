package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapInfoWindowManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapInfoWindowManagerInterface

abstract class RNCNaverMapInfoWindowManagerSpec<T : View> : SimpleViewManager<T>(),
  RNCNaverMapInfoWindowManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapInfoWindowManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T> = mDelegate
}

