package com.mjstudio.reactnativenavermap.util

import com.naver.maps.map.CameraAnimation

object CameraAnimationUtil {
    fun numberToCameraAnimationEasing(value: Int) = when (value) {
        1 -> CameraAnimation.None
        2 -> CameraAnimation.Linear
        3 -> CameraAnimation.Fly
        else -> CameraAnimation.Easing
    }
}