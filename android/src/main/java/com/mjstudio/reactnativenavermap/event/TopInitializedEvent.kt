package com.mjstudio.reactnativenavermap.event

import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class TopInitializedEvent(viewId: Int, private val mEventData: WritableMap) : Event<TopInitializedEvent>(viewId) {
    override fun getEventName() = EVENT_NAME
    override fun canCoalesce() = false

    companion object {
        const val EVENT_NAME = "onInitialized"
    }
}