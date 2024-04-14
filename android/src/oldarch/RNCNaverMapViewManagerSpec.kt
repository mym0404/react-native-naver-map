package com.mjstudio.reactnativenavermap

import android.view.ViewGroup
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ViewGroupManager

internal interface RNCNaverMapViewManagerInterface<T : ViewGroup?> {
    fun setMapType(view: T, value: String?)
    fun setLayerGroups(view: T, value: Int)
    fun setInitialCamera(view: T, value: ReadableMap?)
    fun setCamera(view: T, value: ReadableMap?)
    fun setInitialRegion(view: T, value: ReadableMap?)
    fun setRegion(view: T, value: ReadableMap?)
    fun setIsIndoorEnabled(view: T, value: Boolean)
    fun setIsNightModeEnabled(view: T, value: Boolean)
    fun setIsLiteModeEnabled(view: T, value: Boolean)
    fun setLightness(view: T, value: Double)
    fun setBuildingHeight(view: T, value: Double)
    fun setSymbolScale(view: T, value: Double)
    fun setSymbolPerspectiveRatio(view: T, value: Double)
    fun setMapPadding(view: T, value: ReadableMap?)
    fun setMinZoom(view: T, value: Double)
    fun setMaxZoom(view: T, value: Double)
    fun setIsShowCompass(view: T, value: Boolean)
    fun setIsShowScaleBar(view: T, value: Boolean)
    fun setIsShowZoomControls(view: T, value: Boolean)
    fun setIsShowIndoorLevelPicker(view: T, value: Boolean)
    fun setIsShowLocationButton(view: T, value: Boolean)
    fun setLogoAlign(view: T, value: String?)
    fun setLogoMargin(view: T, value: ReadableMap?)
    fun setExtent(view: T, value: ReadableMap?)
    fun setIsScrollGesturesEnabled(view: T, value: Boolean)
    fun setIsZoomGesturesEnabled(view: T, value: Boolean)
    fun setIsTiltGesturesEnabled(view: T, value: Boolean)
    fun setIsRotateGesturesEnabled(view: T, value: Boolean)
    fun setIsUseTextureViewAndroid(view: T, value: Boolean)
    fun setIsStopGesturesEnabled(view: T, value: Boolean)
    fun setLocale(view: T, value: String?)

    fun screenToCoordinate(view: T, x: Double, y: Double)
    fun coordinateToScreen(view: T, latitude: Double, longitude: Double)
    fun animateCameraTo(
        view: T,
        latitude: Double,
        longitude: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double,
        zoom: Double,
    )

    fun animateCameraBy(
        view: T,
        x: Double,
        y: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    )

    fun animateRegionTo(
        view: T,
        latitude: Double,
        longitude: Double,
        latitudeDelta: Double,
        longitudeDelta: Double,
        duration: Int,
        easing: Int,
        pivotX: Double,
        pivotY: Double
    )

    fun cancelAnimation(view: T)

    fun setLocationTrackingMode(view: T, mode: String?)
}

abstract class RNCNaverMapViewManagerSpec<T : ViewGroup> : ViewGroupManager<T>(),
    RNCNaverMapViewManagerInterface<T?> {
    override fun receiveCommand(
        view: T,
        commandId: String?,
        _args: ReadableArray?
    ) {
        val args = _args ?: Arguments.createArray()
        when (commandId) {
            "screenToCoordinate" -> screenToCoordinate(
                view,
                args.getDouble(0),
                args.getDouble(1)
            )

            "coordinateToScreen" -> coordinateToScreen(
                view,
                args.getDouble(0),
                args.getDouble(1)
            )

            "animateCameraTo" -> animateCameraTo(
                view,
                args.getDouble(0),
                args.getDouble(1),
                args.getInt(2),
                args.getInt(3),
                args.getDouble(4),
                args.getDouble(5),
                args.getDouble(6),
            )

            "animateCameraBy" -> animateCameraBy(
                view,
                args.getDouble(0),
                args.getDouble(1),
                args.getInt(2),
                args.getInt(3),
                args.getDouble(4),
                args.getDouble(5)
            )

            "animateRegionTo" -> animateRegionTo(
                view,
                args.getDouble(0),
                args.getDouble(1),
                args.getDouble(2),
                args.getDouble(3),
                args.getInt(4),
                args.getInt(5),
                args.getDouble(6),
                args.getDouble(7)
            )

            "cancelAnimation" -> cancelAnimation(view)
        }
    }
}
