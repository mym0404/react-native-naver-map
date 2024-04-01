package com.mjstudio.reactnativenavermap

import android.view.View

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.NaverMapViewManagerDelegate
import com.facebook.react.viewmanagers.NaverMapViewManagerInterface

abstract class NaverMapViewManagerSpec<T : View> : SimpleViewManager<T>(), NaverMapViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = NaverMapViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? {
    return mDelegate
  }
}
