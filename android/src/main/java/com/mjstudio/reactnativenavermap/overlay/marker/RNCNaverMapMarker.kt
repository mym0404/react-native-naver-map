package com.mjstudio.reactnativenavermap.overlay.marker

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.view.View
import androidx.core.view.children
import com.airbnb.android.react.maps.TrackableView
import com.airbnb.android.react.maps.ViewChangesTracker
import com.facebook.drawee.drawable.ScalingUtils
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder
import com.facebook.drawee.view.DraweeHolder
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.ImageRequestCanceller
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.mjstudio.reactnativenavermap.util.getOverlayImage
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.OverlayImage
import kotlin.math.max


@SuppressLint("ViewConstructor")
class RNCNaverMapMarker(val reactContext: ThemedReactContext) :
    RNCNaverMapOverlay<Marker>(reactContext), TrackableView {
    private var imageHolder: DraweeHolder<GenericDraweeHierarchy>? = null
    private var customView: View? = null
    private var customViewBitmap: Bitmap? = null
    private var lastImage: ReadableMap? = null
    private var imageRequestCanceller: ImageRequestCanceller? = null
    private var isImageSetFromSubview = false

    init {
        imageHolder = DraweeHolder.create(createDraweeHierarchy(), context)?.apply {
            onAttach()
        }
    }

    override fun onDetachedFromWindow() {
        imageRequestCanceller?.invoke()
        super.onDetachedFromWindow()
    }

    override val overlay: Marker by lazy {
        Marker().apply {
            setOnClickListener {
                reactContext.emitEvent(id) { surfaceId, reactTag ->
                    NaverMapOverlayTapEvent(
                        surfaceId,
                        reactTag
                    )
                }
                true
            }
        }
    }

    override fun addToMap(map: NaverMap) {
        overlay.map = map
    }

    override fun removeFromMap(map: NaverMap) {
        overlay.map = null
    }

    override fun onDropViewInstance() {
        overlay.map = null
        overlay.onClickListener = null
        imageHolder?.onDetach()
    }

    fun setCustomView(view: View, index: Int) {
        super.addView(view, index)
        isImageSetFromSubview = true
        if (view.layoutParams == null) {
            view.setLayoutParams(
                LayoutParams(
                    LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT
                )
            )
        }
        ViewChangesTracker.getInstance().addMarker(this)
        customView = view
        updateCustomView()
    }

    fun removeCustomView(index: Int) {
        customView = null
        ViewChangesTracker.getInstance().removeMarker(this)
        if (customViewBitmap != null && !customViewBitmap!!.isRecycled) customViewBitmap!!.recycle()
        isImageSetFromSubview = false
        setImage(lastImage)
        super.removeView(children.elementAt(index))
    }

    override fun requestLayout() {
        super.requestLayout()
        if (childCount == 0 && customView != null) {
            customView = null
            updateCustomView()
        }
    }

    private fun updateCustomView() {
        if (customViewBitmap == null || customViewBitmap!!.isRecycled ||
            customViewBitmap?.getWidth() != overlay.width ||
            customViewBitmap?.getHeight() != overlay.height
        ) {
            customViewBitmap = Bitmap.createBitmap(
                max(1, overlay.width),
                max(1, overlay.height),
                Bitmap.Config.ARGB_4444
            )
        }
        if (customView != null) {
            customViewBitmap?.also { bitmap ->
                bitmap.eraseColor(Color.TRANSPARENT)
                val canvas = Canvas(bitmap)
                draw(canvas)
                setOverlayImage(OverlayImage.fromBitmap(bitmap))
            }
        }
    }

    override fun updateCustomForTracking(): Boolean {
        return true
    }

    override fun update(width: Int, height: Int) {
        updateCustomView();
    }

    fun setImage(image: ReadableMap?) {
        lastImage = image
        if (isImageSetFromSubview) return
        imageRequestCanceller?.invoke()
        imageRequestCanceller = getOverlayImage(imageHolder!!, context, image) {
            setOverlayImage(it)
        }
    }

    private fun setOverlayImage(image: OverlayImage?) {
        overlay.icon =
            image ?: OverlayImage.fromBitmap(Bitmap.createBitmap(0, 0, Bitmap.Config.ARGB_8888))
    }

    private fun createDraweeHierarchy(): GenericDraweeHierarchy {
        return GenericDraweeHierarchyBuilder(resources)
            .setActualImageScaleType(ScalingUtils.ScaleType.FIT_CENTER)
            .setFadeDuration(0)
            .build()
    }
}