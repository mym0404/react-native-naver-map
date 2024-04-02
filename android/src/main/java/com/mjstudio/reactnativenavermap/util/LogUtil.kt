import android.util.Log
import com.mjstudio.reactnativenavermap.BuildConfig

private fun debugE(tag: String, message: Any?) {
    if (BuildConfig.DEBUG) Log.e(tag, "⭐️" + message.toString())
}

fun debugE(message: Any?) {
    debugE("RNCNaverMapView", message)
}