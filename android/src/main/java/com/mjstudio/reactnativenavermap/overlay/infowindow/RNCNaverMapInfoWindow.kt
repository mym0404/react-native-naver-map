package com.mjstudio.reactnativenavermap.overlay.infowindow

import android.annotation.SuppressLint
import android.view.View
import android.widget.TextView
import com.facebook.react.uimanager.ThemedReactContext
import com.mjstudio.reactnativenavermap.overlay.RNCNaverMapOverlay
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.InfoWindow
import com.naver.maps.map.overlay.Marker

@SuppressLint("ViewConstructor")
class RNCNaverMapInfoWindow(
  private val reactContext: ThemedReactContext,
) : RNCNaverMapOverlay<InfoWindow>(reactContext) {
  private var targetMarker: Marker? = null
  private var position: LatLng? = null
  private var customAdapter: RNCNaverMapInfoWindowAdapter? = null
  private var markerIdentifier: String? = null
  private var shouldBeOpen: Boolean = true
  private var currentMap: NaverMap? = null
  private var parentMapView: com.mjstudio.reactnativenavermap.mapview.RNCNaverMapView? = null

  override val overlay: InfoWindow by lazy {
    InfoWindow().apply {
      customAdapter = RNCNaverMapInfoWindowAdapter(reactContext)
      adapter = customAdapter as InfoWindow.Adapter
    }
  }

  override fun addToMap(map: NaverMap) {
    currentMap = map
    updateInfoWindowState()
  }

  override fun removeFromMap(map: NaverMap) {
    overlay.close()
    currentMap = null
  }

  fun setParentMapView(mapView: com.mjstudio.reactnativenavermap.mapview.RNCNaverMapView) {
    parentMapView = mapView
  }

  private fun updateInfoWindowState() {
    if (!shouldBeOpen) {
      overlay.close()
      return
    }

    val map = currentMap ?: return

    // Try to find marker by identifier first
    val identifier = markerIdentifier
    if (identifier != null) {
      val markerView = parentMapView?.markerRegistry?.get(identifier)
      if (markerView != null) {
        // Open on marker (marker position is used automatically)
        overlay.open(markerView.overlay)
        return
      }
    }

    // Fall back to position
    val pos = position
    if (pos != null) {
      overlay.position = pos
      overlay.map = map
    }
  }

  override fun onDropViewInstance() {
    overlay.close()
    customAdapter = null
  }

  fun setPosition(latLng: LatLng) {
    position = latLng
    updateInfoWindowState()
  }

  fun setMarkerIdentifier(identifier: String?) {
    markerIdentifier = identifier
    updateInfoWindowState()
  }

  fun setIsOpen(isOpen: Boolean) {
    shouldBeOpen = isOpen
    updateInfoWindowState()
  }

  fun setText(text: String?) {
    customAdapter?.text = text
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setTextSize(size: Float) {
    customAdapter?.textSize = size
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setTextColor(color: Int) {
    customAdapter?.textColor = color
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setFontWeight(weight: Int) {
    customAdapter?.fontWeight = weight
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowBackgroundColor(color: Int) {
    customAdapter?.backgroundColor = color
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowBorderRadius(radius: Float) {
    customAdapter?.borderRadius = radius
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowBorderWidth(width: Float) {
    customAdapter?.borderWidth = width
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowBorderColor(color: Int) {
    customAdapter?.borderColor = color
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowPaddingHorizontal(padding: Float) {
    customAdapter?.paddingHorizontal = padding
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  fun setInfoWindowPaddingVertical(padding: Float) {
    customAdapter?.paddingVertical = padding
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  inner class RNCNaverMapInfoWindowAdapter(
    private val context: ThemedReactContext,
  ) : InfoWindow.ViewAdapter() {
    var text: String? = null
    var textSize: Float = 14f
    var textColor: Int = android.graphics.Color.BLACK
    var fontWeight: Int = 400
    var backgroundColor: Int = android.graphics.Color.WHITE
    var borderRadius: Float = 5f
    var borderWidth: Float = 1f
    var borderColor: Int = android.graphics.Color.parseColor("#cccccc")
    var paddingHorizontal: Float = 10f
    var paddingVertical: Float = 10f

    override fun getView(infoWindow: InfoWindow): View {
      val paddingHorizontalPx = this@RNCNaverMapInfoWindowAdapter.paddingHorizontal.toInt()
      val paddingVerticalPx = this@RNCNaverMapInfoWindowAdapter.paddingVertical.toInt()

      val textView = TextView(context).apply {
        this.text = this@RNCNaverMapInfoWindowAdapter.text ?: ""
        this.textSize = this@RNCNaverMapInfoWindowAdapter.textSize
        this.setTextColor(this@RNCNaverMapInfoWindowAdapter.textColor)

        // Font weight
        val typeface = when {
          this@RNCNaverMapInfoWindowAdapter.fontWeight >= 700 -> android.graphics.Typeface.BOLD
          else -> android.graphics.Typeface.NORMAL
        }
        this.setTypeface(null, typeface)

        // Gravity
        this.gravity = android.view.Gravity.CENTER
      }

      // Container with border, background and padding
      val container = android.widget.FrameLayout(context).apply {
        // Add padding to container (horizontal and vertical separately)
        this.setPadding(paddingHorizontalPx, paddingVerticalPx, paddingHorizontalPx, paddingVerticalPx)

        // Add text view with wrap content
        addView(
          textView,
          android.widget.FrameLayout.LayoutParams(
            android.widget.FrameLayout.LayoutParams.WRAP_CONTENT,
            android.widget.FrameLayout.LayoutParams.WRAP_CONTENT,
          ),
        )

        // Background and border using GradientDrawable
        val drawable = android.graphics.drawable.GradientDrawable().apply {
          setColor(this@RNCNaverMapInfoWindowAdapter.backgroundColor)
          cornerRadius = this@RNCNaverMapInfoWindowAdapter.borderRadius
          setStroke(
            this@RNCNaverMapInfoWindowAdapter.borderWidth.toInt(),
            this@RNCNaverMapInfoWindowAdapter.borderColor,
          )
        }
        background = drawable
      }

      return container
    }
  }
}
