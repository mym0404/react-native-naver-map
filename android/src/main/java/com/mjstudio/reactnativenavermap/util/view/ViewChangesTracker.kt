package com.mjstudio.reactnativenavermap.util.view

import android.os.Handler
import android.os.Looper
import java.util.LinkedList

class ViewChangesTracker private constructor() {
  private val handler: Handler = Handler(Looper.getMainLooper())
  private val markers = LinkedList<TrackableView>()
  private var hasScheduledFrame = false
  private val fps = 40L

  private val updateRunnable =
    object : Runnable {
      override fun run() {
        update()

        if (markers.isNotEmpty()) {
          handler.postDelayed(this, fps)
        } else {
          hasScheduledFrame = false
        }
      }
    }

  companion object {
    @Volatile
    private var instance: ViewChangesTracker? = null

    fun getInstance(): ViewChangesTracker =
      instance ?: synchronized(ViewChangesTracker::class.java) {
        instance ?: ViewChangesTracker().also { instance = it }
      }
  }

  fun addMarker(marker: TrackableView) {
    markers.add(marker)

    if (!hasScheduledFrame) {
      hasScheduledFrame = true
      handler.postDelayed(updateRunnable, fps)
    }
  }

  fun removeMarker(marker: TrackableView) {
    markers.remove(marker)
  }

  fun containsMarker(marker: TrackableView): Boolean = markers.contains(marker)

  private val markersToRemove = LinkedList<TrackableView>()

  fun update() {
    for (marker in markers) {
      marker.update()
    }

    // Remove markers that are not active anymore
    if (markersToRemove.isNotEmpty()) {
      markers.removeAll(markersToRemove)
      markersToRemove.clear()
    }
  }
}
