package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.Choreographer
import android.view.Choreographer.FrameCallback
import android.view.View
import android.widget.FrameLayout
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.uimanager.ThemedReactContext
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class RNCNaverMapViewWrapper(
  val reactContext: ThemedReactContext,
  private val mapOptions: NaverMapOptions,
) : FrameLayout(reactContext),
  LifecycleEventListener {
  var mapView: RNCNaverMapView? = null
    private set
  private var savedState: Bundle? = Bundle()

  init {
    mapView = RNCNaverMapView(reactContext, mapOptions)
    addView(mapView)
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    mapView?.run {
      onCreate(savedState)
      onStart()
    }
    setupLayoutHack()
  }

  override fun onDetachedFromWindow() {
    mapView?.run {
      onSaveInstanceState(
        savedState ?: run {
          Bundle().also { this@RNCNaverMapViewWrapper.savedState = it }
        },
      )
    }
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
    Choreographer.getInstance().postFrameCallback(
      object : FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
          manuallyLayoutChildren()
          getViewTreeObserver().dispatchOnGlobalLayout()
          if (isAttachedToWindow) {
            Choreographer
              .getInstance()
              .postFrameCallbackDelayed(this, 500)
          }
        }
      },
    )
  }

  private fun manuallyLayoutChildren() {
    for (i in 0 until childCount) {
      val child = getChildAt(i)
      child.measure(
        MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
        MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY),
      )
      child.layout(0, 0, child.measuredWidth, child.measuredHeight)
    }
  }

  override fun onHostResume() {
    mapView?.onResume()
  }

  override fun onHostPause() {
    mapView?.onPause()
  }

  override fun onHostDestroy() {}

  companion object {
    /**
     * A helper to get react tag id by given MapView
     */
    @JvmStatic
    fun getReactTagFromMapView(mapView: MapView): Int {
      // It is expected that the mapView is enclosed by [RNCNaverMapViewWrapper] as the first child.
      // Therefore, it must have a parent, and the parent ID is the reactTag.
      // In exceptional cases, such as receiving MapView messaging after the view has been unmounted,
      // the WebView will not have a parent.
      // In this case, we simply return -1 to indicate that it was not found.
      return (mapView.parent as? View)?.id ?: -1
    }
  }
}
