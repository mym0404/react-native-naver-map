package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPathManagerDelegate
import com.facebook.react.viewmanagers.RNCNaverMapPathManagerInterface

abstract class RNCNaverMapPathManagerSpec<T : ViewGroup> : SimpleViewManager<T>(),
    RNCNaverMapPathManagerInterface<T> {
    private val mDelegate: ViewManagerDelegate<T>

    init {
        mDelegate = RNCNaverMapPathManagerDelegate(this)
    }

    override fun getDelegate(): ViewManagerDelegate<T>? {
        return mDelegate
    }
}
