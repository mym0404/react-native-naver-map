package com.mjstudio.reactnativenavermap

import android.graphics.PointF
import android.view.View
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
import com.mjstudio.reactnativenavermap.util.CameraAnimationUtil
import com.mjstudio.reactnativenavermap.util.RectUtil
import com.mjstudio.reactnativenavermap.util.getDoubleOrNull
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.MathUtils.clamp
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMap.MapType.Basic
import com.naver.maps.map.NaverMap.MapType.Hybrid
import com.naver.maps.map.NaverMap.MapType.Navi
import com.naver.maps.map.NaverMap.MapType.NaviHybrid
import com.naver.maps.map.NaverMap.MapType.None
import com.naver.maps.map.NaverMap.MapType.Satellite
import com.naver.maps.map.NaverMap.MapType.Terrain
import com.naver.maps.map.NaverMapOptions
import debugE
import kotlin.math.roundToInt


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
            put(
                NaverMapInitializeEvent.EVENT_NAME,
                mapOf("registrationName" to NaverMapInitializeEvent.EVENT_NAME)
            )
            put(
                NaverMapOptionChangeEvent.EVENT_NAME,
                mapOf("registrationName" to NaverMapOptionChangeEvent.EVENT_NAME)
            )
        }

    private fun RNCNaverMapViewWrapper?.withMapView(callback: (mapView: RNCNaverMapView) -> Unit) {
        this?.mapView?.run(callback)
    }

    private fun RNCNaverMapViewWrapper?.withMap(callback: (map: NaverMap) -> Unit) {
        this?.mapView?.withMap(callback)
    }

    private fun View?.px(dp: Double) =
        ((this?.resources?.displayMetrics?.density ?: 1f) * dp).roundToInt()

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
    override fun setLayerGroups(view: RNCNaverMapViewWrapper?, value: ReadableArray?) =
        view.withMap { map ->
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
    override fun setIsNightModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.isNightModeEnabled = value
        }

    @ReactProp(name = "isLiteModeEnabled", defaultBoolean = false)
    override fun setIsLiteModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.isLiteModeEnabled = value
        }

    @ReactProp(name = "lightness", defaultDouble = 0.0)
    override fun setLightness(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.lightness = clamp(value, -1.0, 1.0).toFloat()
    }

    @ReactProp(name = "buildingHeight", defaultDouble = 1.0)
    override fun setBuildingHeight(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.buildingHeight = clamp(value, 0.0, 1.0).toFloat()
    }

    @ReactProp(name = "symbolScale", defaultDouble = 1.0)
    override fun setSymbolScale(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.symbolScale = clamp(value, 0.0, 2.0).toFloat()
    }

    @ReactProp(name = "symbolPerspectiveRatio", defaultDouble = 1.0)
    override fun setSymbolPerspectiveRatio(view: RNCNaverMapViewWrapper?, value: Double) =
        view.withMap {
            it.symbolPerspectiveRatio = clamp(value, 0.0, 1.0).toFloat()
        }

    @ReactProp(name = "center")
    override fun setCenter(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMap {
        value.getLatLng()?.also { latlng ->
            val zoom = value.getDoubleOrNull("zoom") ?: it.cameraPosition.zoom
            val tilt = value.getDoubleOrNull("tilt") ?: it.cameraPosition.tilt
            val bearing = value.getDoubleOrNull("bearing") ?: it.cameraPosition.bearing

            it.cameraPosition = CameraPosition(
                latlng,
                zoom,
                tilt,
                bearing,
            )
        }
    }

    @ReactProp(name = "mapPadding")
    override fun setMapPadding(view: RNCNaverMapViewWrapper?, value: ReadableMap?) =
        view.withMapView {
            RectUtil.getRect(value, it.resources.displayMetrics.density, defaultValue = 0.0)?.run {
                it.withMap { map ->
                    debugE(this)
                    map.setContentPadding(left, top, right, bottom)
                }
            }
        }

    @ReactProp(name = "minZoom", defaultDouble = -1.0)
    override fun setMinZoom(view: RNCNaverMapViewWrapper?, value: Double) {
        if (value < 0) return
        view.withMap {
            it.minZoom = value
        }
    }

    @ReactProp(name = "maxZoom", defaultDouble = -1.0)
    override fun setMaxZoom(view: RNCNaverMapViewWrapper?, value: Double) {
        if (value < 0) return
        view.withMap {
            it.maxZoom = value
        }
    }

    // endregion

    // region COMMANDS
    override fun screenToCoordinate(view: RNCNaverMapViewWrapper?, x: Double, y: Double) =
        view.withMap {}


    override fun coordinateToScreen(
        view: RNCNaverMapViewWrapper?,
        latitude: Double,
        longitude: Double
    ) = view.withMap { }


    override fun animateCameraTo(
        view: RNCNaverMapViewWrapper?,
        latitude: Double,
        longitude: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    ) = view.withMap {
        CameraUpdate.scrollTo(LatLng(latitude, longitude))
            .animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
            .pivot(
                PointF(pivotX.toFloat(), pivotY.toFloat())
            ).run {
                it.moveCamera(this)
            }
    }

    override fun animateCameraBy(
        view: RNCNaverMapViewWrapper?,
        latitudeDelta: Double,
        longitudeDelta: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    ) = view.withMap {
        CameraUpdate.scrollBy(
            PointF(
                view.px(latitudeDelta).toFloat(),
                view.px(longitudeDelta).toFloat()
            )
        )
            .animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
            .pivot(
                PointF(pivotX.toFloat(), pivotY.toFloat())
            ).run {
                it.moveCamera(this)
            }
    }

    override fun animateZoom(
        view: RNCNaverMapViewWrapper?,
        latitudeDelta: Double,
        longitudeDelta: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    ) {
        TODO("Not yet implemented")
    }

    override fun animateCameraFitBounds(
        view: RNCNaverMapViewWrapper?,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    ) {
        TODO("Not yet implemented")
    }

    override fun cancelAnimation(view: RNCNaverMapViewWrapper?) {
        TODO("Not yet implemented")
    }

    companion object {
        const val NAME = "RNCNaverMapView"
    }
}
