package com.mjstudio.reactnativenavermap

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.mapview.NaverMapComposeView

@ReactModule(name = NaverMapViewManager.NAME)
class NaverMapViewManager : NaverMapViewManagerSpec<NaverMapComposeView>() {
    override fun getName(): String {
        return NAME
    }

    public override fun createViewInstance(context: ThemedReactContext): NaverMapComposeView {
        return NaverMapComposeView(context)
    }

    companion object {
        const val NAME = "NaverMapView"
    }

    override fun setNightMode(view: NaverMapComposeView?, value: Boolean) {
        view?.setNightMode(value)
    }
}
