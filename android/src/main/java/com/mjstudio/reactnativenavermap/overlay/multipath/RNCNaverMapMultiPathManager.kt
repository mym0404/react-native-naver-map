package com.mjstudio.reactnativenavermap.overlay.multipath

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapMultiPathManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.MultipartPathOverlay

class RNCNaverMapMultiPathManager : RNCNaverMapMultiPathManagerSpec<RNCNaverMapMultiPath>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapMultiPath = RNCNaverMapMultiPath(context)

  override fun onDropViewInstance(view: RNCNaverMapMultiPath) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapMultiPath?.withOverlay(fn: (MultipartPathOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapMultiPath?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapMultiPath?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapMultiPath?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapMultiPath?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "coordParts")
  override fun setCoordParts(
    view: RNCNaverMapMultiPath?,
    value: ReadableArray?,
  ) {
    val coordParts =
      value?.toArrayList()?.map { coordPart ->
        (coordPart as? ArrayList<*>)?.map { coord ->
          (coord as Map<String, *>).getLatLng()
        } ?: listOf()
      } ?: listOf()
    view?.setCoordParts(coordParts)
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "colorParts")
  override fun setColorParts(
    view: RNCNaverMapMultiPath?,
    value: ReadableArray?,
  ) {
    val colorParts =
      value?.toArrayList()?.map { colorPart ->
        val colorMap = colorPart as Map<String, *>
        MultipartPathOverlay.ColorPart(
          colorMap["color"] as? Int ?: android.graphics.Color.BLACK,
          colorMap["passedColor"] as? Int ?: android.graphics.Color.BLACK,
          colorMap["outlineColor"] as? Int ?: android.graphics.Color.BLACK,
          colorMap["passedOutlineColor"] as? Int ?: android.graphics.Color.BLACK,
        )
      } ?: listOf()
    view?.setColorParts(colorParts)
  }

  @ReactProp(name = "width")
  override fun setWidth(
    view: RNCNaverMapMultiPath?,
    value: Double,
  ) = view.withOverlay {
    it.width = value.px
  }

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(
    view: RNCNaverMapMultiPath?,
    value: Double,
  ) = view.withOverlay {
    it.outlineWidth = value.px
  }

  @ReactProp(name = "patternImage")
  override fun setPatternImage(
    view: RNCNaverMapMultiPath?,
    value: ReadableMap?,
  ) {
    view?.setImage(value)
  }

  @ReactProp(name = "patternInterval")
  override fun setPatternInterval(
    view: RNCNaverMapMultiPath?,
    value: Int,
  ) = view.withOverlay {
    it.patternInterval = value
  }

  @ReactProp(name = "isHideCollidedSymbols")
  override fun setIsHideCollidedSymbols(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedSymbols = value
  }

  @ReactProp(name = "isHideCollidedMarkers")
  override fun setIsHideCollidedMarkers(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedMarkers = value
  }

  @ReactProp(name = "isHideCollidedCaptions")
  override fun setIsHideCollidedCaptions(
    view: RNCNaverMapMultiPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedCaptions = value
  }

  companion object {
    const val NAME = "RNCNaverMapMultiPath"
  }
}
