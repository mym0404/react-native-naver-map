- [English Documentation(not yet written)](/doc/en.md)

> [!WARNING]
> This project is ongoing. See the supporting table for progress.
>
>I want to release `1.0` until May, 2024

---

![rnnm](https://github.com/mj-studio-library/react-native-naver-map/assets/33388801/de8cbe13-1fc7-453b-88a4-41c23a2b2d8b)

리액트 네이티브 [Naver Map](https://www.ncloud.com/product/applicationService/maps) 컴포넌트입니다.

[![NPM - alpha](https://img.shields.io/badge/NPM-alpha-3af2f2)](https://) [![Android SDK - 3.18.0](https://img.shields.io/badge/Android_SDK-3.18.0-2ea44f)](https://) [![iOS SDK - 3.18.0](https://img.shields.io/badge/iOS_SDK-3.18.0-3522ff)](https://)

![preview](https://raw.githubusercontent.com/mym0404/image-archive/master/202404101826965.webp)

## 왜 이 라이브러리를 써야하나요?

이 프로젝트는 다음과 같은 목적을 가집니다.

### 1. 더 이상 관리되지 않는 [기존 라이브러리](https://github.com/QuadFlask/react-native-naver-map) 대체

기존 라이브러리의 모든 기능을 가져간 채로 API의 변경도 마이그레이션을 위해 되도록이면 지양하려고 했으나
개선이 필요한 부분들은 필요하다고 생각되면 바꿉니다. 예를 들어, 기존 라이브러리에서 `region`이 잘못 계산되고 있던 버그 등입니다.

Usage는 [`react-native-map`의 Usage](https://github.com/react-native-maps/react-native-maps/blob/master/docs/mapview.md)
를 되도록 따릅니다.

### 2. New Architecture Renderer Fabric 지원

> [!NOTE]
> Fabric을 지원한다고 Old Architecture를 지원하지 않는 것이 아닌 두 Architecture모두에서 작동하는 컴포넌트를 제작합니다.

### 3. Expo 지원

[expo config plugin](https://docs.expo.dev/modules/config-plugin-and-native-module-tutorial/)을 사용해
Expo환경에서도 빌드할 수 있습니다.

Expo Go에선 사용하지
못하지만 [development build](https://docs.expo.dev/develop/development-builds/introduction/), production
환경에서 사용할 수 있습니다.

### 4. 새롭게 만드는 이 라이브러리는 Naver Map SDK의 최신 기능들을 모두 지원합니다.

Seamless한 Props와 Command들로 Naver Map을 조작할 수 있습니다.

### 5. 성능 최적화

Event Coalescing를 통해 Native -> JS 로의 이벤트 중 쓸모없는 이벤트들을 걸러내 성능이 최적화가 됩니다.

## Usage

### Install

```shell
yarn add @mj-studio/react-native-naver-map
# for ios, you should install pods
```

### Android

더 자세한 설정은 [공식 문서](https://navermaps.github.io/android-map-sdk/guide-ko/1.html)를 참고해주세요.

#### 1. Maven repository import

Import Naver SDK Maven Repository to `android/build.gradle`.

```groovy
allprojects {
    repositories {
        maven {
            url "https://repository.map.naver.com/archive/maven"
        }
    }
}
```

#### 2. Add Naver SDK key to `AndroidManifest.xml`

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.naver.maps.map.CLIENT_ID"
            android:value="YOUR_CLIENT_ID_HERE" />
    </application>
</manifest>
```

#### 3. (Optional) Request location permission to `AndroidManifest.xml`

Currently, this package will request location permission for showing user's current location.

```xml
<manifest>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
</manifest>
```

### iOS

더 자세한 설정은 [공식 문서](https://navermaps.github.io/ios-map-sdk/guide-ko/1.html)를 참고해주세요.

#### 1. Set Naver SDK key to `info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
...
    <key>NMFClientId</key>
    <string>YOUR_CLIENT_ID_HERE</string>
...
<dict>
<plist>
```

#### 2. (Optional) Set location permission usage description to `info.plist`

Currently, this package will request location permission for showing user's current location.

```xml
<plist version="1.0">
<dict>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>{{your usage description}}</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>{{your usage description}}</string>
</dict>
</plist>
```

## Components

- ✅ Fully Supported
- ⚠️ Developing, lack of features yet
- 📦 Planned

|                                             | iOS | Android |
|---------------------------------------------|-----|---------|
| NaverMapView                                | ✅   | ✅       |
| NaverMapMarkerOverlay                       | ✅   | ✅       |
| Info Window(ToolTip for overlays)           | 📦  | 📦      |
| NaverMapCircleOverlay                       | ✅   | ✅       |
| NaverMapPolylineOverlay                     | ✅   | ✅       |
| NaverMapPolygonOverlay                      | ✅   | ✅       |
| NaverMapLocationOverlay(+ location feature) | 📦  | 📦      |
| NaverMapGroundOverlay                       | 📦  | 📦      |
| NaverMapPathOverlay                         | ✅   | ✅       |
| NaverMapMultipartPathOverlay                | 📦  | 📦      |
| NaverMapArrowPathOverlay                    | 📦  | 📦      |

## Props & Commands

- ✅ Done
- 📦 Planned
- ❓ Maybe Planned
- ❌ Not Planned

### `NaverMapView`

#### Props

|                          | iOS | Android |
|--------------------------|-----|---------|
| mapType                  | ✅   | ✅       |
| layerGroups              | ✅   | ✅       |
| camera                   | ✅   | ✅       |
| initialCamera            | ✅   | ✅       |
| region                   | ✅   | ✅       |
| initialRegion            | ✅   | ✅       |
| isIndoorEnabled          | ✅   | ✅       |
| isNightModeEnabled       | ✅   | ✅       |
| isLiteModeEnabled        | ✅   | ✅       |
| lightness                | ✅   | ✅       |
| buildingHeight           | ✅   | ✅       |
| symbolScale              | ✅   | ✅       |
| symbolPerspectiveRatio   | ✅   | ✅       |
| mapPadding               | ✅   | ✅       |
| isShowCompass            | ✅   | ✅       |
| isShowScaleBar           | ✅   | ✅       |
| isShowZoomControls       | ✅   | ✅       |
| isShowIndoorLevelPicker  | ✅   | ✅       |
| minZoom                  | ✅   | ✅       |
| maxZoom                  | ✅   | ✅       |
| extent                   | ✅   | ✅       |
| isExtentBoundedInKorea   | ✅   | ✅       |
| logoAlign                | ✅   | ✅       |
| logoMargin               | ✅   | ✅       |
| isLogoInteractionEnabled | ❌   | ❌       |
| isScrollGesturesEnabled  | ✅   | ✅       |
| isZoomGesturesEnabled    | ✅   | ✅       |
| isTiltGesturesEnabled    | ✅   | ✅       |
| isRotateGesturesEnabled  | ✅   | ✅       |
| isStopGesturesEnabled    | ✅   | ✅       |
| isShowLocationButton     | ✅   | ✅       |
| isUseTextureViewAndroid  | ❌   | ✅       |
| markerClustering         | 📦  | 📦      |
| fpsLimit                 | 📦  | 📦      |
| gestureFrictions         | 📦  | 📦      |

#### Events

|                 | iOS | Android |
|-----------------|-----|---------|
| onInitialized   | ✅   | ✅       |
| onOptionChanged | ✅   | ✅       |
| onCameraChanged | ✅   | ✅       |
| onTapMap        | ✅   | ✅       |
| onTapSymbol     | 📦  | 📦      |
| onAuthFailed    | ❌   | ❌       |

#### Commands

|                            | iOS | Android |
|----------------------------|-----|---------|
| animateCameraTo            | ✅   | ✅       |
| animateCameraBy            | ✅   | ✅       |
| animateRegionTo            | ✅   | ✅       |
| animateCameraWithTwoCoords | ✅   | ✅       |
| cancelAnimation            | ✅   | ✅       |
| screenToCoordinate         | 📦  | 📦      |
| coordinateToScreen         | 📦  | 📦      |

### Marker Common

#### Props

|                    | iOS | Android |
|--------------------|-----|---------|
| latitude           | ✅   | ✅       |
| longitude          | ✅   | ✅       |
| zIndex             | ✅   | ✅       |
| isHidden           | ✅   | ✅       |
| minZoom            | ✅   | ✅       |
| maxZoom            | ✅   | ✅       |
| isMinZoomInclusive | ✅   | ✅       |
| isMaxZoomInclusive | ✅   | ✅       |

#### Events

|           | iOS | Android | Web |
|-----------|-----|---------|-----|
| onTap     | ✅   | ✅       |     |
| onLongTap | ❌   | 📦      |     |

### `NaverMapMarkerOverlay`

#### Props

|                           | iOS | Android |
|---------------------------|-----|---------|
| width                     | ✅   | ✅       |
| height                    | ✅   | ✅       |
| anchor                    | ✅   | ✅       |
| angle                     | ✅   | ✅       |
| isFlatEnabled             | ✅   | ✅       |
| isIconPerspectiveEnabled  | ✅   | ✅       |
| alpha                     | ✅   | ✅       |
| isHideCollidedSymbols     | ✅   | ✅       |
| isHideCollidedMarkers     | ✅   | ✅       |
| isHideCollidedCaptions    | ✅   | ✅       |
| isForceShowIcon           | ✅   | ✅       |
| tintColor                 | ✅   | ✅       |
| image(default symbols)    | ✅   | ✅       |
| image(local image)        | ✅   | ✅       |
| image(network image)      | ✅   | ✅       |
| image(custom view)        | ✅   | ✅       |
| caption                   | ✅   | ✅       |
| caption-key               | ✅   | ✅       |
| caption-text              | ✅   | ✅       |
| caption-requestedWidth    | ✅   | ✅       |
| caption-align             | ✅   | ✅       |
| caption-offset            | ✅   | ✅       |
| caption-color             | ✅   | ✅       |
| caption-haloColor         | ✅   | ✅       |
| caption-textSize          | ✅   | ✅       |
| caption-minZoom           | ✅   | ✅       |
| caption-maxZoom           | ✅   | ✅       |
| caption-fontFamily        | ❓   | ❓       |
| subcaption                | ✅   | ✅       |
| subcaption-key            | ✅   | ✅       |
| subcaption-text           | ✅   | ✅       |
| subcaption-color          | ✅   | ✅       |
| subcaption-haloColor      | ✅   | ✅       |
| subcaption-textSize       | ✅   | ✅       |
| subcaption-requestedWidth | ✅   | ✅       |
| subcaption-minZoom        | ✅   | ✅       |
| subcaption-maxZoom        | ✅   | ✅       |

### `NaverMapPolylineOverlay`

#### Props

|          | iOS | Android |
|----------|-----|---------|
| coords   | ✅   | ✅       |
| width    | ✅   | ✅       |
| color    | ✅   | ✅       |
| pattern  | ✅   | ✅       |
| capType  | ✅   | ✅       |
| joinType | ✅   | ✅       |

### `NaverMapPathOverlay`

#### Props

|                        | iOS | Android |
|------------------------|-----|---------|
| coords                 | ✅   | ✅       |
| width                  | ✅   | ✅       |
| outlineWidth           | ✅   | ✅       |
| patternImage           | 📦  | 📦      |
| patternInterval        | ✅   | ✅       |
| progress               | ✅   | ✅       |
| color                  | ✅   | ✅       |
| passedColor            | ✅   | ✅       |
| outlineColor           | ✅   | ✅       |
| passedOutlineColor     | ✅   | ✅       |
| isHideCollidedSymbols  | ✅   | ✅       |
| isHideCollidedMarkers  | ✅   | ✅       |
| isHideCollidedCaptions | ✅   | ✅       |

### `NaverMapCircleOverlay`

#### Props

|              | iOS | Android |
|--------------|-----|---------|
| radius       | ✅   | ✅       |
| color        | ✅   | ✅       |
| outlineWidth | ✅   | ✅       |
| outlineColor | ✅   | ✅       |

### `NaverMapPolygonOverlay`

#### Props

|              | iOS | Android |
|--------------|-----|---------|
| coords       | ✅   | ✅       |
| holes        | ✅   | ✅       |
| color        | ✅   | ✅       |
| outlineWidth | ✅   | ✅       |
| outlineColor | ✅   | ✅       |

## Supporting Table - Architecture

|        | iOS | Android |
|--------|-----|---------|
| Bridge | ✅   | ✅       |
| Fabric | ✅️  | ✅️      |

## Milestone

- [x] Project Started (23.04.01)
- [x] Project Setup & Component Structure (23.04.03)
- [x] General Props & Commands (23.04.05)
- [x] Camera, Region, Commands, Events (23.04.07)
- [x] Implement Basic Overlays (23.04.10)
- [x] Location Service (23.04.10)
- [ ] Implement Advanced Overlays <- 🔥
- [x] Support Paper(Old Arch)
- [ ] Support Expo with config plugin(but you can use it already if your expo project has been ejected(prebuild) or creating config plugin manually)
- [x] Release
- [ ] Docs - Docusaurus docs

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the
development workflow.

## License

MIT
