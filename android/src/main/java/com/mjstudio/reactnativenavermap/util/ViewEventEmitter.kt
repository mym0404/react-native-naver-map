package com.mjstudio.reactnativenavermap.util

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.mjstudio.reactnativenavermap.event.RNCNaverMapViewEvent

fun ReactContext.emitEvent(event: RNCNaverMapViewEvent, reactTag: Int, params: WritableMap = Arguments.createMap()) {
    getJSModule(RCTEventEmitter::class.java).receiveEvent(reactTag, event.eventName, params)
}