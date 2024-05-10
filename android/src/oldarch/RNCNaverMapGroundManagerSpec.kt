package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager

internal interface RNCNaverMapGroundManagerInterface<T : View?> {
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

  fun setImage(
    view: T,
    value: ReadableMap?,
  )

  fun setRegion(
    view: T,
    value: ReadableMap?,
  )
}

abstract class RNCNaverMapGroundManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapGroundManagerInterface<T?>
