package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapCircleManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapCircleManagerInterface

abstract class RNCNaverMapCircleManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapCircleManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapCircleManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
