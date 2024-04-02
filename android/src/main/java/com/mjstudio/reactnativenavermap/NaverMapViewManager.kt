package com.mjstudio.reactnativenavermap

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.mapview.NaverMapComposeView
import com.naver.maps.map.NaverMapOptions

@ReactModule(name = NaverMapViewManager.NAME)
class NaverMapViewManager : NaverMapViewManagerSpec<NaverMapComposeView>() {

    override fun getName(): String {
        return NAME
    }

    override fun createViewInstance(context: ThemedReactContext): NaverMapComposeView {
        return NaverMapComposeView(context, NaverMapOptions())
    }

    override fun onDropViewInstance(view: NaverMapComposeView) {
        super.onDropViewInstance(view)
        view.onDropViewInstance()
    }

    override fun setNightMode(view: NaverMapComposeView?, value: Boolean) {
        view?.setNightMode(value)
    }

    companion object {
        const val NAME = "NaverMapView"
    }
}
