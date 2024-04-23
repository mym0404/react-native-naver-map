package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ViewGroupManager

internal interface RNCNaverMapMarkerManagerInterface<T : ViewGroup?> {
  fun setCoord(
    view: T,
    value: ReadableMap?,
  )

  fun setZIndexValue(
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

  fun setWidth(
    view: T,
    value: Double,
  )

  fun setHeight(
    view: T,
    value: Double,
  )

  fun setAnchor(
    view: T,
    value: ReadableMap?,
  )

  fun setAngle(
    view: T,
    value: Double,
  )

  fun setIsFlatEnabled(
    view: T,
    value: Boolean,
  )

  fun setIsIconPerspectiveEnabled(
    view: T,
    value: Boolean,
  )

  fun setAlpha(
    view: T,
    value: Double,
  )

  fun setIsHideCollidedSymbols(
    view: T,
    value: Boolean,
  )

  fun setIsHideCollidedMarkers(
    view: T,
    value: Boolean,
  )

  fun setIsHideCollidedCaptions(
    view: T,
    value: Boolean,
  )

  fun setIsForceShowIcon(
    view: T,
    value: Boolean,
  )

  fun setTintColor(
    view: T,
    value: Int,
  )

  fun setImage(
    view: T,
    value: ReadableMap?,
  )

  fun setCaption(
    view: T,
    value: ReadableMap?,
  )

  fun setSubCaption(
    view: T,
    value: ReadableMap?,
  )
}

abstract class RNCNaverMapMarkerManagerSpec<T : ViewGroup> :
  ViewGroupManager<T>(),
  RNCNaverMapMarkerManagerInterface<T?>
