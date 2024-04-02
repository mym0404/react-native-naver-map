package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.RNCNaverMapViewEvent.Initialized
import com.mjstudio.reactnativenavermap.event.emitEvent
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class RNCNaverMapView(private val reactContext: ThemedReactContext, private val mapOptions: NaverMapOptions) :
    MapView(reactContext, mapOptions) {

    private var map: NaverMap? = null
    private var isAttached = false

    val reactTag: Int
        get() = RNCNaverMapViewWrapper.getReactTagFromWebView(this)

    init {
        getMapAsync {
            if (isAttached) {
                map = it
                reactContext.emitEvent(Initialized, reactTag)
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

}
