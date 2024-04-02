package com.mjstudio.reactnativenavermap

import android.view.View
import android.view.ViewGroup
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewGroupManager

abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> : ViewGroupManager<T>() {}
