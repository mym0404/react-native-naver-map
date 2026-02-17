package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.Choreographer
import android.view.Choreographer.FrameCallback
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.util.debugE
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMapOptions

@SuppressLint("ViewConstructor")
class RNCNaverMapViewWrapper(
  val reactContext: ThemedReactContext,
  private val mapOptions: NaverMapOptions,
) : FrameLayout(reactContext),
  DefaultLifecycleObserver {
  var mapView: RNCNaverMapView? = null
    private set
  private var savedState: Bundle? = null
  private var isCreated = false

  private var isResumed = false
  private var destroyed = false
  private var lifecycleObserverAttached = false
  private var currentLifecycleOwner: LifecycleOwner? = null

  init {
    mapView = RNCNaverMapView(reactContext, mapOptions)
    addView(mapView)
  }

  override fun onResume(owner: LifecycleOwner) {
    synchronized(this@RNCNaverMapViewWrapper) {
      if (isAttachedToWindow && !isResumed && !destroyed) {
        mapView?.onResume()
        isResumed = true
      }
    }
  }

  override fun onPause(owner: LifecycleOwner) {
    synchronized(this@RNCNaverMapViewWrapper) {
      if (isResumed && !destroyed) {
        mapView?.onPause()
        isResumed = false
      }
    }
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    debugE("attachedToWindow start isCreated=$isCreated destroyed=$destroyed hasState=${savedState != null}")

    synchronized(this) {
      if (!destroyed) {
        mapView?.run {
          if (!isCreated) {
            onCreate(savedState)
            isCreated = true
            debugE("mapView onCreate")
          }
          onStart()
          debugE("mapView onStart")

          if (!isResumed) {
            onResume()
            isResumed = true
            debugE("mapView onResume")
          }
        }
      }
    }

    attachLifecycleObserver()
    setupLayoutHack()
  }

  override fun onDetachedFromWindow() {
    debugE("onDetachedFromWindow start isResumed=$isResumed destroyed=$destroyed hasState=${savedState != null}")
    mapView?.run {
      if (isResumed) {
        onPause()
        isResumed = false
        debugE("mapView onPause @detach")
      }
      onSaveInstanceState(
        savedState ?: run {
          Bundle().also { this@RNCNaverMapViewWrapper.savedState = it }
        },
      )
    }

    super.onDetachedFromWindow()
    detachLifecycleObserver()
  }

  private fun attachLifecycleObserver() {
    val activity = reactContext.currentActivity
    if (activity is LifecycleOwner && !lifecycleObserverAttached) {
      currentLifecycleOwner = activity
      currentLifecycleOwner?.lifecycle?.addObserver(this)
      lifecycleObserverAttached = true
    }
  }

  private fun detachLifecycleObserver() {
    currentLifecycleOwner?.lifecycle?.removeObserver(this)
    lifecycleObserverAttached = false
    currentLifecycleOwner = null
  }

  @Synchronized
  fun doDestroy() {
    debugE("doDestroy called destroyed=$destroyed")
    if (destroyed) {
      return
    }
    destroyed = true

    mapView?.run {
      if (isResumed) {
        onPause()
        isResumed = false
        debugE("mapView onPause @destroy")
      }

      onStop()
      debugE("mapView onStop @destroy")
      onDestroy()
      debugE("mapView onDestroy @destroy")
    }

    removeAllViews()
    savedState?.clear()
    savedState = null
    isCreated = false
    mapView = null
    detachLifecycleObserver()
  }

  // https://github.com/facebook/react-native/issues/17968#issuecomment-457236577
  private fun setupLayoutHack() {
    Choreographer.getInstance().postFrameCallback(
      object : FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
          manuallyLayoutChildren()
          viewTreeObserver.dispatchOnGlobalLayout()
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

  override fun dispatchTouchEvent(ev: MotionEvent?): Boolean {
    mapView?.withMap { map ->
      if (map.uiSettings.isScrollGesturesEnabled) {
        when (ev?.action) {
          MotionEvent.ACTION_DOWN,
          MotionEvent.ACTION_MOVE,
          -> {
            parent?.requestDisallowInterceptTouchEvent(true)
          }

          MotionEvent.ACTION_UP,
          MotionEvent.ACTION_CANCEL,
          -> {
            parent?.requestDisallowInterceptTouchEvent(false)
          }
        }
      }
    }
    return super.dispatchTouchEvent(ev)
  }

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
