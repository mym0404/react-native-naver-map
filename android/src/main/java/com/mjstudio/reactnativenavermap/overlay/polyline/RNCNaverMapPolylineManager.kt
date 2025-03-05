package com.mjstudio.reactnativenavermap.overlay.polyline

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapPolylineManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.map.overlay.PolylineOverlay

class RNCNaverMapPolylineManager : RNCNaverMapPolylineManagerSpec<RNCNaverMapPolyline>() {
  override fun getName(): String = NAME

  override fun createViewInstance(context: ThemedReactContext): RNCNaverMapPolyline = RNCNaverMapPolyline(context)

  override fun onDropViewInstance(view: RNCNaverMapPolyline) {
    super.onDropViewInstance(view)
    view.onDropViewInstance()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapOverlayTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapPolyline?.withOverlay(fn: (PolylineOverlay) -> Unit) {
    this?.overlay?.run(fn)
  }

  @ReactProp(name = "zIndexValue")
  override fun setZIndexValue(
    view: RNCNaverMapPolyline?,
    value: Int,
  ) = view.withOverlay {
    it.zIndex = value
  }

  @ReactProp(name = "globalZIndexValue")
  override fun setGlobalZIndexValue(
    view: RNCNaverMapPolyline?,
    value: Int,
  ) = view.withOverlay {
    if (isValidNumber(value)) {
      it.globalZIndex = value
    }
  }

  @ReactProp(name = "isHidden")
  override fun setIsHidden(
    view: RNCNaverMapPolyline?,
    value: Boolean,
  ) = view.withOverlay {
    it.isVisible = !value
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapPolyline?,
    value: Double,
  ) = view.withOverlay {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapPolyline?,
    value: Double,
  ) = view.withOverlay {
    it.maxZoom = value
  }

  @ReactProp(name = "isMinZoomInclusive")
  override fun setIsMinZoomInclusive(
    view: RNCNaverMapPolyline?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMinZoomInclusive = value
  }

  @ReactProp(name = "isMaxZoomInclusive")
  override fun setIsMaxZoomInclusive(
    view: RNCNaverMapPolyline?,
    value: Boolean,
  ) = view.withOverlay {
    it.isMaxZoomInclusive = value
  }

  @Suppress("UNCHECKED_CAST")
  @ReactProp(name = "coords")
  override fun setCoords(
    view: RNCNaverMapPolyline?,
    value: ReadableArray?,
  ) = view.withOverlay {
    it.coords = value?.toArrayList()?.map { coord ->
      (coord as Map<String, *>).getLatLng()
    } ?: listOf()
  }

  @ReactProp(name = "width")
  override fun setWidth(
    view: RNCNaverMapPolyline?,
    value: Double,
  ) = view.withOverlay {
    it.width = value.px
  }

  @ReactProp(name = "color")
  override fun setColor(
    view: RNCNaverMapPolyline?,
    value: Int,
  ) = view.withOverlay {
    it.color = value
  }

  @ReactProp(name = "pattern")
  override fun setPattern(
    view: RNCNaverMapPolyline?,
    value: ReadableArray?,
  ) = view.withOverlay {
    (value?.toArrayList() as? List<*>)?.run {
      it.setPattern(*this.map { (it as Number).toInt() }.toIntArray())
    }
  }

  @ReactProp(name = "capType")
  override fun setCapType(
    view: RNCNaverMapPolyline?,
    value: String?,
  ) = view.withOverlay {
    it.capType =
      when (value) {
        "Butt" -> PolylineOverlay.LineCap.Butt
        "Square" -> PolylineOverlay.LineCap.Square
        else -> PolylineOverlay.LineCap.Round
      }
  }

  @ReactProp(name = "joinType")
  override fun setJoinType(
    view: RNCNaverMapPolyline?,
    value: String?,
  ) = view.withOverlay {
    it.joinType =
      when (value) {
        "Bevel" -> PolylineOverlay.LineJoin.Bevel
        "Miter" -> PolylineOverlay.LineJoin.Miter
        else -> PolylineOverlay.LineJoin.Round
      }
  }

  // region PROPS

  companion object {
    const val NAME = "RNCNaverMapPolyline"
  }
}
