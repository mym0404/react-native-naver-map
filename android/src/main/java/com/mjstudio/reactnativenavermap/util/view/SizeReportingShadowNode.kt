/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

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
