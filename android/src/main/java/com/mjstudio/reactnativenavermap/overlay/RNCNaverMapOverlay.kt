package com.mjstudio.reactnativenavermap.overlay

import android.content.Context
import com.facebook.react.views.view.ReactViewGroup
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Overlay

abstract class RNCNaverMapOverlay<T : Overlay>(
  context: Context?,
) : ReactViewGroup(context) {
  abstract val overlay: T

  abstract fun addToMap(map: NaverMap)

  abstract fun removeFromMap(map: NaverMap)

  abstract fun onDropViewInstance()
}
