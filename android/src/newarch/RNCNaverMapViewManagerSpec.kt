package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapViewManagerInterface

abstract class RNCNaverMapViewManagerSpec<T : View> : SimpleViewManager<T>(), RNCNaverMapViewManagerInterface<T> {
    private val mDelegate: ViewManagerDelegate<T>

    init {
        mDelegate = RNCNaverMapViewManagerDelegate(this)
    }

    override fun getDelegate(): ViewManagerDelegate<T>? {
        return mDelegate
    }
}
