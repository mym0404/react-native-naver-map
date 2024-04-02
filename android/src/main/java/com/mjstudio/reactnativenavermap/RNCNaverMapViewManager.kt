package com.mjstudio.reactnativenavermap

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.RNCNaverMapViewEvent
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewWrapper
import com.naver.maps.map.NaverMap.MapType.Basic
import com.naver.maps.map.NaverMap.MapType.Hybrid
import com.naver.maps.map.NaverMap.MapType.Navi
import com.naver.maps.map.NaverMap.MapType.NaviHybrid
import com.naver.maps.map.NaverMap.MapType.None
import com.naver.maps.map.NaverMap.MapType.Satellite
import com.naver.maps.map.NaverMap.MapType.Terrain
import com.naver.maps.map.NaverMapOptions

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
            RNCNaverMapViewEvent.values().forEach {
                put(it.eventName, mapOf("registrationName" to it.eventName))
            }
        }

    override fun setMapType(view: RNCNaverMapViewWrapper?, value: String?) {
        view?.mapView?.setMapType(
            when (value) {
                "Basic" -> Basic
                "Navi" -> Navi
                "Satellite" -> Satellite
                "Hybrid" -> Hybrid
                "Terrain" -> Terrain
                "NaviHybrid" -> NaviHybrid
                "None" -> None
                else -> Basic
            }
        )
    }

    override fun setLayerGroups(view: RNCNaverMapViewWrapper?, value: ReadableArray?) {
        value?.also { arr ->
            arrayOf(
                "BUILDING", "TRAFFIC", "TRANSIT", "BICYCLE", "MOUNTAIN", "CADASTRAL",
            ).forEach {
                var isEnabled = false
                for (i in 0 until value.size()) {
                    if (arr.getString(i) == it) {
                        isEnabled = true
                    }
                }
                view?.mapView?.enableLayerGroup(it, isEnabled)
            }

        }
    }

    companion object {
        const val NAME = "RNCNaverMapView"
    }
}
