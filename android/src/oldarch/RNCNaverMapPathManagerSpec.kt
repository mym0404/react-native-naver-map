package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager


internal interface RNCNaverMapPathManagerInterface<T : View?> {
    fun setZIndexValue(view: T, value: Int)
    fun setIsHidden(view: T, value: Boolean)
    fun setMinZoom(view: T, value: Double)
    fun setMaxZoom(view: T, value: Double)
    fun setIsMinZoomInclusive(view: T, value: Boolean)
    fun setIsMaxZoomInclusive(view: T, value: Boolean)
    fun setCoords(view: T, value: ReadableArray?)
    fun setWidth(view: T, value: Double)
    fun setOutlineWidth(view: T, value: Double)
    fun setPatternInterval(view: T, value: Int)
    fun setProgress(view: T, value: Double)
    fun setColor(view: T, value: Int)
    fun setPassedColor(view: T, value: Int)
    fun setOutlineColor(view: T, value: Int)
    fun setPassedOutlineColor(view: T, value: Int)
    fun setIsHideCollidedSymbols(view: T, value: Boolean)
    fun setIsHideCollidedMarkers(view: T, value: Boolean)
    fun setIsHideCollidedCaptions(view: T, value: Boolean)
}


abstract class RNCNaverMapPathManagerSpec<T : View> : SimpleViewManager<T>(),
    RNCNaverMapPathManagerInterface<T?>
