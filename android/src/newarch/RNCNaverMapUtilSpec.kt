package com.mjstudio.reactnativenavermap

import com.facebook.fbreact.specs.NativeRNCNaverMapUtilSpec
import com.facebook.react.bridge.ReactApplicationContext

abstract class RNCNaverMapUtilSpec(
  reactContext: ReactApplicationContext,
) : NativeRNCNaverMapUtilSpec(reactContext) {
  // Codegen이 생성하는 abstract class를 상속
  // 실제 구현은 RNCNaverMapUtilModule에서
}
