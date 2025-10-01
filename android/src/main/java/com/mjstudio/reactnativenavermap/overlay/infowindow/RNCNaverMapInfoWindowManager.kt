package com.mjstudio.reactnativenavermap.overlay.infowindow

import android.graphics.PointF
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapInfoWindowManagerSpec
import com.mjstudio.reactnativenavermap.util.getAlign
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.getPoint
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.naver.maps.map.overlay.InfoWindow

class RNCNaverMapInfoWindowManager : RNCNaverMapInfoWindowManagerSpec<RNCNaverMapInfoWindow>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapInfoWindow =
    RNCNaverMapInfoWindow(context)

  override fun onDropViewInstance(view: RNCNaverMapInfoWindow) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }


  private fun RNCNaverMapInfoWindow?.withOverlay(fn: (InfoWindow) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "coord")
  override fun setCoord(
    view: RNCNaverMapInfoWindow?,
    value: ReadableMap?,
  ) {
    value.getLatLng()?.run {
      view?.setPosition(this)
    }
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapInfoWindow?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapInfoWindow?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapInfoWindow?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapInfoWindow?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapInfoWindow?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @ReactProp(name = "align")
  override fun setAlign(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) {
    // InfoWindow align will be handled when opening
    // Stored for later use when marker is attached
  }

  @ReactProp(name = "anchor")
  override fun setAnchor(
    view: RNCNaverMapInfoWindow?,
    value: ReadableMap?,
  ) = view.withOverlay {
    value.getPoint()?.run {
      it.anchor = this
    }
  }

  @ReactProp(name = "offsetX")
  override fun setOffsetX(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) = view.withOverlay {
    it.offsetX = value.px
  }

  @ReactProp(name = "offsetY")
  override fun setOffsetY(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) = view.withOverlay {
    it.offsetY = value.px
  }

  @ReactProp(name = "alpha")
  override fun setAlpha(
    view: RNCNaverMapInfoWindow?,
    value: Double,
  ) = view.withOverlay {
    it.alpha = value.toFloat()
  }

  @ReactProp(name = "text")
  override fun setText(
    view: RNCNaverMapInfoWindow?,
    value: String?,
  ) {
    view?.setText(value)
  }

  @ReactProp(name = "textSize")
  override fun setTextSize(
    view: RNCNaverMapInfoWindow?,
    value: Double,
  ) {
    view?.setTextSize(value.toFloat())
  }

  @ReactProp(name = "textColor")
  override fun setTextColor(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) {
    view?.setTextColor(value)
  }

  @ReactProp(name = "infoWindowBackgroundColor")
  override fun setInfoWindowBackgroundColor(
    view: RNCNaverMapInfoWindow?,
    value: Int,
  ) {
    view?.setInfoWindowBackgroundColor(value)
  }

  @ReactProp(name = "markerTag")
  override fun setMarkerTag(
    view: RNCNaverMapInfoWindow?,
    value: String?,
  ) {
    // This will need to be handled by finding the marker by tag
    // For now, we'll leave it for future implementation
  }

  companion object {
    const val NAME = "RNCNaverMapInfoWindow"
  }
}

