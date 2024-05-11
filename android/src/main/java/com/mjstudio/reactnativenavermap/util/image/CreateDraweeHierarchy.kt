package com.mjstudio.reactnativenavermap.util.image

import android.content.res.Resources
import com.facebook.drawee.drawable.ScalingUtils
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder

internal fun createDraweeHierarchy(resources: Resources): GenericDraweeHierarchy {
  return GenericDraweeHierarchyBuilder(resources)
    .setActualImageScaleType(ScalingUtils.ScaleType.FIT_CENTER)
    .setFadeDuration(0)
    .build()
}
