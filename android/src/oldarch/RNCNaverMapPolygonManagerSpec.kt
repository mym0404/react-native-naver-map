package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager


internal interface RNCNaverMapPolygonManagerInterface<T : View?> {
    fun setZIndexValue(view: T, value: Int)
    fun setIsHidden(view: T, value: Boolean)
    fun setMinZoom(view: T, value: Double)
    fun setMaxZoom(view: T, value: Double)
    fun setIsMinZoomInclusive(view: T, value: Boolean)
    fun setIsMaxZoomInclusive(view: T, value: Boolean)
    fun setGeometries(view: T, value: ReadableMap?)
    fun setColor(view: T, value: Int)
    fun setOutlineColor(view: T, value: Int)
    fun setOutlineWidth(view: T, value: Double)
}


abstract class RNCNaverMapPolygonManagerSpec<T : View> : SimpleViewManager<T>(),
    RNCNaverMapPolygonManagerInterface<T?>
