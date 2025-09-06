package com.mjstudio.reactnativenavermap.overlay.multipath

import android.graphics.Color
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
import com.naver.maps.geometry.LatLng
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

  @ReactProp(name = "pathParts")
  override fun setPathParts(
    view: RNCNaverMapMultiPath?,
    value: ReadableArray?,
  ) {
    if (value == null) {
      view?.setPathParts(emptyList(), emptyList())
      return
    }

    val coordParts = mutableListOf<List<LatLng>>()
    val colorParts = mutableListOf<MultipartPathOverlay.ColorPart>()

    for (i in 0 until value.size()) {
      val pathPartMap = value.getMap(i) ?: continue

      // Extract coordinates
      val coords = mutableListOf<LatLng>()
      pathPartMap.getArray("coords")?.let { coordsArray ->
        for (j in 0 until coordsArray.size()) {
          coordsArray.getMap(j)?.getLatLng()?.let { latLng ->
            coords.add(latLng)
          }
        }
      }
      coordParts.add(coords)

      // Extract colors
      val colorPart =
        MultipartPathOverlay.ColorPart(
          pathPartMap.getInt("color").takeIf { pathPartMap.hasKey("color") } ?: Color.BLACK,
          pathPartMap.getInt("passedColor").takeIf { pathPartMap.hasKey("passedColor") } ?: Color.BLACK,
          pathPartMap.getInt("outlineColor").takeIf { pathPartMap.hasKey("outlineColor") } ?: Color.BLACK,
          pathPartMap.getInt("passedOutlineColor").takeIf { pathPartMap.hasKey("passedOutlineColor") } ?: Color.BLACK,
        )
      colorParts.add(colorPart)
    }

    view?.setPathParts(coordParts, colorParts)
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
