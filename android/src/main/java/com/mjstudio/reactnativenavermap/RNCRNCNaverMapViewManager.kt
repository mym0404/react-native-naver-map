package com.mjstudio.reactnativenavermap

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewWrapper
import com.naver.maps.map.NaverMapOptions

@ReactModule(name = RNCRNCNaverMapViewManager.NAME)
class RNCRNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {

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

    override fun setNightMode(view: RNCNaverMapViewWrapper?, value: Boolean) {
        view?.setNightMode(value)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> {
        return (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
            put()
        }
    }

    companion object {
        const val NAME = "NaverMapView"
    }
}
