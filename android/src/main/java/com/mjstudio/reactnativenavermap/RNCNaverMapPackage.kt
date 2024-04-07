package com.mjstudio.reactnativenavermap

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewManager
import com.mjstudio.reactnativenavermap.overlay.circle.RNCNaverMapCircleManager
import com.mjstudio.reactnativenavermap.overlay.marker.RNCNaverMapMarkerManager
import com.mjstudio.reactnativenavermap.overlay.path.RNCNaverMapPathManager
import com.mjstudio.reactnativenavermap.overlay.polygon.RNCNaverMapPolygonManager
import com.mjstudio.reactnativenavermap.overlay.polyline.RNCNaverMapPolylineManager

class NaverMapViewPackage : ReactPackage {
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return mutableListOf<ViewManager<*, *>>().apply {
            add(RNCNaverMapViewManager())
            add(RNCNaverMapMarkerManager())
            add(RNCNaverMapCircleManager())
            add(RNCNaverMapPolygonManager())
            add(RNCNaverMapPolylineManager())
            add(RNCNaverMapPathManager())
        }
    }

    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return emptyList()
    }

}
