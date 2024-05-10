package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager

internal interface RNCNaverMapArrowheadPathManagerInterface<T : View?> {
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

  fun setCoords(
    view: T,
    value: ReadableArray?,
  )

  fun setWidth(
    view: T,
    value: Double,
  )

  fun setOutlineWidth(
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

  fun setHeadSizeRatio(
    view: T,
    value: Double,
  )
}

abstract class RNCNaverMapArrowheadPathManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapArrowheadPathManagerInterface<T?>
