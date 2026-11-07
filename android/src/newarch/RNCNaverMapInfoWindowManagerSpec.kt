package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapInfoWindowManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapInfoWindowManagerInterface

abstract class RNCNaverMapInfoWindowManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(),
  RNCNaverMapInfoWindowManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T> = RNCNaverMapInfoWindowManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<T>? = mDelegate
}
