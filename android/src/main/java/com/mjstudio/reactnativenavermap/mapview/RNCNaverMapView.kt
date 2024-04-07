package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.view.View
import android.view.ViewGroup
import com.airbnb.android.react.maps.ViewAttacherGroup
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapCameraChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
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

    private var attacherGroup: ViewAttacherGroup? = null
    private var map: NaverMap? = null
    private var isAttached = false
    val overlays = mutableListOf<RNCNaverMapOverlay<*>>()


    private val reactTag: Int
        get() = RNCNaverMapViewWrapper.getReactTagFromMapView(this)

    var isInitialCameraOrRegionSet = false

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

        // Set up a parent view for triggering visibility in subviews that depend on it.
        // Mainly ReactImageView depends on Fresco which depends on onVisibilityChanged() event
        attacherGroup = ViewAttacherGroup(reactContext)
        val attacherLayoutParams = LayoutParams(0, 0)
        attacherLayoutParams.width = 0
        attacherLayoutParams.height = 0
        attacherLayoutParams.leftMargin = 99999999
        attacherLayoutParams.topMargin = 99999999
        attacherGroup!!.setLayoutParams(attacherLayoutParams)
        addView(attacherGroup)
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

    fun addOverlay(child: View, index: Int) = withMap { map ->
        if (child is RNCNaverMapOverlay<*> && attacherGroup != null) {
            child.addToMap(map)
            overlays.add(index, child)
            val visibility: Int = child.visibility
            child.visibility = INVISIBLE
            (child.parent as? ViewGroup)?.removeView(child)
            // Add to the parent group
            attacherGroup!!.addView(child)
            child.visibility = visibility
        }
    }

    override fun onDestroy() {
        removeAllViews()
        overlays.forEach {
            if (map != null) {
                it.removeFromMap(map!!)
            }
        }
        overlays.clear()
        map = null
        attacherGroup = null
        super.onDestroy()
    }


    fun removeOverlay(index: Int) = withMap { map ->
        val overlay = overlays.removeAt(index)
        overlay.removeFromMap(map)
        attacherGroup?.removeView(overlay)
    }
}
