package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import androidx.fragment.app.FragmentContainerView
import com.facebook.react.uimanager.ThemedReactContext
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class NaverMapView(private val reactContext: ThemedReactContext, private val mapOptions: NaverMapOptions) :
    MapView(reactContext, mapOptions) {

    private var map: NaverMap? = null

    init {
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()

        val lp = LayoutParams(MATCH_PARENT, MATCH_PARENT)
        val view = FragmentContainerView(context)
        addView(view)
    }
}
