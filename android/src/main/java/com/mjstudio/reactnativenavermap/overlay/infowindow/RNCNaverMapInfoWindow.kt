package com.mjstudio.reactnativenavermap.overlay.infowindow

import android.annotation.SuppressLint
import android.view.LayoutInflater
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

  override val overlay: InfoWindow by lazy {
    InfoWindow().apply {
      customAdapter = RNCNaverMapInfoWindowAdapter(reactContext)
      adapter = customAdapter as InfoWindow.Adapter
    }
  }

  override fun addToMap(map: NaverMap) {
    val marker = targetMarker
    if (marker != null) {
      overlay.open(marker)
    } else {
      val pos = position
      if (pos != null) {
        overlay.position = pos
        overlay.map = map
      }
    }
  }

  override fun removeFromMap(map: NaverMap) {
    overlay.close()
  }

  override fun onDropViewInstance() {
    overlay.close()
    customAdapter = null
  }

  fun setPosition(latLng: LatLng) {
    position = latLng
    overlay.position = latLng
  }

  fun setMarker(marker: Marker?) {
    targetMarker = marker
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

  fun setInfoWindowBackgroundColor(color: Int) {
    customAdapter?.backgroundColor = color
    customAdapter?.let { overlay.adapter = it as InfoWindow.Adapter }
  }

  inner class RNCNaverMapInfoWindowAdapter(
    private val context: ThemedReactContext,
  ) : InfoWindow.ViewAdapter() {
    var text: String? = null
    var textSize: Float = 14f
    var textColor: Int = android.graphics.Color.BLACK
    var backgroundColor: Int = android.graphics.Color.WHITE

    override fun getView(infoWindow: InfoWindow): View {
      val view = LayoutInflater.from(context).inflate(
        android.R.layout.simple_list_item_1,
        null,
      )
      val textView = view.findViewById<TextView>(android.R.id.text1)
      
      textView.text = text ?: ""
      textView.textSize = textSize
      textView.setTextColor(textColor)
      view.setBackgroundColor(backgroundColor)
      
      return view
    }
  }
}

