package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapViewManagerInterface

abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(),
  RNCNaverMapViewManagerInterface<T?> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
