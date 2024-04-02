package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class RNCNaverMapView(private val reactContext: ThemedReactContext, private val mapOptions: NaverMapOptions) :
    MapView(reactContext, mapOptions) {

    private var map: NaverMap? = null
    private var isAttached = false

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
