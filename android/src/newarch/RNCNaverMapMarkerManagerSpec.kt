package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapMarkerManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapMarkerManagerInterface

abstract class RNCNaverMapMarkerManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(),
  RNCNaverMapMarkerManagerInterface<T?> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = RNCNaverMapMarkerManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
