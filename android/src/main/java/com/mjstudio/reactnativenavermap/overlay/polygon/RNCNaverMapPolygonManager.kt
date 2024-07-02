package com.mjstudio.reactnativenavermap.overlay.polygon

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapPolygonManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.PolygonOverlay

class RNCNaverMapPolygonManager : RNCNaverMapPolygonManagerSpec<RNCNaverMapPolygon>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapPolygon = RNCNaverMapPolygon(context)

  override fun onDropViewInstance(view: RNCNaverMapPolygon) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapPolygon?.withOverlay(fn: (PolygonOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapPolygon?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapPolygon?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapPolygon?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapPolygon?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapPolygon?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapPolygon?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapPolygon?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "geometries")
  override fun setGeometries(
    view: RNCNaverMapPolygon?,
    value: ReadableMap?,
  ) = view.withOverlay {
    it.coords = value?.getArray("coords")?.toArrayList()?.map { coord ->
      (coord as Map<String, *>).getLatLng()
    } ?: listOf()

    value?.getArray("holes")?.toArrayList()?.run {
      it.holes =
        this
          .filter { hole ->
            (hole is List<*>) && hole.size >= 3
          }.map { hole ->
            (hole as List<*>).map { coord ->
              (coord as Map<String, *>).getLatLng()
            }
          }
    }
  }

  @ReactProp(name = "color")
  override fun setColor(
    view: RNCNaverMapPolygon?,
    value: Int,
  ) = view.withOverlay {
    it.color = value
  }

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(
    view: RNCNaverMapPolygon?,
    value: Double,
  ) = view.withOverlay {
    it.outlineWidth = value.px
  }

  @ReactProp(name = "outlineColor")
  override fun setOutlineColor(
    view: RNCNaverMapPolygon?,
    value: Int,
  ) = view.withOverlay {
    it.outlineColor = value
  }

  // region PROPS

  companion object {
    const val NAME = "RNCNaverMapPolygon"
  }
}
