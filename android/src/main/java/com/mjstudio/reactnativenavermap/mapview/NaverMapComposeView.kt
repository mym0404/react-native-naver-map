package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.view.Choreographer
import android.view.Choreographer.FrameCallback
import android.widget.FrameLayout
import com.facebook.react.uimanager.ThemedReactContext
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class NaverMapComposeView(private val context: ThemedReactContext, private val mapOptions: NaverMapOptions) :
    FrameLayout(context) {
    private val mapView by lazy { NaverMapView(context, mapOptions) }

    init {
        addView(mapView)
    }

    fun setNightMode(value: Boolean) {

    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        mapView.onStart()
    }

    override fun onDetachedFromWindow() {

        super.onDetachedFromWindow()
    }

    // https://github.com/facebook/react-native/issues/17968#issuecomment-457236577
    private fun setupLayoutHack() {
        Choreographer.getInstance().postFrameCallback(object : FrameCallback {
            override fun doFrame(frameTimeNanos: Long) {
                manuallyLayoutChildren()
                getViewTreeObserver().dispatchOnGlobalLayout()
                if (isAttachedToWindow) Choreographer.getInstance().postFrameCallbackDelayed(this, 500)
            }
        })
    }

    private fun manuallyLayoutChildren() {
        for (i in 0 until childCount) {
            val child = getChildAt(i)
            child.measure(
                MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY)
            )
            child.layout(0, 0, child.measuredWidth, child.measuredHeight)
        }
    }
}