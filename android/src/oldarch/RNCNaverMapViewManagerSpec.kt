package com.mjstudio.reactnativenavermap

import RNCNaverMapViewManagerDelegate
import RNCNaverMapViewManagerInterface
import android.view.ViewGroup
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate

abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> : ViewGroupManager<T>(),
    RNCNaverMapViewManagerInterface<T> {
    private val mDelegate: ViewManagerDelegate<T>

    init {
        mDelegate = RNCNaverMapViewManagerDelegate(this)
    }

    override fun getDelegate(): ViewManagerDelegate<T>? {
        return mDelegate
    }
}
