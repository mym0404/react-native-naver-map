package com.mjstudio.reactnativenavermap.overlay.path

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapPathManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.PathOverlay

class RNCNaverMapPathManager : RNCNaverMapPathManagerSpec<RNCNaverMapPath>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapPath = RNCNaverMapPath(context)

  override fun onDropViewInstance(view: RNCNaverMapPath) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapPath?.withOverlay(fn: (PathOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapPath?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapPath?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "coords")
  override fun setCoords(
    view: RNCNaverMapPath?,
    value: ReadableArray?,
  ) = view.withOverlay {
    it.coords = value?.toArrayList()?.map { coord ->
      (coord as Map<String, *>).getLatLng()
    } ?: listOf()
  }

  @ReactProp(name = "width")
  override fun setWidth(
    view: RNCNaverMapPath?,
    value: Double,
  ) = view.withOverlay {
    it.width = value.px
  }

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(
    view: RNCNaverMapPath?,
    value: Double,
  ) = view.withOverlay {
    it.outlineWidth = value.px
  }

  @ReactProp(name = "passedOutlineColor")
  override fun setPassedOutlineColor(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.passedOutlineColor = value
  }

  @ReactProp(name = "color")
  override fun setColor(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.color = value
  }

  @ReactProp(name = "passedColor")
  override fun setPassedColor(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.passedColor = value
  }

  @ReactProp(name = "patternImage")
  override fun setPatternImage(
    view: RNCNaverMapPath?,
    value: ReadableMap?,
  ) {
    view?.setImage(value)
  }

  @ReactProp(name = "patternInterval")
  override fun setPatternInterval(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.patternInterval = value
  }

  @ReactProp(name = "progress")
  override fun setProgress(
    view: RNCNaverMapPath?,
    value: Double,
  ) = view.withOverlay {
    it.progress = value
  }

  @ReactProp(name = "outlineColor")
  override fun setOutlineColor(
    view: RNCNaverMapPath?,
    value: Int,
  ) = view.withOverlay {
    it.outlineColor = value
  }

  @ReactProp(name = "isHideCollidedSymbols")
  override fun setIsHideCollidedSymbols(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedSymbols = value
  }

  @ReactProp(name = "isHideCollidedMarkers")
  override fun setIsHideCollidedMarkers(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedMarkers = value
  }

  @ReactProp(name = "isHideCollidedCaptions")
  override fun setIsHideCollidedCaptions(
    view: RNCNaverMapPath?,
    value: Boolean,
  ) = view.withOverlay {
    it.isHideCollidedCaptions = value
  }

  // region PROPS

  companion object {
    const val NAME = "RNCNaverMapPath"
  }
}
