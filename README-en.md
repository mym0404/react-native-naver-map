<p align="center">
  <a href="https://mym0404.github.io/react-native-naver-map/">
    <img width="160px" src="https://raw.githubusercontent.com/mym0404/image-archive/master/202404241422605.webp"><br/>
  </a>
  <h1 align="center">React Native Naver Map</h1>
  <p align="center">
  <a href="https://www.npmjs.com/package/@mj-studio/react-native-naver-map"><img src="https://img.shields.io/npm/dm/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="NPM downloads"></a>
  <a href="https://www.npmjs.com/package/@mj-studio/react-native-naver-map"><img src="https://img.shields.io/npm/v/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="NPM version"></a>
  <img src="https://img.shields.io/badge/Android_SDK-3.21.0-2ea44f?style=flat-square" alt="Android SDK version">
  <img src="https://img.shields.io/badge/iOS_SDK-3.21.0-3522ff?style=flat-square" alt="iOS SDK version">
  <a href="/LICENSE"><img src="https://img.shields.io/npm/l/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="License"></a>
  <h3 align="center">Bring Naver Map to Your React Fingertips</h3>
  </p>
</p>


- [Documentation(ko)](https://mym0404.github.io/react-native-naver-map/interfaces/NaverMapViewProps.html)
- [Tutorial(ko) 1 - Installation, Register Console API](https://medium.com/mj-studio/%EB%A6%AC%EC%95%A1%ED%8A%B8-%EB%84%A4%EC%9D%B4%ED%8A%B8%EB%B8%8C%EB%A1%9C-%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%A7%80%EB%8F%84-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-1-%EC%84%A4%EC%B9%98%EC%99%80-%ED%82%A4-%EB%B0%9C%EA%B8%89-%EB%B0%9B%EA%B8%B0-f826d8c0644d)
- [Tutorial(ko) 2 - Camrae, Position of Map](https://medium.com/mj-studio/%EB%A6%AC%EC%95%A1%ED%8A%B8-%EB%84%A4%EC%9D%B4%ED%8A%B8%EB%B8%8C%EB%A1%9C-%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%A7%80%EB%8F%84-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-2-%EC%B9%B4%EB%A9%94%EB%9D%BC-%EC%9C%84%EC%B9%98-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0-ea39843b31d2)

> [!NOTE]
> The code comments and Documentation are unfortunately all written in Korean.
> However, you can use a translator or infer the meaning of the props' names and default values to easily understand and use them, even without knowing Korean.
>
> Always remember that you can refer to the Naver Map SDK's [English Official Documentation](https://navermaps.github.io/ios-map-sdk/guide-en/1.html) to get a general idea of how to use it.


<img src="https://raw.githubusercontent.com/mym0404/image-archive/master/202404240329848.gif" width="400" alt="preview">

> ![IMPORTANT]
> Since version `2.4.x`, [New released Maps Naver API](https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1) has been supported.


## Highlights

### 1. New Architecture Fabric

Support Table

| React Native Naver Map | React Native                        | Note                                                                                                                                                                          |
|------------------------|-------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| &ge;`2.1.0`            | &ge; `0.74`                         | Drop Bridge Support & `0.74` required                                                                                                                                         |
| &ge;`2.x`              | New Architecture Only               | Drop Old Architecture Support, [**You should turn off bridgeless if want to render http web image marker**](https://github.com/mym0404/react-native-naver-map/discussions/72) |
| &lt;`2.x`              | Old Architecture + New Architecture |                                                                                                                                                                               |


> [!IMPORTANT]
> The `1.x` version supports the Old Architecture (Bridge), but starting from the `2.x` version, support for it will be discontinued. If your project has not transitioned to the New Architecture, please use the [`1.x` version](https://github.com/mym0404/react-native-naver-map/tree/v1.5.6).

### 2. Detailed API Documentation

We have structured the [API Docs](https://mym0404.github.io/react-native-naver-map/interfaces/NaverMapViewProps.html) which describe almost all types.

We have maximized readability and you can check the usage of the desired component types, `Prop`, and `Ref` on the `component` side.

### 3. Expo Support

Using the [expo config plugin](https://docs.expo.dev/modules/config-plugin-and-native-module-tutorial/), you can easily build in the Expo environment regardless of the architecture.

While it cannot be used in Expo Go or Snack, it can easily be used in the [development build](https://docs.expo.dev/develop/development-builds/introduction/) and production environments.

### 4. Marker Performance + Variants

> [!IMPORTANT]
> `[iOS, Android] x [new arch, old arch] x [debug, release]`
> **We have tested that it renders correctly under all 8 conditions.**

-  Basic symbols provided by Naver Map (`symbol`)
-  Local image resources of the React Native project
-  Local image resources of the native project optimized for performance - Android (Drawable), iOS (Bundle Asset)
-  HTTP network web images
-  React Native Custom View passed as `children`

### 5. Seamless API Porting from Native Naver Map SDK

We support the latest version of the SDK, and you can manipulate the latest features of Naver Map using Props and Commands.


## Install

```shell
# npm
npm install --save @mj-studio/react-native-naver-map

# yarn
yarn add @mj-studio/react-native-naver-map

# expo
npx expo install @mj-studio/react-native-naver-map
```

For iOS, you should install pods

### Android

For more detailed settings, please refer to the [Official Documentation](https://navermaps.github.io/android-map-sdk/guide-ko/1.html).

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
            android:name="com.naver.maps.map.NCP_KEY_ID"
            android:value="YOUR_CLIENT_ID_HERE" />
      <!-- (legacy) For map API customers who used the AI NAVER API before 2025.04.17 -->
      <!-- https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1 -->
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
  # optional for background location
  <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
</manifest>
```

Detailed information related to permissions is listed [below](#permission).

### iOS

For more detailed settings, please refer to the [Official Documentation](https://navermaps.github.io/ios-map-sdk/guide-ko/1.html).

#### 1. Set Naver SDK key to `info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NMFNcpKeyId</key>
  <string>YOUR_CLIENT_ID_HERE</string>
  <!-- (legacy) For map API customers who used the AI NAVER API before 2025.04.17 -->
  <!-- https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1 -->
  <key>NMFClientId</key>
  <string>YOUR_CLIENT_ID_HERE</string>
<dict>
<plist>
```

#### 2. (Optional) Set location permission usage description to `info.plist`

Currently, this package will request location permission for showing user's current location.

```xml
<plist version="1.0">
<dict>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>{{usage description}}</string>
  <key>NSLocationTemporaryUsageDescriptionDictionary</key>
  <dict>
    <key>{{your purpose key}}</key>
    <string>{{usage description}}</string>
  </dict>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>{{usage description}}</string>
</dict>
</plist>
```

Detailed information related to permissions is listed [below](#permission).

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
        // (optional, you can set with expo-location instead of this package)
        "android": {
          "ACCESS_FINE_LOCATION": true,
          "ACCESS_COARSE_LOCATION": true,
          "ACCESS_BACKGROUND_LOCATION": true
        },
        // (optional, you can set with expo-location instead of this package)
        "ios": {
          "NSLocationAlwaysAndWhenInUseUsageDescription": "{{ your location usage description }}",
          "NSLocationWhenInUseUsageDescription": "{{ your location usage description }}",
          "NSLocationTemporaryUsageDescriptionDictionary": {
            "purposeKey": "{{ your purpose key }}",
            "usageDescription": "{{ your location usage description }}"
          }
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

Expo does not require the setup methods for Android and iOS described above.

Detailed information related to permissions is listed [below](#permission).

## Example

```tsx
const jejuRegion: Region = {
  latitude: 33.20530773,
  longitude: 126.14656715029,
  latitudeDelta: 0.38,
  longitudeDelta: 0.8,
};
...

<NaverMapView
  ref={ref}
  style={{ flex: 1 }}
  mapType={mapType}
  layerGroups={{
    BUILDING: true,
    BICYCLE: false,
    CADASTRAL: false,
    MOUNTAIN: false,
    TRAFFIC: false,
    TRANSIT: false,
  }}
  initialRegion={jejuRegion}
  isIndoorEnabled={indoor}
  symbolScale={symbolScale}
  lightness={lightness}
  isNightModeEnabled={nightMode}
  isShowCompass={compass}
  isShowIndoorLevelPicker={indoorLevelPicker}
  isShowScaleBar={scaleBar}
  isShowZoomControls={zoomControls}
  isShowLocationButton={myLocation}
  isExtentBoundedInKorea
  logoAlign={'TopRight'}
  locale={'ja'}
  onInitialized={() => console.log('initialized!')}
  onOptionChanged={() => console.log('Option Changed!')}
  onCameraChanged={(args) => console.log(`Camera Changed: ${formatJson(args)}`)}
  onTapMap={(args) => console.log(`Map Tapped: ${formatJson(args)}`)}
>
  <NaverMapMarkerOverlay
    latitude={33.3565607356}
    longitude={126.48599018}
    onTap={() => console.log(1)}
    anchor={{ x: 0.5, y: 1 }}
    caption={{
      key: '1',
      text: 'hello',
    }}
    subCaption={{
      key: '1234',
      text: '123',
    }}
    width={100}
    height={100}
  />
  {/* Not Working in iOS Old Architecture Yet */}
  <NaverMapMarkerOverlay*
    latitude={33.4165607356}
    longitude={126.48599018}
    onTap={() => console.log(1)}
    anchor={{ x: 0.5, y: 1 }}
    caption={{
      key: '1',
      text: 'hello',
    }}
    subCaption={{
      key: '1234',
      text: '123',
    }}
    width={100}
    height={100}
  >
    <View style={{ width: 100, height: 100, backgroundColor: 'red' }} />
  </NaverMapMarkerOverlay>
  <NaverMapMarkerOverlay
    latitude={33.2565607356}
    longitude={127.8599018}
    onTap={() => console.log(1)}
    anchor={{ x: 0.5, y: 1 }}
    caption={{
      key: '1',
      text: 'hello',
    }}
    subCaption={{
      key: '1234',
      text: '123',
    }}
    width={100}
    height={100}
    image={{ uri: 'https://picsum.photos/100/100' }}
  />
  <NaverMapCircleOverlay
    latitude={33.17827398}
    longitude={126.349895729}
    radius={50000}
    color={'#f2f1'}
    outlineColor={'#aaa'}
    outlineWidth={2}
    onTap={() => console.log('hi')}
  />
  <NaverMapPolygonOverlay
    outlineWidth={5}
    outlineColor={'#f2f2'}
    color={'#0068'}
    coords={[
      { latitude: 33.2249594, longitude: 126.54180047 },
      { latitude: 33.25683311547, longitude: 126.18193 },
      { latitude: 33.3332807, longitude: 126.838389399 },
    ]}
  />
  <NaverMapPathOverlay
    coords={[
      { latitude: 33.5249594, longitude: 126.24180047 },
      { latitude: 33.25683311547, longitude: 126.18193 },
      { latitude: 33.3332807, longitude: 126.838389399 },
    ]}
    width={8}
    color={'red'}
    progress={-0.6}
    passedColor={'green'}
  />
</NaverMapView>
```

## Usage

### API Documentation

[Documentation](https://mym0404.github.io/react-native-naver-map/interfaces/NaverMapViewProps.html)

All codes have JSDoc comments inserted, so you can start developing without Documentation.

However, if you want to check exactly what types exist and what properties they mean, please refer to the [Documentation](https://mym0404.github.io/react-native-naver-map/interfaces/NaverMapViewProps.html).

### Permission

Permissions should be managed directly within the app by default.

We will look at an example of using the [react-native-permissions](https://github.com/zoontek/react-native-permissions) library to manage this.

>[!TIP]
>If you are an Expo user, you can indicate that you will be using permissions by referring to [expo-location](https://docs.expo.dev/versions/latest/sdk/location/).
>Therefore, most of the content below is not necessary, and after examining what permissions are needed and how to specify them, you should follow the usage at [expo-location](https://docs.expo.dev/versions/latest/sdk/location/).

First, install and set up the package:

```shell
yarn add react-native-permissions
```

Please refer to the [Usage](https://github.com/zoontek/react-native-permissions#setup) directly for the platform-specific setup method for `react-native-permission` and properly modify `Podfile(iOS)`, `AndroidManifest.xml(Android)`.

#### iOS

iOS is involved with three types of permissions:

-  `NSLocationAlwaysAndWhenInUseUsageDescription(>= iOS 11)`
   - Allows the app to access location information both in the foreground and the background.
   - From iOS 11, this key should be used instead of NSLocationAlwaysUsageDescription.
-  `NSLocationWhenInUseUsageDescription`
   - Allows the app to access location information when it is in the foreground (i.e., when the user is actively using the app).
-  `NSLocationTemporaryUsageDescriptionDictionary(>= iOS 14)`
   - Allows the app temporarily access to precise location data. This is used when the app only needs precise location for certain tasks.

>[!TIP]
>If your app does not support devices below iOS 11, you do not need to list `NSLocationAlwaysUsageDescription`.
>If it does support, then you should set it as well.

Then, in the `Podfile`, you allow the following three permissions:

```ruby
setup_permissions([
  'LocationAccuracy',
  'LocationAlways',
  'LocationWhenInUse',
  ...
])
```

Activate the `Background Modes` tab in the app target in Xcode and select the `Location updates` option.

This is necessary for receiving location in the background, so it does not need to be set if it is not required.

![Xcode config result](https://raw.githubusercontent.com/mym0404/image-archive/master/202404161737676.webp)

#### Android

The `FusedLocationSource` used internally by the Naver Map SDK automatically makes a permission request the moment the user sets the [isShowLocationButton prop](https://mym0404.github.io/react-native-naver-map/interfaces/NaverMapViewProps.html#isShowLocationButton) to `true`.

Android can implement permissions relatively simply.

Just specify the following permissions in `AndroidManifest.xml`:

-  `android.permission.ACCESS_FINE_LOCATION`
   - Permission for precise location information
-  `android.permission.ACCESS_COARSE_LOCATION`
   - Permission for approximate location information
-  `android.permission.ACCESS_BACKGROUND_LOCATION`
   - Permission for location information in the background

#### Code-based Permission Requests

If you have completed the configuration up to this point, you can request permissions in screens that require a map as follows:

For Bare RN Project or ejected Expo (`react-native-permissions`)
```tsx
// useEffect is simply used to be called when the component mounts..
useEffect(() => {
  if (Platform.OS === 'ios') {
    request(PERMISSIONS.IOS.LOCATION_ALWAYS).then((status) => {
      console.log(`Location request status: ${status}`);
      if (status === 'granted') {
        requestLocationAccuracy({
          purposeKey: 'common-purpose', // replace your purposeKey of Info.plist
        })
          .then((accuracy) => {
            console.log(`Location accuracy is: ${accuracy}`);
          })
          .catch((e) => {
            console.error(`Location accuracy request has been failed: ${e}`);
          });
      }
    });
  }
  if (Platform.OS === 'android') {
    requestMultiple([
      PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
      PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION,
    ])
      .then((status) => {
        console.log(`Location request status: ${status}`);
      })
      .catch((e) => {
        console.error(`Location request has been failed: ${e}`);
      });
  }
}, []);
```

For Expo (`expo-location`)
```tsx
import * as Location from 'expo-location'

...
useEffect(() => {
  (async () => {
    try {
      const {granted} = await Location.requestForegroundPermissionsAsync();
      /**
       * Note: Foreground permissions should be granted before asking for the background permissions
       * (your app can't obtain background permission without foreground permission).
       */
      if(granted) {
        await Location.requestBackgroundPermissionsAsync();
      }
    } catch(e) {
      console.error(`Location request has been failed: ${e}`);
    }
  })();
}, []);
```

![permission-result-1](https://raw.githubusercontent.com/mym0404/image-archive/master/202404161733072.webp)
![permission-result-2](https://raw.githubusercontent.com/mym0404/image-archive/master/202404161737907.webp)

## Components

> [!NOTE]
> Descriptions for most types and props are also written in the code comments, and this project supports TypeScript, so checking only in the code will suffice for use.

-  ✅ Fully Supported
-  ⚠️ Developing, lack of features yet
-  📦 Planned

| Component                                                                                     | iOS | Android | Description       |
|-----------------------------------------------------------------------------------------------|-----|---------|-------------------|
| [NaverMapView](https://navermaps.github.io/android-map-sdk/guide-ko/2-3.html)                 | ✅   | ✅       | Map               |
| [NaverMapMarkerOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-2.html)        | ✅   | ✅       | Marker Overlay    |
| [Info Window](https://navermaps.github.io/android-map-sdk/guide-ko/5-3.html)                  | 📦  | 📦      | Callout Overlay, Tooltip |
| [NaverMapCircleOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-4.html)        | ✅   | ✅       | Circle Overlay    |
| [NaverMapPolylineOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-4.html)      | ✅   | ✅       | Polyline Overlay  |
| [NaverMapPolygonOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-4.html)       | ✅   | ✅       | Polygon           |
| [NaverMapLocationOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-5.html)      | 📦  | 📦      | Custom Location Overlay |
| [NaverMapGroundOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-6.html)        | ✅   | ✅       | Ground Overlay    |
| [NaverMapPathOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-7.html)          | ✅   | ✅       | Path Overlay      |
| [NaverMapMultipartPathOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-7.html) | 📦  | 📦      | Multipath Overlay |
| [NaverMapArrowPathOverlay](https://navermaps.github.io/android-map-sdk/guide-ko/5-7.html)     | ✅   | ✅       | Arrow Path Overlay |

## Marker Image Types and Performance

There are a total of 5 types of markers.

> [!IMPORTANT]
> `[iOS, Android] x [new arch, old arch] x [debug, release]`
> **Tested to render correctly under all 8 conditions.**

> [!TIP]
> `reuseIdentifier` is automatically cached even if not provided.
>
> Ideally, all markers should use the `width`, `height` prop. Currently, for type 2, the size appears differently in debug/release builds without `width`, `height`.
> It appears correctly in release.

1. Naver Map Basic Symbol (green, red, gray, ...) (caching ✅)

```js
image={{symbol: 'green'}}
```

2. Local Resource (`require` react native image file) (caching ✅)

```js
image={require('./marker.png')}
```

3. Local Native Resource

```js
image={{assetName: 'asset_image'}}
```

-  iOS: image asset name in the main bundle
-  Android: name in the resources' drawable

4. Network Image (caching ✅)

```js
image={{httpUri: 'https://example.com/image.png'}}
```

> [!WARNING]
> Attributes like header are currently not supported.

5. Custom React View (caching ❌)

On iOS(new arch), `collapsable=false` must be set for Views to function.

> [!TIP]
> To change the appearance of a marker, dependencies must be passed as the `key` of the topmost child.

```tsx
<NaverMapMarkerOverlay width={width} height={height} ...>
  <View key={`${text}/${width}/${height}`} collapsable={false} style={{width, height}}>
    <Text>{text}</Text>
  </View>
</NaverMapMarkerOverlay>
```

> [!IMPORTANT]
> This type can significantly impact performance when created in large quantities.
> It is recommended to use images whenever possible or keep usage simple.

Currently, this type tracks the position of children by slightly customizing React Native’s Shadow Node on Android and inserting the actual Android `View`.

On iOS, simply draw `UIView` to canvas as `UIImage`.

Both methods do not yet support image caching (possible in the future with attributes like `reuseableIdentifier`), and each marker consumes a significant amount of resources.


## TODO - Props & Commands

-  ✅ Done
-  📦 Planned
-  ❓ Maybe Planned
-  ❌ Not Planned

### `NaverMapView`

#### Props

| Prop                     | iOS | Android |
|--------------------------|-----|---------|
| isLogoInteractionEnabled | ❌   | ❌       |
| gestureFrictions         | 📦  | 📦      |

#### Events

| Event            | iOS | Android |
|------------------|-----|---------|
| onTapSymbol      | 📦  | 📦      |
| onAuthFailed     | ❌   | ❌       |
| onLocationChange | 📦  | 📦      |


### Marker Common

#### Events

|           | iOS | Android |
|-----------|-----|---------|
| onLongTap | ❌   | 📦      |

### `NaverMapMarkerOverlay`

#### Props

| Prop                      | iOS                                                | Android |
|---------------------------|----------------------------------------------------|---------|
| caption-fontFamily        | ❓                                                 | ❓       |
| subcaption-fontFamily     | ❓                                                 | ❓       |

## Supporting Table - Architecture

|        | iOS | Android |
|--------|-----|---------|
| Bridge | ✅   | ✅       |
| Fabric | ✅️  | ✅️      |

## Milestone

-  [x] Project Started (23.04.01)
-  [x] Project Setup & Component Structure (23.04.03)
-  [x] General Props & Commands (23.04.05)
-  [x] Camera, Region, Commands, Events (23.04.07)
-  [x] Implement Basic Overlays (23.04.10)
-  [x] Location Service (23.04.10)
-  [x] Support Paper(Old Arch) (23.04.11)
-  [x] Release (23.04.11)
-  [x] Support Expo with config plugin (23.04.12)
-  [x] Docs
-  [x] Implement Clustering (23.04.24)
-  [x] Implement ArrowheadPath Overlay (23.05.01)
-  [x] Implement Ground Overlay (23.05.01)
-  [ ] Implement Location Overlay Commands <- 🔥
-  [ ] Implement MutlPath Overlay <- 🔥

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the
development workflow.

## License

MIT
