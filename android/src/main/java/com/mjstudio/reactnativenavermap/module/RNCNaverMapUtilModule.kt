package com.mjstudio.reactnativenavermap.module

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.module.annotations.ReactModule
import com.mjstudio.reactnativenavermap.RNCNaverMapUtilSpec
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

@ReactModule(name = RNCNaverMapUtilModule.NAME)
class RNCNaverMapUtilModule(
  reactContext: ReactApplicationContext,
  private val infoWindowRegistry: RNCNaverMapInfoWindowRegistry,
) : RNCNaverMapUtilSpec(reactContext) {
  companion object {
    const val NAME = "RNCNaverMapUtil"
  }

  override fun getName(): String = NAME

  override fun invalidate() {
    runOnUiThreadSync {
      infoWindowRegistry.clear()
    }
    super.invalidate()
  }

  @ReactMethod
  override fun createInfoWindow(id: String) {
    runOnUiThreadSync {
      infoWindowRegistry.create(id, reactApplicationContext)
    }
  }

  @ReactMethod
  override fun destroyInfoWindow(id: String) {
    runOnUiThreadSync {
      infoWindowRegistry.destroy(id)
    }
  }

  @ReactMethod
  override fun closeInfoWindow(id: String) {
    runOnUiThreadSync {
      infoWindowRegistry.close(id)
    }
  }

  @ReactMethod
  override fun setInfoWindowContent(
    id: String,
    text: String,
  ) {
    runOnUiThreadSync {
      infoWindowRegistry.setContent(id, text)
    }
  }

  @ReactMethod
  override fun setInfoWindowOptions(
    id: String,
    anchorX: Double,
    anchorY: Double,
    offsetX: Double,
    offsetY: Double,
    alpha: Double,
  ) {
    runOnUiThreadSync {
      infoWindowRegistry.setOptions(id, anchorX, anchorY, offsetX, offsetY, alpha)
    }
  }

  @ReactMethod(isBlockingSynchronousMethod = true)
  override fun isInfoWindowOpen(id: String): Boolean =
    runOnUiThreadSync {
      infoWindowRegistry.isOpen(id)
    }

  private fun <T> runOnUiThreadSync(block: () -> T): T {
    if (UiThreadUtil.isOnUiThread()) {
      return block()
    }

    val latch = CountDownLatch(1)
    var result: Result<T>? = null
    UiThreadUtil.runOnUiThread {
      result = runCatching(block)
      latch.countDown()
    }

    check(latch.await(2, TimeUnit.SECONDS)) {
      "Timed out waiting for the Android UI thread"
    }

    return checkNotNull(result).getOrThrow()
  }
}
