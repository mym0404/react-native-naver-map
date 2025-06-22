package com.airbnb.android.react.maps;

import android.os.Handler;
import android.os.Looper;

import java.util.LinkedList;

public class ViewChangesTracker {

  private static ViewChangesTracker instance;
  private final Handler handler;
  private final LinkedList<TrackableView> markers = new LinkedList<>();
  private boolean hasScheduledFrame = false;
  private final Runnable updateRunnable;
  private final long fps = 40;

  private ViewChangesTracker() {
    handler = new Handler(Looper.getMainLooper());
    updateRunnable = new Runnable() {
      @Override
      public void run() {
        update();

        if (markers.size() > 0) {
          handler.postDelayed(updateRunnable, fps);
        } else {
          hasScheduledFrame = false;
        }
      }
    };
  }

  public static ViewChangesTracker getInstance() {
    if (instance == null) {
      synchronized (ViewChangesTracker.class) {
        instance = new ViewChangesTracker();
      }
    }

    return instance;
  }

  public void addMarker(TrackableView marker) {
    markers.add(marker);

    if (!hasScheduledFrame) {
      hasScheduledFrame = true;
      handler.postDelayed(updateRunnable, fps);
    }
  }

  public void removeMarker(TrackableView marker) {
    markers.remove(marker);
  }

  public boolean containsMarker(TrackableView marker) {
    return markers.contains(marker);
  }

  private final LinkedList<TrackableView> markersToRemove = new LinkedList<>();

  public void update() {
    for (TrackableView marker : markers) {
      if (!marker.updateCustomForTracking()) {
        markersToRemove.add(marker);
      }
    }

    // Remove markers that are not active anymore
    if (markersToRemove.size() > 0) {
      markers.removeAll(markersToRemove);
      markersToRemove.clear();
    }
  }

}
