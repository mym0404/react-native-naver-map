- [English Documentation(not yet written)](/doc/en.md)

> [!TIP]
> This project is ready to use!

[![NPM](https://badge.fury.io/js/@mj-studio%2Freact-native-naver-map.svg)](https://badge.fury.io/js/@mj-studio%2Freact-native-naver-map) [![Android SDK - 3.18.0](https://img.shields.io/badge/Android_SDK-3.18.0-2ea44f)](https://) [![iOS SDK - 3.18.0](https://img.shields.io/badge/iOS_SDK-3.18.0-3522ff)](https://)

---

![rnnm](https://github.com/mj-studio-library/react-native-naver-map/assets/33388801/de8cbe13-1fc7-453b-88a4-41c23a2b2d8b)

리액트 네이티브 [Naver Map](https://www.ncloud.com/product/applicationService/maps) 컴포넌트입니다.

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

### 4. 새롭게 만드는 이 라이브러리는 Naver Map SDK의 최신 기능들을 모두 지원합니다

Seamless한 Props와 Command들로 Naver Map을 조작할 수 있습니다.

### 5. 성능 최적화

Event Coalescing를 통해 Native -> JS 로의 이벤트 중 쓸모없는 이벤트들을 걸러내 성능이 최적화가 됩니다.

## Usage

### Install

```shell
# npm
npm install --save @mj-studio/react-native-naver-map

# yarn
yarn add @mj-studio/react-native-naver-map

# expo
npx expo install @mj-studio/react-native-naver-map
```

For ios, you should install pods

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

### Expo

#### 1. Add `expo-build-properties` package

This is for inject naver maven repository.

```shell
npx expo install expo-build-properties
```

#### 2. Add Config Plugin into `app.json`

```json
{
  ...
  "plugins": [
    [
      "@mj-studio/react-native-naver-map",
      {
        "client_id": "{{Naver Map Client Key}}",
        // (optional)
        "android": {
          "ACCESS_FINE_LOCATION": true,
          "ACCESS_COARSE_LOCATION": true
        },
        // (optional)
        "ios": {
          "NSLocationAlwaysUsageDescription": "{{ your location usage description }}",
          "NSLocationWhenInUseUsageDescription": "{{ your location usage description }}"
        }
      }
    ],
    [
      "expo-build-properties",
      {
        "android": {
          "extraMavenRepos": ["https://repository.map.naver.com/archive/maven"]
        }
      }
    ],
    ...
  ]
}
```

Expo는 위에서 설명된 Android, iOS의 설정법이 필요하지 않습니다.

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
| locale                   | 📦  | 📦      |

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

#### 마커의 종류와 성능

마커의 종류는 총 네가지입니다.

1. default symbol (green, red, gray, ...)

```js
image={'green'}
```

2. local resources (`ImageSourcePropType` of react native)

이는 추후에 더 나은 성능을 위해 Android, iOS native resource를 사용해 screen density에 따라 최적의 마커가 선택되게 할 수 있는 로직을 구현하려 합니다.

```js
image={require('./marker.png')}
```

3. network image

```js
image={{uri: 'https://example.com/image.png'}}
```

>[!WARNING]
>현재 header auth같은 객채 내의 다른 속성은 지원되지 않습니다.

4. custom react view

>[!IMPORTANT]
>이 타입은 많이 생성될 시 성능에 굉장히 영향을 미칠 수 있습니다.
>아직은 단순하게만 사용하시거나 되도록이면 이미지를 사용하는 것을 추천드립니다.

현재 이 타입은 Android에선 `react-native-map`의 구현체를 비슷하게 가져와 React Native의 Shadow Node를 조금 커스텀해서 자식의 위치를 추적한다음 실제 Android의 `View`를 삽입해줍니다.

iOS에선 단순히 `UIView`를 `UIImage`로 캔버스에 그려 표시해줍니다.

두 방법 모두가 이미지 캐싱이 아직 지원되지 않고(추후에 `reuseableIdentifier`같은 속성으로 지원이 가능할 것으로 보입니다), 마커 하나당 많은 리소스를 차지하게 됩니다.

#### Props

|                           | iOS                                                | Android |
|---------------------------|----------------------------------------------------|---------|
| width                     | ✅                                                  | ✅       |
| height                    | ✅                                                  | ✅       |
| anchor                    | ✅                                                  | ✅       |
| angle                     | ✅                                                  | ✅       |
| isFlatEnabled             | ✅                                                  | ✅       |
| isIconPerspectiveEnabled  | ✅                                                  | ✅       |
| alpha                     | ✅                                                  | ✅       |
| isHideCollidedSymbols     | ✅                                                  | ✅       |
| isHideCollidedMarkers     | ✅                                                  | ✅       |
| isHideCollidedCaptions    | ✅                                                  | ✅       |
| isForceShowIcon           | ✅                                                  | ✅       |
| tintColor                 | ✅                                                  | ✅       |
| image(default symbols)    | ✅                                                  | ✅       |
| image(local image)        | ✅                                                  | ✅       |
| image(network image)      | ✅                                                  | ✅       |
| image(custom view)        | (new arch ✅) (old arch 📦, not a techinical issue) | ✅       |
| caption                   | ✅                                                  | ✅       |
| caption-key               | ✅                                                  | ✅       |
| caption-text              | ✅                                                  | ✅       |
| caption-requestedWidth    | ✅                                                  | ✅       |
| caption-align             | ✅                                                  | ✅       |
| caption-offset            | ✅                                                  | ✅       |
| caption-color             | ✅                                                  | ✅       |
| caption-haloColor         | ✅                                                  | ✅       |
| caption-textSize          | ✅                                                  | ✅       |
| caption-minZoom           | ✅                                                  | ✅       |
| caption-maxZoom           | ✅                                                  | ✅       |
| caption-fontFamily        | ❓                                                  | ❓       |
| subcaption                | ✅                                                  | ✅       |
| subcaption-key            | ✅                                                  | ✅       |
| subcaption-text           | ✅                                                  | ✅       |
| subcaption-color          | ✅                                                  | ✅       |
| subcaption-haloColor      | ✅                                                  | ✅       |
| subcaption-textSize       | ✅                                                  | ✅       |
| subcaption-requestedWidth | ✅                                                  | ✅       |
| subcaption-minZoom        | ✅                                                  | ✅       |
| subcaption-maxZoom        | ✅                                                  | ✅       |

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
- [x] Support Paper(Old Arch) (23.04.11)
- [x] Release (23.04.11)
- [x] Support Expo with config plugin (23.04.12)
- [x] Docs
- [ ] Implement Advanced Overlays <- 🔥

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the
development workflow.

## License

MIT
