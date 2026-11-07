package com.mjstudio.reactnativenavermap.mapview

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.net.Uri
import android.view.View
import android.view.ViewGroup
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.uimanager.PixelUtil
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapCameraChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapCameraIdleEvent
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapLoadedEvent
import com.mjstudio.reactnativenavermap.event.NaverMapLongTapEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapRenderedEvent
import com.mjstudio.reactnativenavermap.event.NaverMapSnapshotFailedEvent
import com.mjstudio.reactnativenavermap.event.NaverMapSnapshotReadyEvent
import com.mjstudio.reactnativenavermap.event.NaverMapSymbolTapEvent
import com.mjstudio.reactnativenavermap.event.NaverMapTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.overlay.infowindow.RNCNaverMapInfoWindow
import com.mjstudio.reactnativenavermap.overlay.marker.RNCNaverMapMarker
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.image.RNCNaverMapTaggedImageRenderer
import com.mjstudio.reactnativenavermap.util.view.ViewAttacherGroup
import com.naver.maps.map.CameraUpdate.REASON_CONTROL
import com.naver.maps.map.CameraUpdate.REASON_GESTURE
import com.naver.maps.map.CameraUpdate.REASON_LOCATION
import com.naver.maps.map.LocationTrackingMode
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions
import com.naver.maps.map.overlay.OverlayImage
import com.naver.maps.map.util.FusedLocationSource
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.util.UUID
import kotlin.concurrent.thread

@SuppressLint("ViewConstructor")
class RNCNaverMapView(
  private val reactContext: ThemedReactContext,
  private val mapOptions: NaverMapOptions,
) : MapView(reactContext, mapOptions) {
  private var attacherGroup: ViewAttacherGroup? = null
  private var map: NaverMap? = null

  @Volatile private var isDestroyed = false
  private val mapRenderedListener =
    NaverMap.OnMapRenderedListener { isFullyRendered, isRenderingStable ->
      reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
        NaverMapRenderedEvent(surfaceId, reactTag, isFullyRendered, isRenderingStable)
      }
    }

  var isSymbolTapEnabled = false
  var isMapRenderedEnabled = false
    set(value) {
      if (field == value) return
      field = value
      map?.let {
        if (value) {
          it.addOnMapRenderedListener(mapRenderedListener)
        } else {
          it.removeOnMapRenderedListener(mapRenderedListener)
        }
      }
    }
  val overlays = mutableListOf<RNCNaverMapOverlay<*>>()

  private val locationOverlayImageRenderer by lazy {
    RNCNaverMapTaggedImageRenderer(context)
  }
  private val locationOverlaySubImageRenderer by lazy {
    RNCNaverMapTaggedImageRenderer(context)
  }

  private val reactTag: Int
    get() = RNCNaverMapViewWrapper.getReactTagFromMapView(this)

  var isInitialCameraOrRegionSet = false

  init {
    getMapAsync {
      map = it
      if (isMapRenderedEnabled) {
        it.addOnMapRenderedListener(mapRenderedListener)
      }
      reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
        NaverMapInitializeEvent(surfaceId, reactTag)
      }
      it.addOnLoadListener {
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          NaverMapLoadedEvent(surfaceId, reactTag)
        }
      }

      it.addOnOptionChangeListener {
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          val modeString =
            when (it.locationTrackingMode) {
              LocationTrackingMode.None -> "None"
              LocationTrackingMode.NoFollow -> "NoFollow"
              LocationTrackingMode.Follow -> "Follow"
              LocationTrackingMode.Face -> "Face"
              else -> "None"
            }
          NaverMapOptionChangeEvent(surfaceId, reactTag, modeString)
        }
      }

      it.addOnCameraChangeListener { reason, animated ->
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          val bounds = it.coveringBounds
          NaverMapCameraChangeEvent(
            surfaceId,
            reactTag,
            it.cameraPosition.target.latitude,
            it.cameraPosition.target.longitude,
            it.cameraPosition.zoom,
            it.cameraPosition.tilt,
            it.cameraPosition.bearing,
            when (reason) {
              REASON_GESTURE -> 1
              REASON_CONTROL -> 2
              REASON_LOCATION -> 3
              else -> 0
            },
            bounds.southLatitude,
            bounds.westLongitude,
            bounds.northLatitude - bounds.southLatitude,
            bounds.eastLongitude - bounds.westLongitude,
          )
        }
      }

      it.addOnCameraIdleListener {
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          val bounds = it.coveringBounds
          NaverMapCameraIdleEvent(
            surfaceId,
            reactTag,
            it.cameraPosition.target.latitude,
            it.cameraPosition.target.longitude,
            it.cameraPosition.zoom,
            it.cameraPosition.tilt,
            it.cameraPosition.bearing,
            bounds.southLatitude,
            bounds.westLongitude,
            bounds.northLatitude - bounds.southLatitude,
            bounds.eastLongitude - bounds.westLongitude,
          )
        }
      }

      it.setOnMapClickListener { pointF, latLng ->
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          NaverMapTapEvent(
            surfaceId,
            reactTag,
            latLng.latitude,
            latLng.longitude,
            pointF.x.toDouble(),
            pointF.y.toDouble(),
          )
        }
      }
      it.setOnMapLongClickListener { pointF, latLng ->
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          NaverMapLongTapEvent(
            surfaceId,
            reactTag,
            latLng.latitude,
            latLng.longitude,
            PixelUtil.toDIPFromPixel(pointF.x).toDouble(),
            PixelUtil.toDIPFromPixel(pointF.y).toDouble(),
          )
        }
      }
      it.setOnSymbolClickListener { symbol ->
        if (!isSymbolTapEnabled) return@setOnSymbolClickListener false
        reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
          NaverMapSymbolTapEvent(
            surfaceId,
            reactTag,
            symbol.caption,
            symbol.position.latitude,
            symbol.position.longitude,
          )
        }
        true
      }
    }

    // Set up a parent view for triggering visibility in subviews that depend on it.
    // Mainly ReactImageView depends on Fresco which depends on onVisibilityChanged() event
    attacherGroup = ViewAttacherGroup(reactContext)
    val attacherLayoutParams = LayoutParams(0, 0)
    attacherLayoutParams.width = 0
    attacherLayoutParams.height = 0
    attacherLayoutParams.leftMargin = 99999999
    attacherLayoutParams.topMargin = 99999999
    attacherGroup!!.setLayoutParams(attacherLayoutParams)
    addView(attacherGroup)
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    locationOverlayImageRenderer.onAttach()
    locationOverlaySubImageRenderer.onAttach()
  }

  override fun onDetachedFromWindow() {
    locationOverlayImageRenderer.onDetach()
    locationOverlaySubImageRenderer.onDetach()
    super.onDetachedFromWindow()
  }

  fun withMap(callback: (map: NaverMap) -> Unit) {
    map?.also(callback) ?: run { getMapAsync(callback) }
  }

  fun withExistingMap(callback: (map: NaverMap) -> Unit) {
    map?.also(callback)
  }

  fun takeSnapshot(showControls: Boolean) {
    withMap { map ->
      if (isDestroyed) return@withMap
      map.takeSnapshot(showControls) { bitmap ->
        if (!isDestroyed) {
          saveSnapshot(bitmap)
        }
      }
    }
  }

  private fun saveSnapshot(bitmap: Bitmap) {
    val width = bitmap.width
    val height = bitmap.height
    thread(name = "RNCNaverMapSnapshot") {
      val directory = File(reactContext.cacheDir, "react-native-naver-map")
      val file = File(directory, "${UUID.randomUUID()}.png")
      try {
        if (!directory.exists() && !directory.mkdirs() && !directory.exists()) {
          throw IOException(SNAPSHOT_ERROR_MESSAGE)
        }
        FileOutputStream(file).use { output ->
          if (!bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)) {
            throw IOException(SNAPSHOT_ERROR_MESSAGE)
          }
        }

        if (isDestroyed) {
          file.delete()
          return@thread
        }
        UiThreadUtil.runOnUiThread {
          if (isDestroyed) {
            file.delete()
            return@runOnUiThread
          }
          reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
            NaverMapSnapshotReadyEvent(
              surfaceId,
              reactTag,
              Uri.fromFile(file).toString(),
              width,
              height,
            )
          }
        }
      } catch (_: Exception) {
        file.delete()
        if (isDestroyed) return@thread
        UiThreadUtil.runOnUiThread {
          if (isDestroyed) return@runOnUiThread
          reactContext.emitEvent(reactTag) { surfaceId, reactTag ->
            NaverMapSnapshotFailedEvent(surfaceId, reactTag, SNAPSHOT_ERROR_MESSAGE)
          }
        }
      }
    }
  }

  fun addOverlay(
    child: View,
    index: Int,
  ) = withMap { map ->
    when (child) {
      is RNCNaverMapMarker -> {
        attachOverlayView(child, index, map)
      }

      is RNCNaverMapInfoWindow -> {
        attachOverlayView(child, index, map)
      }

      is RNCNaverMapOverlay<*> -> {
        child.addToMap(map)
        overlays.add(index, child)
      }

      else -> {
        addView(child, index)
      }
    }
  }

  override fun onDestroy() {
    isDestroyed = true
    map?.removeOnMapRenderedListener(mapRenderedListener)
    removeAllViews()
    overlays.forEach {
      if (map != null) {
        it.removeFromMap(map!!)
      }
    }
    overlays.clear()
    map = null
    attacherGroup = null
    super.onDestroy()
  }

  fun removeOverlay(index: Int) =
    withMap { map ->
      when (val child = overlays.removeAt(index)) {
        is RNCNaverMapMarker -> {
          detachOverlayView(child, map)
        }

        is RNCNaverMapInfoWindow -> {
          detachOverlayView(child, map)
        }

        else -> {
          child.removeFromMap(map)
        }
      }
    }

  private fun attachOverlayView(
    child: RNCNaverMapOverlay<*>,
    index: Int,
    map: NaverMap,
  ) {
    child.addToMap(map)
    overlays.add(index, child)
    val visibility = child.visibility
    child.visibility = INVISIBLE
    (child.parent as? ViewGroup)?.removeView(child)
    attacherGroup!!.addView(child)
    child.visibility = visibility
  }

  private fun detachOverlayView(
    child: RNCNaverMapOverlay<*>,
    map: NaverMap,
  ) {
    child.removeFromMap(map)
    attacherGroup?.removeView(child)
  }

  fun setupLocationSource() {
    reactContext.currentActivity?.also { activity ->
      val source = FusedLocationSource(activity, 100)
      withMap {
        it.locationSource = source
      }
    }
  }

  fun setLocationOverlayImage(image: ReadableMap?) {
    locationOverlayImageRenderer.setImage(image) { overlayImage ->
      withMap {
        it.locationOverlay.icon = overlayImage ?: OverlayImage.fromBitmap(
          Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888),
        )
      }
    }
  }

  fun setLocationOverlaySubImage(image: ReadableMap?) {
    locationOverlaySubImageRenderer.setImage(image) { overlayImage ->
      withMap {
        it.locationOverlay.subIcon = overlayImage ?: OverlayImage.fromBitmap(
          Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888),
        )
      }
    }
  }

  companion object {
    private const val SNAPSHOT_ERROR_MESSAGE = "Failed to save map snapshot"
  }
}
