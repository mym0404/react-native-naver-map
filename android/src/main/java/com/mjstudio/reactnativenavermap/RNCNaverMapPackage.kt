package com.mjstudio.reactnativenavermap

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.uimanager.ViewManager
import com.mjstudio.reactnativenavermap.mapview.RNCNaverMapViewManager
import com.mjstudio.reactnativenavermap.module.RNCNaverMapUtilModule
import com.mjstudio.reactnativenavermap.overlay.arrowheadpath.RNCNaverMapArrowheadPathManager
import com.mjstudio.reactnativenavermap.overlay.circle.RNCNaverMapCircleManager
import com.mjstudio.reactnativenavermap.overlay.ground.RNCNaverMapGroundManager
import com.mjstudio.reactnativenavermap.overlay.marker.RNCNaverMapMarkerManager
import com.mjstudio.reactnativenavermap.overlay.multipath.RNCNaverMapMultiPathManager
import com.mjstudio.reactnativenavermap.overlay.path.RNCNaverMapPathManager
import com.mjstudio.reactnativenavermap.overlay.polygon.RNCNaverMapPolygonManager
import com.mjstudio.reactnativenavermap.overlay.polyline.RNCNaverMapPolylineManager

class RNCNaverMapPackage : BaseReactPackage() {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> =
    mutableListOf<ViewManager<*, *>>().apply {
      add(RNCNaverMapViewManager())
      add(RNCNaverMapMarkerManager())
      add(RNCNaverMapCircleManager())
      add(RNCNaverMapPolygonManager())
      add(RNCNaverMapPolylineManager())
      add(RNCNaverMapPathManager())
      add(RNCNaverMapMultiPathManager())
      add(RNCNaverMapArrowheadPathManager())
      add(RNCNaverMapGroundManager())
    }

  override fun getModule(
    name: String,
    reactContext: ReactApplicationContext,
  ): NativeModule? =
    when (name) {
      NativeRNCNaverMapUtilSpec.NAME -> RNCNaverMapUtilModule(reactContext)
      else -> null
    }

  override fun getReactModuleInfoProvider() =
    ReactModuleInfoProvider {
      mapOf(
        NativeRNCNaverMapUtilSpec.NAME to
          ReactModuleInfo(
            name = NativeRNCNaverMapUtilSpec.NAME,
            className = NativeRNCNaverMapUtilSpec.NAME,
            canOverrideExistingModule = false,
            needsEagerInit = false,
            isCxxModule = false,
            isTurboModule = true,
          ),
      )
    }
}
