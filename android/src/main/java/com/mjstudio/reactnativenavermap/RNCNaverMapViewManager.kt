package com.mjstudio.reactnativenavermap

import androidx.core.math.MathUtils.clamp
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapView
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewWrapper
import com.mjstudio.reactnativenavermap.util.RectUtil
import com.mjstudio.reactnativenavermap.util.getDoubleOrNull
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMap.MapType.Basic
import com.naver.maps.map.NaverMap.MapType.Hybrid
import com.naver.maps.map.NaverMap.MapType.Navi
import com.naver.maps.map.NaverMap.MapType.NaviHybrid
import com.naver.maps.map.NaverMap.MapType.None
import com.naver.maps.map.NaverMap.MapType.Satellite
import com.naver.maps.map.NaverMap.MapType.Terrain
import com.naver.maps.map.NaverMapOptions

@ReactModule(name = RNCNaverMapViewManager.NAME)
class RNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {
    override fun getName(): String {
        return NAME
    }

    override fun createViewInstance(context: ThemedReactContext): RNCNaverMapViewWrapper {
        return RNCNaverMapViewWrapper(context, NaverMapOptions()).also {
            context.addLifecycleEventListener(it)
        }
    }

    override fun onDropViewInstance(view: RNCNaverMapViewWrapper) {
        super.onDropViewInstance(view)
        view.onDropViewInstance()
        view.reactContext.removeLifecycleEventListener(view)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
        (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
            put(NaverMapInitializeEvent.EVENT_NAME, mapOf("registrationName" to NaverMapInitializeEvent.EVENT_NAME))
            put(NaverMapOptionChangeEvent.EVENT_NAME, mapOf("registrationName" to NaverMapOptionChangeEvent.EVENT_NAME))
        }

    private fun RNCNaverMapViewWrapper?.withMapView(callback: (mapView: RNCNaverMapView) -> Unit) {
        this?.mapView?.run(callback)
    }

    private fun RNCNaverMapViewWrapper?.withMap(callback: (map: NaverMap) -> Unit) {
        this?.mapView?.withMap(callback)
    }

    override fun needsCustomLayoutForChildren(): Boolean = true

    // region PROPS

    @ReactProp(name = "mapType")
    override fun setMapType(view: RNCNaverMapViewWrapper?, value: String?) = view.withMap {
        it.mapType = when (value) {
            "Basic" -> Basic
            "Navi" -> Navi
            "Satellite" -> Satellite
            "Hybrid" -> Hybrid
            "Terrain" -> Terrain
            "NaviHybrid" -> NaviHybrid
            "None" -> None
            else -> Basic
        }
    }

    @ReactProp(name = "layerGroups")
    override fun setLayerGroups(view: RNCNaverMapViewWrapper?, value: ReadableArray?) = view.withMap { map ->
        (value ?: Arguments.createArray().apply { pushString("BUILDING") }).also { arr ->
            arrayOf(
                "BUILDING", "TRAFFIC", "TRANSIT", "BICYCLE", "MOUNTAIN", "CADASTRAL",
            ).forEach {
                var isEnabled = false
                for (i in 0 until arr.size()) {
                    if (arr.getString(i) == it) {
                        isEnabled = true
                    }
                }
                map.setLayerGroupEnabled("LAYER_GROUP_$it", isEnabled)
            }
        }
    }

    @ReactProp(name = "isIndoorEnabled", defaultBoolean = true)
    override fun setIsIndoorEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.isIndoorEnabled = value
    }

    @ReactProp(name = "isNightModeEnabled", defaultBoolean = false)
    override fun setIsNightModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.isNightModeEnabled = value
    }

    @ReactProp(name = "isLiteModeEnabled", defaultBoolean = false)
    override fun setIsLiteModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.isLiteModeEnabled = value
    }

    @ReactProp(name = "lightness", defaultFloat = 0f)
    override fun setLightness(view: RNCNaverMapViewWrapper?, value: Float) = view.withMap {
        it.lightness = clamp(value, -1f, 1f)
    }

    @ReactProp(name = "buildingHeight", defaultFloat = 1f)
    override fun setBuildingHeight(view: RNCNaverMapViewWrapper?, value: Float) = view.withMap {
        it.buildingHeight = clamp(value, 0f, 1f)
    }

    @ReactProp(name = "symbolScale", defaultFloat = 1f)
    override fun setSymbolScale(view: RNCNaverMapViewWrapper?, value: Float) = view.withMap {
        it.symbolScale = clamp(value, 0f, 2f)
    }

    @ReactProp(name = "symbolPerspectiveRatio", defaultFloat = 1f)
    override fun setSymbolPerspectiveRatio(view: RNCNaverMapViewWrapper?, value: Float) = view.withMap {
        it.symbolPerspectiveRatio = clamp(value, 0f, 1f)
    }

    @ReactProp(name = "center")
    override fun setCenter(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMap {
        value.getLatLng()?.also { latlng ->
            val zoom = value.getDoubleOrNull("zoom") ?: 16.0
            val tilt = value.getDoubleOrNull("tilt")
            val bearing = value.getDoubleOrNull("bearing")

            it.cameraPosition = if (tilt != null && bearing != null) CameraPosition(
                latlng,
                zoom,
                tilt,
                bearing,
            ) else if ((tilt == null) != (bearing == null)) CameraPosition(
                latlng,
                zoom,
                tilt ?: 20.0,
                bearing ?: 180.0
            ) else CameraPosition(latlng, zoom)
        }
    }

    @ReactProp(name = "mapPadding")
    override fun setMapPadding(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMapView {
        RectUtil.getRect(value, it.resources.displayMetrics.density)?.run {
            it.withMap { map ->
                map.setContentPadding(left, top, right, bottom)
            }
        }
    }

    // endregion

    companion object {
        const val NAME = "RNCNaverMapView"
    }
}
