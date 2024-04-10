package com.mjstudio.reactnativenavermap.mapview

import android.graphics.PointF
import android.view.Gravity
import android.view.View
import com.airbnb.android.react.maps.SizeReportingShadowNode
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.LayoutShadowNode
import com.facebook.react.uimanager.PixelUtil
import com.facebook.react.uimanager.ReactStylesDiffMap
import com.facebook.react.uimanager.StateWrapper
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapViewManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapCameraChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapTapEvent
import com.mjstudio.reactnativenavermap.util.CameraAnimationUtil
import com.mjstudio.reactnativenavermap.util.RectUtil
import com.mjstudio.reactnativenavermap.util.getDoubleOrNull
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.getLatLngBoundsOrNull
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMap.LAYER_GROUP_BICYCLE
import com.naver.maps.map.NaverMap.LAYER_GROUP_BUILDING
import com.naver.maps.map.NaverMap.LAYER_GROUP_CADASTRAL
import com.naver.maps.map.NaverMap.LAYER_GROUP_MOUNTAIN
import com.naver.maps.map.NaverMap.LAYER_GROUP_TRAFFIC
import com.naver.maps.map.NaverMap.LAYER_GROUP_TRANSIT
import com.naver.maps.map.NaverMap.MapType.Basic
import com.naver.maps.map.NaverMap.MapType.Hybrid
import com.naver.maps.map.NaverMap.MapType.Navi
import com.naver.maps.map.NaverMap.MapType.NaviHybrid
import com.naver.maps.map.NaverMap.MapType.None
import com.naver.maps.map.NaverMap.MapType.Satellite
import com.naver.maps.map.NaverMap.MapType.Terrain
import com.naver.maps.map.NaverMapOptions


class RNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {
    override fun getName(): String {
        return NAME
    }

    private var initialMapOptions: NaverMapOptions? = null

    override fun createViewInstance(
        reactTag: Int,
        reactContext: ThemedReactContext,
        initialProps: ReactStylesDiffMap?,
        stateWrapper: StateWrapper?
    ): RNCNaverMapViewWrapper {
        initialMapOptions = NaverMapOptions().useTextureView(
            initialProps?.getBoolean("isUseTextureViewAndroid", false) ?: false
        )
        return super.createViewInstance(reactTag, reactContext, initialProps, stateWrapper)
    }


    override fun createViewInstance(reactContext: ThemedReactContext): RNCNaverMapViewWrapper {
        return RNCNaverMapViewWrapper(reactContext, initialMapOptions ?: NaverMapOptions()).also {
            reactContext.addLifecycleEventListener(it)
        }
    }

    override fun onDropViewInstance(view: RNCNaverMapViewWrapper) {
        super.onDropViewInstance(view)
        view.onDropViewInstance()
        view.reactContext.removeLifecycleEventListener(view)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
        (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
            registerDirectEvent(this, NaverMapInitializeEvent.EVENT_NAME)
            registerDirectEvent(this, NaverMapOptionChangeEvent.EVENT_NAME)
            registerDirectEvent(this, NaverMapCameraChangeEvent.EVENT_NAME)
            registerDirectEvent(this, NaverMapTapEvent.EVENT_NAME)
        }

    private fun RNCNaverMapViewWrapper?.withMapView(callback: (mapView: RNCNaverMapView) -> Unit) {
        this?.mapView?.run(callback)
    }

    private fun RNCNaverMapViewWrapper?.withMap(callback: (map: NaverMap) -> Unit) {
        this?.mapView?.withMap(callback)
    }

    override fun needsCustomLayoutForChildren(): Boolean = true

    override fun addView(parent: RNCNaverMapViewWrapper?, child: View, index: Int) {
        parent?.withMapView {
            it.addOverlay(child, index)
        }
    }

    override fun getChildCount(parent: RNCNaverMapViewWrapper): Int {
        return parent.mapView?.overlays?.size ?: 0
    }

    override fun getChildAt(parent: RNCNaverMapViewWrapper?, index: Int): View? {
        return parent?.mapView?.overlays?.get(index)
    }

    override fun removeViewAt(parent: RNCNaverMapViewWrapper?, index: Int) {
        parent?.withMapView {
            it.removeOverlay(index)
        }
    }

    override fun createShadowNodeInstance(): LayoutShadowNode {
        // A custom shadow node is needed in order to pass back the width/height of the map to the
        // view manager so that it can start applying camera moves with bounds.
        return SizeReportingShadowNode()
    }

    // region PROPS

    @ReactProp(name = "mapType")
    override fun setMapType(view: RNCNaverMapViewWrapper?, value: String?) {
        view.withMap {
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
    }

    @ReactProp(name = "layerGroups")
    override fun setLayerGroups(view: RNCNaverMapViewWrapper?, value: Int) = view.withMap {
        val building = value and (1 shl 0) != 0
        val traffic = value and (1 shl 1) != 0
        val transit = value and (1 shl 2) != 0
        val bicycle = value and (1 shl 3) != 0
        val mountain = value and (1 shl 4) != 0
        val cadastral = value and (1 shl 5) != 0

        if (it.isLayerGroupEnabled(LAYER_GROUP_BUILDING) != building) {
            it.setLayerGroupEnabled(LAYER_GROUP_BUILDING, building)
        }

        if (it.isLayerGroupEnabled(LAYER_GROUP_TRAFFIC) != traffic) {
            it.setLayerGroupEnabled(LAYER_GROUP_TRAFFIC, traffic)
        }

        if (it.isLayerGroupEnabled(LAYER_GROUP_TRANSIT) != transit) {
            it.setLayerGroupEnabled(LAYER_GROUP_TRANSIT, transit)
        }

        if (it.isLayerGroupEnabled(LAYER_GROUP_BICYCLE) != bicycle) {
            it.setLayerGroupEnabled(LAYER_GROUP_BICYCLE, bicycle)
        }
        if (it.isLayerGroupEnabled(LAYER_GROUP_MOUNTAIN) != mountain) {
            it.setLayerGroupEnabled(LAYER_GROUP_MOUNTAIN, mountain)
        }

        if (it.isLayerGroupEnabled(LAYER_GROUP_CADASTRAL) != cadastral) {
            it.setLayerGroupEnabled(LAYER_GROUP_CADASTRAL, cadastral)
        }
    }

    @ReactProp(name = "initialCamera")
    override fun setInitialCamera(view: RNCNaverMapViewWrapper?, value: ReadableMap?) =
        view.withMapView {
            if (!it.isInitialCameraOrRegionSet) {
                if (isValidNumber(value?.getDoubleOrNull("latitude"))) {
                    it.isInitialCameraOrRegionSet = true
                    setCamera(view, value)
                }
            }
        }

    @ReactProp(name = "camera")
    override fun setCamera(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMap {
        value?.getLatLng()?.also { latlng ->
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


    @ReactProp(name = "initialRegion")
    override fun setInitialRegion(view: RNCNaverMapViewWrapper?, value: ReadableMap?) {
        if (isValidNumber(value?.getDoubleOrNull("latitude"))) {
            view.withMapView {
                if (!it.isInitialCameraOrRegionSet) {
                    it.isInitialCameraOrRegionSet = true
                    setRegion(view, value)
                }
            }
        }
    }

    @ReactProp(name = "region")
    override fun setRegion(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMap {
        value.getLatLngBoundsOrNull()?.run {
            val update = CameraUpdate.fitBounds(this)
            it.moveCamera(update)
        }
    }

    @ReactProp(name = "isIndoorEnabled")
    override fun setIsIndoorEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.isIndoorEnabled = value
    }

    @ReactProp(name = "isNightModeEnabled")
    override fun setIsNightModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.isNightModeEnabled = value
        }

    @ReactProp(name = "isLiteModeEnabled")
    override fun setIsLiteModeEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.isLiteModeEnabled = value
        }

    @ReactProp(name = "lightness")
    override fun setLightness(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.lightness = value.toFloat()
    }

    @ReactProp(name = "buildingHeight")
    override fun setBuildingHeight(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.buildingHeight = value.toFloat()
    }

    @ReactProp(name = "symbolScale")
    override fun setSymbolScale(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.symbolScale = value.toFloat()
    }

    @ReactProp(name = "symbolPerspectiveRatio")
    override fun setSymbolPerspectiveRatio(view: RNCNaverMapViewWrapper?, value: Double) =
        view.withMap {
            it.symbolPerspectiveRatio = value.toFloat()
        }

    @ReactProp(name = "mapPadding")
    override fun setMapPadding(view: RNCNaverMapViewWrapper?, value: ReadableMap?) =
        view.withMapView {
            RectUtil.getRect(value, it.resources.displayMetrics.density, defaultValue = 0.0)?.run {
                it.withMap { map ->
                    map.setContentPadding(left, top, right, bottom)
                }
            }
        }


    @ReactProp(name = "minZoom")
    override fun setMinZoom(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.minZoom = value
    }

    @ReactProp(name = "maxZoom")
    override fun setMaxZoom(view: RNCNaverMapViewWrapper?, value: Double) = view.withMap {
        it.maxZoom = value
    }

    @ReactProp(name = "isShowCompass")
    override fun setIsShowCompass(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.uiSettings.isCompassEnabled = value
    }

    @ReactProp(name = "isShowScaleBar")
    override fun setIsShowScaleBar(view: RNCNaverMapViewWrapper?, value: Boolean) = view.withMap {
        it.uiSettings.isScaleBarEnabled = value
    }

    @ReactProp(name = "isShowZoomControls")
    override fun setIsShowZoomControls(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.uiSettings.isZoomControlEnabled = value
        }

    @ReactProp(name = "isShowIndoorLevelPicker")
    override fun setIsShowIndoorLevelPicker(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap {
            it.uiSettings.isIndoorLevelPickerEnabled = value
        }

    @ReactProp(name = "isShowLocationButton")
    override fun setIsShowLocationButton(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMapView {
            it.setupLocationSource()
            it.withMap { map ->
                map.uiSettings.isLocationButtonEnabled = value
            }
        }

    @ReactProp(name = "logoAlign")
    override fun setLogoAlign(view: RNCNaverMapViewWrapper?, value: String?) = view.withMap {
        it.uiSettings.logoGravity = when (value) {
            "TopLeft" -> Gravity.TOP or Gravity.LEFT
            "TopRight" -> Gravity.TOP or Gravity.RIGHT
            "BottomRight" -> Gravity.BOTTOM or Gravity.RIGHT
            else -> Gravity.BOTTOM or Gravity.LEFT
        }
    }

    @ReactProp(name = "logoMargin")
    override fun setLogoMargin(view: RNCNaverMapViewWrapper?, value: ReadableMap?) =
        view.withMapView {
            RectUtil.getRect(value, it.resources.displayMetrics.density, defaultValue = 0.0)?.run {
                it.withMap { map ->
                    map.uiSettings.setLogoMargin(left, top, right, bottom)
                }
            }
        }

    @ReactProp(name = "extent")
    override fun setExtent(view: RNCNaverMapViewWrapper?, value: ReadableMap?) = view.withMap {
        value.getLatLngBoundsOrNull()?.run {
            it.extent = this
        }
    }

    @ReactProp(name = "isScrollGesturesEnabled")
    override fun setIsScrollGesturesEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap { it.uiSettings.isScrollGesturesEnabled = value }

    @ReactProp(name = "isZoomGesturesEnabled")
    override fun setIsZoomGesturesEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap { it.uiSettings.isZoomGesturesEnabled = value }

    @ReactProp(name = "isTiltGesturesEnabled")
    override fun setIsTiltGesturesEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap { it.uiSettings.isTiltGesturesEnabled = value }

    @ReactProp(name = "isRotateGesturesEnabled")
    override fun setIsRotateGesturesEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap { it.uiSettings.isRotateGesturesEnabled = value }

    @ReactProp(name = "isStopGesturesEnabled")
    override fun setIsStopGesturesEnabled(view: RNCNaverMapViewWrapper?, value: Boolean) =
        view.withMap { it.uiSettings.isStopGesturesEnabled = value }

    @ReactProp(name = "isUseTextureViewAndroid")
    override fun setIsUseTextureViewAndroid(view: RNCNaverMapViewWrapper?, value: Boolean) {
        // don't implement this
    }
    // endregion

    // region COMMANDS
    override fun screenToCoordinate(view: RNCNaverMapViewWrapper?, x: Double, y: Double) =
        view.withMap {}


    override fun coordinateToScreen(
        view: RNCNaverMapViewWrapper?, latitude: Double, longitude: Double
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
                PixelUtil.toPixelFromDIP(latitudeDelta),
                PixelUtil.toPixelFromDIP(longitudeDelta),
            )
        ).animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
            .pivot(
                PointF(pivotX.toFloat(), pivotY.toFloat())
            ).run {
                it.moveCamera(this)
            }
    }

    override fun animateRegionTo(
        view: RNCNaverMapViewWrapper?,
        latitude: Double,
        longitude: Double,
        latitudeDelta: Double,
        longitudeDelta: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    ) = view.withMap {
        CameraUpdate.fitBounds(
            LatLngBounds(
                LatLng(latitude, longitude),
                LatLng(latitude + latitudeDelta, longitude + longitudeDelta)
            )
        ).animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
            .pivot(
                PointF(pivotX.toFloat(), pivotY.toFloat())
            ).run {
                it.moveCamera(this)
            }
    }

    override fun cancelAnimation(view: RNCNaverMapViewWrapper?) = view.withMap {
        it.cancelTransitions()
    }


    companion object {
        const val NAME = "RNCNaverMapView"
    }
}
