package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapArrowheadPathManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapArrowheadPathManagerInterface

abstract class RNCNaverMapArrowheadPathManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapArrowheadPathManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapArrowheadPathManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
