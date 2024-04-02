package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.Choreographer
import android.view.Choreographer.FrameCallback
import android.widget.FrameLayout
import com.facebook.react.uimanager.ThemedReactContext
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class NaverMapComposeView(private val context: ThemedReactContext, private val mapOptions: NaverMapOptions) :
    FrameLayout(context) {
    private var mapView: NaverMapView? = null
    private var savedState: Bundle? = Bundle()

    init {
        mapView = NaverMapView(context, mapOptions)
        addView(mapView)
    }

    fun setNightMode(value: Boolean) {

    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        mapView?.onStart()
        setupLayoutHack()
    }

    override fun onDetachedFromWindow() {
        mapView?.onSaveInstanceState(savedState ?: run {
            Bundle().also { this@NaverMapComposeView.savedState = it }
        })
        super.onDetachedFromWindow()
    }

    fun onDropViewInstance() {
        mapView?.run {
            onStop()
            onDestroy()
        }
        removeAllViews()
        savedState?.clear()
        savedState = null
        mapView = null
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