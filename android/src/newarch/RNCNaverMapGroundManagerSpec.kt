package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapGroundManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapGroundManagerInterface

abstract class RNCNaverMapGroundManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapGroundManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapGroundManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
