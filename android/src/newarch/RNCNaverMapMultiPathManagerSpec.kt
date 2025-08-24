package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapMultiPathManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapMultiPathManagerInterface

abstract class RNCNaverMapMultiPathManagerSpec<T : ViewGroup> :
  SimpleViewManager<T>(),
  RNCNaverMapMultiPathManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T> = RNCNaverMapMultiPathManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
