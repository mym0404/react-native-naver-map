package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapCameraChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapTapEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.naver.maps.map.CameraUpdate.REASON_CONTROL
import com.naver.maps.map.CameraUpdate.REASON_GESTURE
import com.naver.maps.map.CameraUpdate.REASON_LOCATION
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class RNCNaverMapView(
    private val reactContext: ThemedReactContext,
    private val mapOptions: NaverMapOptions
) :
    MapView(reactContext, mapOptions) {

    private var map: NaverMap? = null
    private var isAttached = false
    var isInitialCameraOrRegionSet = false

    private val reactTag: Int
        get() = RNCNaverMapViewWrapper.getReactTagFromMapView(this)

    init {
        getMapAsync {
            map = it
            reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
                NaverMapInitializeEvent(surfaceId, reactTag)
            }


            it.addOnOptionChangeListener {
                reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
                    NaverMapOptionChangeEvent(surfaceId, reactTag)
                }
            }

            it.addOnCameraChangeListener { reason, animated ->
                reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
                    NaverMapCameraChangeEvent(
                        surfaceId,
                        reactTag,
                        it.cameraPosition.target.latitude,
                        it.cameraPosition.target.longitude,
                        it.cameraPosition.zoom,
                        it.cameraPosition.tilt,
                        it.cameraPosition.bearing,
                        when (reason) {
                            REASON_GESTURE -> 1
                            REASON_CONTROL -> 2
                            REASON_LOCATION -> 3
                            else -> 0
                        },
                    )
                }
            }

            it.setOnMapClickListener { pointF, latLng ->
                reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
                    NaverMapTapEvent(
                        surfaceId,
                        reactTag,
                        latLng.latitude,
                        latLng.longitude,
                        pointF.x.toDouble(),
                        pointF.y.toDouble(),
                    )
                }
            }
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        isAttached = true
    }

    override fun onDetachedFromWindow() {
        isAttached = false
        super.onDetachedFromWindow()
    }

    fun withMap(callback: (map: NaverMap) -> Unit) {
        map?.also(callback) ?: run { getMapAsync(callback) }
    }
}
