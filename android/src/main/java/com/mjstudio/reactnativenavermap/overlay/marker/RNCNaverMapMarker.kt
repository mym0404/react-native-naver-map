package com.mjstudio.reactnativenavermap.overlay.marker

import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Marker

class RNCNaverMapMarker(val reactContext: ThemedReactContext) :
    RNCNaverMapOverlay<Marker>(reactContext) {
    override val overlay: Marker by lazy {
        Marker()
    }

    override fun addToMap(map: NaverMap) {
        overlay.map = map
    }

    override fun removeFromMap(map: NaverMap) {
        overlay.map = null
    }

    override fun onDropViewInstance() {
        overlay.map = null
    }
}