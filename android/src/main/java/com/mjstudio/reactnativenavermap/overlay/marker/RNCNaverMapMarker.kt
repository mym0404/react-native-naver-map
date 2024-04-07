package com.mjstudio.reactnativenavermap.overlay.marker

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.Animatable
import android.net.Uri
import android.view.View
import androidx.core.view.children
import com.airbnb.android.react.maps.TrackableView
import com.airbnb.android.react.maps.ViewChangesTracker
import com.facebook.common.references.CloseableReference
import com.facebook.datasource.DataSource
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.drawee.controller.BaseControllerListener
import com.facebook.drawee.drawable.ScalingUtils
import com.facebook.drawee.generic.GenericDraweeHierarchy
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder
import com.facebook.drawee.interfaces.DraweeController
import com.facebook.drawee.view.DraweeHolder
import com.facebook.imagepipeline.image.CloseableImage
import com.facebook.imagepipeline.image.CloseableStaticBitmap
import com.facebook.imagepipeline.image.ImageInfo
import com.facebook.imagepipeline.request.ImageRequestBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.event.NaverMapOverlayTapEvent
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.mjstudio.reactnativenavermap.util.emitEvent
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.OverlayImage
import com.naver.maps.map.util.MarkerIcons
import debugE
import kotlin.math.max


@SuppressLint("ViewConstructor")
class RNCNaverMapMarker(val reactContext: ThemedReactContext) :
    RNCNaverMapOverlay<Marker>(reactContext), TrackableView {
    private var imageHolder: DraweeHolder<GenericDraweeHierarchy>? = null
    private var customView: View? = null
    private var customViewBitmap: Bitmap? = null
    private var lastUri: String? = null

    init {
        imageHolder = DraweeHolder.create(createDraweeHierarchy(), context)?.apply {
            onAttach()
        }
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
        setImage(lastUri)
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

    fun setImage(uri: String?) {
        lastUri = uri
        debugE(uri)
        uri?.let { uri ->
            val defaultIcons = when (uri) {
                "blue" -> MarkerIcons.BLUE
                "gray" -> MarkerIcons.GRAY
                "green" -> MarkerIcons.GREEN
                "lightblue" -> MarkerIcons.LIGHTBLUE
                "pink" -> MarkerIcons.PINK
                "red" -> MarkerIcons.RED
                "yellow" -> MarkerIcons.YELLOW
                "black" -> MarkerIcons.BLACK
                "lowDensityCluster" -> MarkerIcons.CLUSTER_LOW_DENSITY
                "mediumDensityCluster" -> MarkerIcons.CLUSTER_MEDIUM_DENSITY
                "highDensityCluster" -> MarkerIcons.CLUSTER_HIGH_DENSITY
                else -> null
            }
            if (defaultIcons != null) {
                setOverlayImage(defaultIcons)
                return
            }
            val overlayImage = OverlayImages[uri]
            if (overlayImage != null) {
                setOverlayImage(overlayImage)
                return
            }


            if (uri.startsWith("http://") ||
                uri.startsWith("https://") ||
                uri.startsWith("file://") ||
                uri.startsWith("asset://")
            ) {
                val imageRequest = ImageRequestBuilder
                    .newBuilderWithSource(Uri.parse(uri))
                    .build()
                val dataSource: DataSource<CloseableReference<CloseableImage>> =
                    Fresco.getImagePipeline()
                        .fetchDecodedImage(imageRequest, this)
                val controller: DraweeController = Fresco.newDraweeControllerBuilder()
                    .setImageRequest(imageRequest)
                    .setControllerListener(object : BaseControllerListener<ImageInfo?>() {
                        override fun onFinalImageSet(
                            id: String,
                            imageInfo: ImageInfo?,
                            animatable: Animatable?
                        ) {
                            var imageReference: CloseableReference<CloseableImage>? = null
                            var overlayImage: OverlayImage? = null
                            try {
                                imageReference = dataSource.result
                                if (imageReference != null) {
                                    val image = imageReference.get()
                                    if (image is CloseableStaticBitmap) {
                                        var bitmap: Bitmap? = image.underlyingBitmap
                                        if (bitmap != null) {
                                            bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true)
                                            overlayImage = OverlayImage.fromBitmap(bitmap)
                                            OverlayImages.put(uri, overlayImage)
                                        }
                                    }
                                }
                            } finally {
                                dataSource.close()
                                if (imageReference != null) {
                                    CloseableReference.closeSafely(imageReference)
                                }
                            }
                            overlayImage?.let { setOverlayImage(it) }
                        }
                    })
                    .setOldController(imageHolder!!.controller)
                    .build()
                imageHolder!!.setController(controller)
            } else {
                OverlayImage.fromResource(getRidFromName(uri)).run {
                    OverlayImages.put(uri, this)
                    setOverlayImage(this)
                }
            }
        }
    }

    private fun setOverlayImage(image: OverlayImage?) {
        overlay.icon = image ?: MarkerIcons.GREEN
    }

    private fun createDraweeHierarchy(): GenericDraweeHierarchy {
        return GenericDraweeHierarchyBuilder(resources)
            .setActualImageScaleType(ScalingUtils.ScaleType.FIT_CENTER)
            .setFadeDuration(0)
            .build()
    }

    @SuppressLint("DiscouragedApi")
    private fun getRidFromName(name: String): Int {
        return context.resources.getIdentifier(name, "drawable", context.packageName)
    }
}