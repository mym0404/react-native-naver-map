package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager

internal interface RNCNaverMapCircleManagerInterface<T : View?> {
  fun setCoord(
    view: T,
    value: ReadableMap?,
  )

  fun setZIndexValue(
    view: T,
    value: Int,
  )

  fun setGlobalZIndexValue(
    view: T,
    value: Int,
  )

  fun setIsHidden(
    view: T,
    value: Boolean,
  )

  fun setMinZoom(
    view: T,
    value: Double,
  )

  fun setMaxZoom(
    view: T,
    value: Double,
  )

  fun setIsMinZoomInclusive(
    view: T,
    value: Boolean,
  )

  fun setIsMaxZoomInclusive(
    view: T,
    value: Boolean,
  )

  fun setRadius(
    view: T,
    value: Double,
  )

  fun setColor(
    view: T,
    value: Int,
  )

  fun setOutlineColor(
    view: T,
    value: Int,
  )

  fun setOutlineWidth(
    view: T,
    value: Double,
  )
}

abstract class RNCNaverMapCircleManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapCircleManagerInterface<T?>
