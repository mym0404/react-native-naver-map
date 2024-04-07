package com.mjstudio.reactnativenavermap

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewManager
import com.mjstudio.reactnativenavermap.overlay.marker.RNCNaverMapMarkerManager

class NaverMapViewPackage : ReactPackage {
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
        viewManagers.add(RNCNaverMapViewManager())
        viewManagers.add(RNCNaverMapMarkerManager())
        return viewManagers
    }

    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return emptyList()
    }

}
