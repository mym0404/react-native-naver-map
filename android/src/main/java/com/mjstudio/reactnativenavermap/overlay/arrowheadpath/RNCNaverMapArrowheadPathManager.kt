package com.mjstudio.reactnativenavermap.overlay.arrowheadpath

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapArrowheadPathManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.ArrowheadPathOverlay

class RNCNaverMapArrowheadPathManager : RNCNaverMapArrowheadPathManagerSpec<RNCNaverMapArrowheadPath>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapArrowheadPath = RNCNaverMapArrowheadPath(context)

  override fun onDropViewInstance(view: RNCNaverMapArrowheadPath) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapArrowheadPath?.withOverlay(fn: (ArrowheadPathOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapArrowheadPath?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapArrowheadPath?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapArrowheadPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapArrowheadPath?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapArrowheadPath?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapArrowheadPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapArrowheadPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "coords")
  override fun setCoords(
    view: RNCNaverMapArrowheadPath?,
    value: ReadableArray?,
  ) = view.withOverlay {
    it.coords = value?.toArrayList()?.map { coord ->
      (coord as Map<String, *>).getLatLng()
    } ?: listOf()
  }

  @ReactProp(name = "width")
  override fun setWidth(
    view: RNCNaverMapArrowheadPath?,
    value: Double,
  ) = view.withOverlay {
    it.width = value.px
  }

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(
    view: RNCNaverMapArrowheadPath?,
    value: Double,
  ) = view.withOverlay {
    it.outlineWidth = value.px
  }

  @ReactProp(name = "color")
  override fun setColor(
    view: RNCNaverMapArrowheadPath?,
    value: Int,
  ) = view.withOverlay {
    it.color = value
  }

  @ReactProp(name = "outlineColor")
  override fun setOutlineColor(
    view: RNCNaverMapArrowheadPath?,
    value: Int,
  ) = view.withOverlay {
    it.outlineColor = value
  }

  @ReactProp(name = "headSizeRatio")
  override fun setHeadSizeRatio(
    view: RNCNaverMapArrowheadPath?,
    value: Double,
  ) = view.withOverlay {
    it.headSizeRatio = value.toFloat()
  }

  // region PROPS

  companion object {
    const val NAME = "RNCNaverMapArrowheadPath"
  }
}
