package com.mjstudio.reactnativenavermap

import android.view.View
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager

internal interface RNCNaverMapPolylineManagerInterface<T : View?> {
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

  fun setColor(
    view: T,
    value: Int,
  )

  fun setPattern(
    view: T,
    value: ReadableArray?,
  )

  fun setCapType(
    view: T,
    value: String?,
  )

  fun setJoinType(
    view: T,
    value: String?,
  )
}

abstract class RNCNaverMapPolylineManagerSpec<T : View> :
  SimpleViewManager<T>(),
  RNCNaverMapPolylineManagerInterface<T?>
