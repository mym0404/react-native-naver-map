package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager

abstract class NaverMapViewManagerSpec<T : View> : SimpleViewManager<T>() {}
