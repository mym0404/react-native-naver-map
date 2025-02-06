package com.mjstudio.reactnativenavermap.mapview

import android.graphics.PointF
import android.view.Gravity
import android.view.View
import com.airbnb.android.react.maps.SizeReportingShadowNode
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.LayoutShadowNode
import com.facebook.react.uimanager.ReactStylesDiffMap
import com.facebook.react.uimanager.StateWrapper
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mjstudio.reactnativenavermap.RNCNaverMapViewManagerSpec
import com.mjstudio.reactnativenavermap.event.NaverMapCameraChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapCameraIdleEvent
import com.mjstudio.reactnativenavermap.event.NaverMapClusterLeafTapEvent
import com.mjstudio.reactnativenavermap.event.NaverMapCoordinateToScreenEvent
import com.mjstudio.reactnativenavermap.event.NaverMapInitializeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapOptionChangeEvent
import com.mjstudio.reactnativenavermap.event.NaverMapScreenToCoordinateEvent
import com.mjstudio.reactnativenavermap.event.NaverMapTapEvent
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapClusterDataHolder
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapClusterKey
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapClusterMarkerUpdater
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapLeafDataHolder
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapLeafMarkerHolder
import com.mjstudio.reactnativenavermap.overlay.marker.cluster.RNCNaverMapLeafMarkerUpdater
import com.mjstudio.reactnativenavermap.util.CameraAnimationUtil
import com.mjstudio.reactnativenavermap.util.RectUtil
import com.mjstudio.reactnativenavermap.util.dp
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.getDoubleOrNull
import com.mjstudio.reactnativenavermap.util.getIntOrNull
import com.mjstudio.reactnativenavermap.util.getLatLng
import com.mjstudio.reactnativenavermap.util.getLatLngBoundsOrNull
import com.mjstudio.reactnativenavermap.util.isValidNumber
import com.mjstudio.reactnativenavermap.util.px
import com.mjstudio.reactnativenavermap.util.registerDirectEvent
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.LocationTrackingMode
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMap.LAYER_GROUP_BICYCLE
import com.naver.maps.map.NaverMap.LAYER_GROUP_BUILDING
import com.naver.maps.map.NaverMap.LAYER_GROUP_CADASTRAL
import com.naver.maps.map.NaverMap.LAYER_GROUP_MOUNTAIN
import com.naver.maps.map.NaverMap.LAYER_GROUP_TRAFFIC
import com.naver.maps.map.NaverMap.LAYER_GROUP_TRANSIT
import com.naver.maps.map.NaverMap.MapType.Basic
import com.naver.maps.map.NaverMap.MapType.Hybrid
import com.naver.maps.map.NaverMap.MapType.Navi
import com.naver.maps.map.NaverMap.MapType.NaviHybrid
import com.naver.maps.map.NaverMap.MapType.None
import com.naver.maps.map.NaverMap.MapType.Satellite
import com.naver.maps.map.NaverMap.MapType.Terrain
import com.naver.maps.map.NaverMapOptions
import com.naver.maps.map.clustering.Clusterer
import java.util.Locale
import kotlin.math.max
import kotlin.math.min

class RNCNaverMapViewManager : RNCNaverMapViewManagerSpec<RNCNaverMapViewWrapper>() {
  override fun getName(): String = NAME

  private var initialMapOptions: NaverMapOptions? = null
  private var animationDuration = 0
  private var animationEasing = CameraAnimationUtil.numberToCameraAnimationEasing(0)
  private var isFirstCameraMoving = true
  private var lastClustersPropKey = "NOT_SET"

  private val clustererHolders = mutableMapOf<String, RNCNaverMapLeafDataHolder>()

  private lateinit var reactAppContext: ReactApplicationContext

  override fun createViewInstance(
    reactTag: Int,
    reactContext: ThemedReactContext,
    initialProps: ReactStylesDiffMap?,
    stateWrapper: StateWrapper?,
  ): RNCNaverMapViewWrapper {
    reactAppContext = reactContext.reactApplicationContext
    initialMapOptions =
      NaverMapOptions().apply {
        useTextureView(
          initialProps?.getBoolean("isUseTextureViewAndroid", false) ?: false,
        )
        initialProps?.getString("locale")?.also { locale ->
          locale(Locale.forLanguageTag(locale))
        }
        initialProps?.getInt("fpsLimit", -1)?.also { fps ->
          if (fps > 0) {
            fpsLimit(fps)
          }
        }
      }
    return super.createViewInstance(reactTag, reactContext, initialProps, stateWrapper)
  }

  override fun createViewInstance(reactContext: ThemedReactContext): RNCNaverMapViewWrapper =
    RNCNaverMapViewWrapper(reactContext, initialMapOptions ?: NaverMapOptions()).also {
      reactContext.addLifecycleEventListener(it)
    }

  override fun onDropViewInstance(view: RNCNaverMapViewWrapper) {
    view.onDropViewInstance()
    view.reactContext.removeLifecycleEventListener(view)
    clustererHolders.forEach { (_, u) -> u.onDetach() }
    clustererHolders.clear()
    lastClustersPropKey = "NOT_SET"
    isFirstCameraMoving = true
    super.onDropViewInstance(view)
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> =
    (super.getExportedCustomDirectEventTypeConstants() ?: mutableMapOf()).apply {
      registerDirectEvent(this, NaverMapInitializeEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapOptionChangeEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapCameraChangeEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapCameraIdleEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapTapEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapScreenToCoordinateEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapCoordinateToScreenEvent.EVENT_NAME)
      registerDirectEvent(this, NaverMapClusterLeafTapEvent.EVENT_NAME)
    }

  private fun RNCNaverMapViewWrapper?.withMapView(callback: (mapView: RNCNaverMapView) -> Unit) {
    this?.mapView?.run(callback)
  }

  private fun RNCNaverMapViewWrapper?.withMap(callback: (map: NaverMap) -> Unit) {
    this?.mapView?.withMap(callback)
  }

  override fun needsCustomLayoutForChildren(): Boolean = true

  override fun addView(
    parent: RNCNaverMapViewWrapper,
    child: View,
    index: Int,
  ) {
    parent.withMapView {
      it.addOverlay(child, index)
    }
  }

  override fun getChildCount(parent: RNCNaverMapViewWrapper): Int = parent.mapView?.overlays?.size ?: 0

  override fun getChildAt(
    parent: RNCNaverMapViewWrapper,
    index: Int,
  ): View? = parent.mapView?.overlays?.get(index)

  override fun removeViewAt(
    parent: RNCNaverMapViewWrapper,
    index: Int,
  ) {
    parent.withMapView {
      it.removeOverlay(index)
    }
  }

  override fun createShadowNodeInstance(): LayoutShadowNode {
    // A custom shadow node is needed in order to pass back the width/height of the map to the
    // view manager so that it can start applying camera moves with bounds.
    return SizeReportingShadowNode()
  }

  // region PROPS

  @ReactProp(name = "mapType")
  override fun setMapType(
    view: RNCNaverMapViewWrapper?,
    value: String?,
  ) {
    view.withMap {
      it.mapType =
        when (value) {
          "Basic" -> Basic
          "Navi" -> Navi
          "Satellite" -> Satellite
          "Hybrid" -> Hybrid
          "Terrain" -> Terrain
          "NaviHybrid" -> NaviHybrid
          "None" -> None
          else -> Basic
        }
    }
  }

  @ReactProp(name = "layerGroups")
  override fun setLayerGroups(
    view: RNCNaverMapViewWrapper?,
    value: Int,
  ) = view.withMap {
    val building = value and (1 shl 0) != 0
    val traffic = value and (1 shl 1) != 0
    val transit = value and (1 shl 2) != 0
    val bicycle = value and (1 shl 3) != 0
    val mountain = value and (1 shl 4) != 0
    val cadastral = value and (1 shl 5) != 0

    if (it.isLayerGroupEnabled(LAYER_GROUP_BUILDING) != building) {
      it.setLayerGroupEnabled(LAYER_GROUP_BUILDING, building)
    }

    if (it.isLayerGroupEnabled(LAYER_GROUP_TRAFFIC) != traffic) {
      it.setLayerGroupEnabled(LAYER_GROUP_TRAFFIC, traffic)
    }

    if (it.isLayerGroupEnabled(LAYER_GROUP_TRANSIT) != transit) {
      it.setLayerGroupEnabled(LAYER_GROUP_TRANSIT, transit)
    }

    if (it.isLayerGroupEnabled(LAYER_GROUP_BICYCLE) != bicycle) {
      it.setLayerGroupEnabled(LAYER_GROUP_BICYCLE, bicycle)
    }
    if (it.isLayerGroupEnabled(LAYER_GROUP_MOUNTAIN) != mountain) {
      it.setLayerGroupEnabled(LAYER_GROUP_MOUNTAIN, mountain)
    }

    if (it.isLayerGroupEnabled(LAYER_GROUP_CADASTRAL) != cadastral) {
      it.setLayerGroupEnabled(LAYER_GROUP_CADASTRAL, cadastral)
    }
  }

  @ReactProp(name = "initialCamera")
  override fun setInitialCamera(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMapView {
    if (!it.isInitialCameraOrRegionSet) {
      if (isValidNumber(value?.getDoubleOrNull("latitude"))) {
        it.isInitialCameraOrRegionSet = true
        setCamera(view, value)
      }
    }
  }

  @ReactProp(name = "camera")
  override fun setCamera(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMap {
    value?.getLatLng()?.also { latlng ->
      val zoom = value.getDoubleOrNull("zoom") ?: it.cameraPosition.zoom
      val tilt = value.getDoubleOrNull("tilt") ?: it.cameraPosition.tilt
      val bearing = value.getDoubleOrNull("bearing") ?: it.cameraPosition.bearing

      it.moveCamera(
        CameraUpdate
          .toCameraPosition(
            CameraPosition(
              latlng,
              zoom,
              tilt,
              bearing,
            ),
          ).apply {
            if (animationDuration > 0 && !isFirstCameraMoving) {
              animate(animationEasing, animationDuration.toLong())
            }
          },
      )
      isFirstCameraMoving = false
    }
  }

  @ReactProp(name = "initialRegion")
  override fun setInitialRegion(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) {
    if (isValidNumber(value?.getDoubleOrNull("latitude"))) {
      view.withMapView {
        if (!it.isInitialCameraOrRegionSet) {
          it.isInitialCameraOrRegionSet = true
          setRegion(view, value)
        }
      }
    }
  }

  @ReactProp(name = "region")
  override fun setRegion(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMap {
    value.getLatLngBoundsOrNull()?.run {
      val update =
        CameraUpdate.fitBounds(this).apply {
          if (animationDuration > 0 && !isFirstCameraMoving) {
            animate(animationEasing, animationDuration.toLong())
          }
        }
      it.moveCamera(update)
      isFirstCameraMoving = false
    }
  }

  @ReactProp(name = "animationDuration")
  override fun setAnimationDuration(
    view: RNCNaverMapViewWrapper?,
    value: Int,
  ) {
    animationDuration = value
  }

  @ReactProp(name = "animationEasing")
  override fun setAnimationEasing(
    view: RNCNaverMapViewWrapper?,
    value: Int,
  ) {
    animationEasing = CameraAnimationUtil.numberToCameraAnimationEasing(value)
  }

  @ReactProp(name = "isIndoorEnabled")
  override fun setIsIndoorEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.isIndoorEnabled = value
  }

  @ReactProp(name = "isNightModeEnabled")
  override fun setIsNightModeEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.isNightModeEnabled = value
  }

  @ReactProp(name = "isLiteModeEnabled")
  override fun setIsLiteModeEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.isLiteModeEnabled = value
  }

  @ReactProp(name = "lightness")
  override fun setLightness(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.lightness = value.toFloat()
  }

  @ReactProp(name = "buildingHeight")
  override fun setBuildingHeight(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.buildingHeight = value.toFloat()
  }

  @ReactProp(name = "symbolScale")
  override fun setSymbolScale(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.symbolScale = value.toFloat()
  }

  @ReactProp(name = "symbolPerspectiveRatio")
  override fun setSymbolPerspectiveRatio(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.symbolPerspectiveRatio = value.toFloat()
  }

  @ReactProp(name = "mapPadding")
  override fun setMapPadding(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMapView {
    RectUtil.getRect(value, it.resources.displayMetrics.density, defaultValue = 0.0)?.run {
      it.withMap { map ->
        map.setContentPadding(left, top, right, bottom)
      }
    }
  }

  @ReactProp(name = "minZoom")
  override fun setMinZoom(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.minZoom = value
  }

  @ReactProp(name = "maxZoom")
  override fun setMaxZoom(
    view: RNCNaverMapViewWrapper?,
    value: Double,
  ) = view.withMap {
    it.maxZoom = value
  }

  @ReactProp(name = "isShowCompass")
  override fun setIsShowCompass(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.uiSettings.isCompassEnabled = value
  }

  @ReactProp(name = "isShowScaleBar")
  override fun setIsShowScaleBar(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.uiSettings.isScaleBarEnabled = value
  }

  @ReactProp(name = "isShowZoomControls")
  override fun setIsShowZoomControls(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.uiSettings.isZoomControlEnabled = value
  }

  @ReactProp(name = "isShowIndoorLevelPicker")
  override fun setIsShowIndoorLevelPicker(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap {
    it.uiSettings.isIndoorLevelPickerEnabled = value
  }

  @ReactProp(name = "isShowLocationButton")
  override fun setIsShowLocationButton(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMapView {
    if (value) {
      it.setupLocationSource()
    }
    it.withMap { map ->
      map.uiSettings.isLocationButtonEnabled = value
    }
  }

  @ReactProp(name = "logoAlign")
  override fun setLogoAlign(
    view: RNCNaverMapViewWrapper?,
    value: String?,
  ) = view.withMap {
    it.uiSettings.logoGravity =
      when (value) {
        "TopLeft" -> Gravity.TOP or Gravity.LEFT
        "TopRight" -> Gravity.TOP or Gravity.RIGHT
        "BottomRight" -> Gravity.BOTTOM or Gravity.RIGHT
        else -> Gravity.BOTTOM or Gravity.LEFT
      }
  }

  @ReactProp(name = "logoMargin")
  override fun setLogoMargin(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMapView {
    RectUtil.getRect(value, it.resources.displayMetrics.density, defaultValue = 0.0)?.run {
      it.withMap { map ->
        map.uiSettings.setLogoMargin(left, top, right, bottom)
      }
    }
  }

  @ReactProp(name = "extent")
  override fun setExtent(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMap {
    value.getLatLngBoundsOrNull()?.run {
      it.extent = this
    }
  }

  @ReactProp(name = "isScrollGesturesEnabled")
  override fun setIsScrollGesturesEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap { it.uiSettings.isScrollGesturesEnabled = value }

  @ReactProp(name = "isZoomGesturesEnabled")
  override fun setIsZoomGesturesEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap { it.uiSettings.isZoomGesturesEnabled = value }

  @ReactProp(name = "isTiltGesturesEnabled")
  override fun setIsTiltGesturesEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap { it.uiSettings.isTiltGesturesEnabled = value }

  @ReactProp(name = "isRotateGesturesEnabled")
  override fun setIsRotateGesturesEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap { it.uiSettings.isRotateGesturesEnabled = value }

  @ReactProp(name = "isStopGesturesEnabled")
  override fun setIsStopGesturesEnabled(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) = view.withMap { it.uiSettings.isStopGesturesEnabled = value }

  @ReactProp(name = "isUseTextureViewAndroid")
  override fun setIsUseTextureViewAndroid(
    view: RNCNaverMapViewWrapper?,
    value: Boolean,
  ) {
    // don't implement this
  }

  @ReactProp(name = "locale")
  override fun setLocale(
    view: RNCNaverMapViewWrapper?,
    value: String?,
  ) = view.withMap {
    if (value != null) {
      it.locale = Locale.forLanguageTag(value)
    }
  }

  @ReactProp(name = "clusters")
  override fun setClusters(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMap { map ->
    if (value == null) {
      return@withMap
    }
    val propKey = value.getString("key") ?: ""

    if (propKey == lastClustersPropKey) {
      return@withMap
    }
    lastClustersPropKey = propKey

    // remove all at now
    clustererHolders.forEach { (_, clusterer) ->
      clusterer.onDetach()
    }
    clustererHolders.clear()

    val isLeafTapCallbackExist = value.getBoolean("isLeafTapCallbackExist")

    value.getArray("clusters")?.toArrayList()?.filterIsInstance<Map<String, Any?>>()?.forEach {
      val clustererKey = it["key"] as? String
      val clusterWidth = it["width"] as? Double
      val clusterHeight = it["height"] as? Double
      val screenDistance = it["screenDistance"] as? Double
      val minZoom = it["minZoom"] as? Double
      val maxZoom = it["maxZoom"] as? Double
      val animate = it["animate"] as? Boolean
      val markers = (it["markers"] as? ArrayList<*>)?.filterIsInstance<Map<String, *>>() ?: listOf()

      val clusterer =
        Clusterer
          .Builder<RNCNaverMapClusterKey>()
          .clusterMarkerUpdater(RNCNaverMapClusterMarkerUpdater(RNCNaverMapClusterDataHolder(clusterWidth, clusterHeight)))
          .leafMarkerUpdater(RNCNaverMapLeafMarkerUpdater())
          .also { cluster ->
            if (screenDistance != null) {
              cluster.screenDistance(screenDistance)
            }
            if (minZoom != null) {
              cluster.minZoom(max(minZoom.toInt(), 1))
            }
            if (maxZoom != null) {
              cluster.maxZoom(min(maxZoom.toInt(), 20))
            }
            if (animate != null) {
              cluster.animate(animate)
            }
          }.build()

      val keyPairs =
        markers.associate { marker ->
          val identifier = marker["identifier"] as String
          val latitude = marker["latitude"] as Double
          val longitude = marker["longitude"] as Double
          val image = marker["image"] as? Map<*, *>
          val width = marker["width"] as? Double
          val height = marker["height"] as? Double

          RNCNaverMapClusterKey(
            RNCNaverMapLeafMarkerHolder(
              identifier,
              latlng = LatLng(latitude, longitude),
              context = reactAppContext,
              image,
              width,
              height,
              onTapLeaf =
                if (isLeafTapCallbackExist) {
                  {
                    view?.let { wrapper ->
                      wrapper.reactContext.emitEvent(wrapper.id) { surfaceId, reactTag ->
                        NaverMapClusterLeafTapEvent(
                          surfaceId,
                          reactTag,
                          identifier,
                        )
                      }
                    }
                  }
                } else {
                  null
                },
            ),
          ) to null
        }

      clusterer.addAll(keyPairs)
      clusterer.map = map
      clustererHolders[clustererKey!!] =
        RNCNaverMapLeafDataHolder(
          clustererKey,
          clusterer,
          reactAppContext,
          keyPairs.map { pair -> pair.key.holder },
        )
    }
  }

  @ReactProp(name = "fpsLimit")
  override fun setFpsLimit(
    view: RNCNaverMapViewWrapper?,
    value: Int,
  ) {
    // noop
  }

  @ReactProp(name = "locationOverlay")
  override fun setLocationOverlay(
    view: RNCNaverMapViewWrapper?,
    value: ReadableMap?,
  ) = view.withMapView { mapView ->
    mapView.withMap {
      value?.let { v ->
        val o = it.locationOverlay
        o.isVisible = v.getBoolean("isVisible")
        v.getMap("position")?.getLatLng()?.let { o.position = it }
        v.getDoubleOrNull("bearing")?.let { o.bearing = it.toFloat() }
        v.getMap("image")?.let { mapView.setLocationOverlayImage(it) }
        v.getDoubleOrNull("imageWidth")?.let { o.iconWidth = it.px }
        v.getDoubleOrNull("imageHeight")?.let { o.iconHeight = it.px }
        v.getMap("anchor")?.let { o.anchor = PointF(it.getDouble("x").toFloat(), it.getDouble("y").toFloat()) }
        v.getMap("subImage")?.let { mapView.setLocationOverlaySubImage(it) }
        v.getDoubleOrNull("subImageWidth")?.let { o.subIconWidth = it.px }
        v.getDoubleOrNull("subImageHeight")?.let { o.subIconHeight = it.px }
        v.getMap("subAnchor")?.let { o.subAnchor = PointF(it.getDouble("x").toFloat(), it.getDouble("y").toFloat()) }
        v.getDoubleOrNull("circleRadius")?.let { o.circleRadius = it.px }
        v.getIntOrNull("circleColor")?.let { o.circleColor = it }
        v.getDoubleOrNull("circleOutlineWidth")?.let { o.circleOutlineWidth = it.px }
        v.getIntOrNull("circleOutlineColor")?.let { o.circleOutlineColor = it }
      }
    }
  }

  // endregion

  // region COMMANDS
  override fun screenToCoordinate(
    view: RNCNaverMapViewWrapper?,
    x: Double,
    y: Double,
  ) = view.withMap { map ->
    view?.let { wrapper ->
      val coord = map.projection.fromScreenLocation(PointF(x.toFloat(), y.toFloat()))
      wrapper.reactContext.emitEvent(wrapper.id) { surfaceId, reactTag ->
        NaverMapScreenToCoordinateEvent(
          surfaceId,
          reactTag,
          coord.isValid,
          if (coord.isValid) coord.latitude else .0,
          if (coord.isValid) coord.longitude else .0,
        )
      }
    }
  }

  override fun coordinateToScreen(
    view: RNCNaverMapViewWrapper?,
    latitude: Double,
    longitude: Double,
  ) = view.withMap { map ->
    view?.let { wrapper ->
      val coord = map.projection.toScreenLocation(LatLng(latitude, longitude))
      val isValid = !coord.x.isNaN() && !coord.y.isNaN()
      wrapper.reactContext.emitEvent(wrapper.id) { surfaceId, reactTag ->
        NaverMapCoordinateToScreenEvent(
          surfaceId,
          reactTag,
          isValid,
          if (isValid) coord.x.dp.toDouble() else .0,
          if (isValid) coord.y.dp.toDouble() else .0,
        )
      }
    }
  }

  override fun animateCameraTo(
    view: RNCNaverMapViewWrapper?,
    latitude: Double,
    longitude: Double,
    duration: Int,
    easing: Int,
    pivotX: Double,
    pivotY: Double,
    zoom: Double,
  ) = view.withMap {
    val update =
      if (isValidNumber(zoom)) {
        CameraUpdate.scrollAndZoomTo(
          LatLng(
            latitude,
            longitude,
          ),
          zoom,
        )
      } else {
        CameraUpdate.scrollTo(LatLng(latitude, longitude))
      }

    update
      .animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
      .pivot(
        PointF(pivotX.toFloat(), pivotY.toFloat()),
      ).run {
        it.moveCamera(this)
      }
  }

  override fun animateCameraBy(
    view: RNCNaverMapViewWrapper?,
    x: Double,
    y: Double,
    duration: Int,
    easing: Int,
    pivotX: Double,
    pivotY: Double,
  ) = view.withMap {
    CameraUpdate
      .scrollBy(
        PointF(
          x.px.toFloat(),
          y.px.toFloat(),
        ),
      ).animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
      .pivot(
        PointF(pivotX.toFloat(), pivotY.toFloat()),
      ).run {
        it.moveCamera(this)
      }
  }

  override fun animateRegionTo(
    view: RNCNaverMapViewWrapper?,
    latitude: Double,
    longitude: Double,
    latitudeDelta: Double,
    longitudeDelta: Double,
    duration: Int,
    easing: Int,
    pivotX: Double,
    pivotY: Double,
  ) = view.withMap {
    CameraUpdate
      .fitBounds(
        LatLngBounds(
          LatLng(latitude, longitude),
          LatLng(latitude + latitudeDelta, longitude + longitudeDelta),
        ),
      ).animate(CameraAnimationUtil.numberToCameraAnimationEasing(easing), duration.toLong())
      .pivot(
        PointF(pivotX.toFloat(), pivotY.toFloat()),
      ).run {
        it.moveCamera(this)
      }
  }

  override fun cancelAnimation(view: RNCNaverMapViewWrapper?) =
    view.withMap {
      it.cancelTransitions()
    }

  override fun setLocationTrackingMode(
    view: RNCNaverMapViewWrapper?,
    mode: String?,
  ) = view.withMapView {
    mapView -> mapView.setupLocationSource()
    mapView.withMap {
      it.locationTrackingMode =
        when (mode) {
          "NoFollow" -> LocationTrackingMode.NoFollow
          "Follow" -> LocationTrackingMode.Follow
          "Face" -> LocationTrackingMode.Face
          else -> LocationTrackingMode.None
        }
    }
  }

  companion object {
    const val NAME = "RNCNaverMapView"
  }
}
