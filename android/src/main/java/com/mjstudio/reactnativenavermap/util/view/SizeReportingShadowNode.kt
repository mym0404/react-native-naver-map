package com.mjstudio.reactnativenavermap.util.view

import com.facebook.react.uimanager.LayoutShadowNode
import com.facebook.react.uimanager.UIViewOperationQueue

// Custom LayoutShadowNode implementation used in conjunction with the AirMapManager
// which sends the width/height of the view after layout occurs.
class SizeReportingShadowNode : LayoutShadowNode() {
  override fun onCollectExtraUpdates(uiViewOperationQueue: UIViewOperationQueue) {
    super.onCollectExtraUpdates(uiViewOperationQueue)

    val data = HashMap<String, Float>()
    data["width"] = layoutWidth
    data["height"] = layoutHeight

    uiViewOperationQueue.enqueueUpdateExtraData(reactTag, data)
  }
}
