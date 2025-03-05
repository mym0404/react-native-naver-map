package com.mjstudio.reactnativenavermap.overlay.ground

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapGroundManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLngBoundsOrNull
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.GroundOverlay

class RNCNaverMapGroundManager : RNCNaverMapGroundManagerSpec<RNCNaverMapGround>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapGround = RNCNaverMapGround(context)

  override fun onDropViewInstance(view: RNCNaverMapGround) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapGround?.withOverlay(fn: (GroundOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapGround?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapGround?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapGround?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapGround?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapGround?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapGround?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapGround?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @ReactProp(name = "image")
  override fun setImage(
    view: RNCNaverMapGround?,
    value: ReadableMap?,
  ) {
    view?.setImage(value)
  }

  @ReactProp(name = "region")
  override fun setRegion(
    view: RNCNaverMapGround?,
    value: ReadableMap?,
  ) = view.withOverlay {
    value?.getLatLngBoundsOrNull()?. run {
      it.bounds = this
    }
  }

  // region PROPS

  companion object {
    const val NAME = "RNCNaverMapGround"
  }
}
