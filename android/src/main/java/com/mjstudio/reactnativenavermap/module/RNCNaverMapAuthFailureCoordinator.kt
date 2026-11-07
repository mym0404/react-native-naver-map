package com.mjstudio.reactnativenavermap.module

import com.facebook.react.bridge.ReactApplicationContext
import com.naver.maps.map.NaverMapSdk
import java.lang.ref.WeakReference

internal object RNCNaverMapAuthFailureCoordinator {
  private val modules = mutableListOf<WeakReference<RNCNaverMapUtilModule>>()
  private var sdk: NaverMapSdk? = null
  private var previousListener: NaverMapSdk.OnAuthFailedListener? = null
  private var isInstalled = false

  private val listener =
    NaverMapSdk.OnAuthFailedListener { error ->
      val previousListener = previousListener
      removeCollectedModules()
      val activeModules = modules.mapNotNull(WeakReference<RNCNaverMapUtilModule>::get)
      if (modules.isEmpty()) uninstall()

      try {
        previousListener?.onAuthFailed(error)
      } finally {
        activeModules.forEach { module ->
          module.emitAuthFailure(error.errorCode, error.message.orEmpty())
        }
      }
    }

  fun add(
    reactContext: ReactApplicationContext,
    module: RNCNaverMapUtilModule,
  ) {
    removeCollectedModules()
    if (modules.isEmpty()) uninstall()
    if (modules.any { it.get() === module }) return

    if (!isInstalled) {
      val sdk = NaverMapSdk.getInstance(reactContext)
      this.sdk = sdk
      previousListener = sdk.onAuthFailedListener
      sdk.onAuthFailedListener = listener
      isInstalled = true
    }
    modules.add(WeakReference(module))
  }

  fun remove(module: RNCNaverMapUtilModule) {
    modules.removeAll { reference ->
      val activeModule = reference.get()
      activeModule == null || activeModule === module
    }
    if (modules.isEmpty()) uninstall()
  }

  private fun removeCollectedModules() {
    modules.removeAll { it.get() == null }
  }

  private fun uninstall() {
    if (!isInstalled) return

    sdk?.let { sdk ->
      if (sdk.onAuthFailedListener === listener) {
        sdk.onAuthFailedListener = previousListener
      }
    }
    sdk = null
    previousListener = null
    isInstalled = false
  }
}
