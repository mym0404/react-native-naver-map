# Upgrade Helper 파일 인벤토리

## 출처

- URL: `https://react-native-community.github.io/upgrade-helper/?from=0.80.0&to=0.85.1`
- 추출 방식: `browser-use`로 렌더링된 DOM 검사
- 추출 시각: `2026-04-14 00:16Z`

## 렌더링된 파일 Diff

아래 블록은 렌더링된 Upgrade Helper DOM을 기준으로 웹사이트와 유사한 행 단위 형식으로 재구성한 것이다.
좌우 라인 번호는 유지했고, 변경 행은 삭제/추가 줄로 분리해 표현했다.

### `package.json` (MODIFIED)

```text
@@ -10,31 +10,33 @@
  10   10       "test": "jest"
  11   11     },
  12   12     "dependencies": {
  13      -     "react": "19.1.0",
  14      -     "react-native": "0.80.0",
  15      -     "@react-native/new-app-screen": "0.80.0"
       13 +     "react": "19.2.3",
       14 +     "react-native": "0.85.1",
       15 +     "@react-native/new-app-screen": "0.85.1",
       16 +     "react-native-safe-area-context": "^5.5.2"
  16   17     },
  17   18     "devDependencies": {
  18   19       "@babel/core": "^7.25.2",
  19   20       "@babel/preset-env": "^7.25.3",
  20   21       "@babel/runtime": "^7.25.0",
  21      -     "@react-native-community/cli": "19.0.0",
  22      -     "@react-native-community/cli-platform-android": "19.0.0",
  23      -     "@react-native-community/cli-platform-ios": "19.0.0",
  24      -     "@react-native/babel-preset": "0.80.0",
  25      -     "@react-native/eslint-config": "0.80.0",
  26      -     "@react-native/metro-config": "0.80.0",
  27      -     "@react-native/typescript-config": "0.80.0",
       22 +     "@react-native-community/cli": "20.1.0",
       23 +     "@react-native-community/cli-platform-android": "20.1.0",
       24 +     "@react-native-community/cli-platform-ios": "20.1.0",
       25 +     "@react-native/babel-preset": "0.85.1",
       26 +     "@react-native/eslint-config": "0.85.1",
       27 +     "@react-native/jest-preset": "0.85.1",
       28 +     "@react-native/metro-config": "0.85.1",
       29 +     "@react-native/typescript-config": "0.85.1",
  28   30       "@types/jest": "^29.5.13",
  29      -     "@types/react": "^19.1.0",
       31 +     "@types/react": "^19.2.0",
  30   32       "@types/react-test-renderer": "^19.1.0",
  31   33       "eslint": "^8.19.0",
  32   34       "jest": "^29.6.3",
  33   35       "prettier": "2.8.8",
  34      -     "react-test-renderer": "19.1.0",
  35      -     "typescript": "5.0.4"
       36 +     "react-test-renderer": "19.2.3",
       37 +     "typescript": "^5.8.3"
  36   38     },
  37   39     "engines": {
  38      -     "node": ">=18"
       40 +     "node": ">= 22.11.0"
  39   41     }
  40   42   }
```

### `App.tsx` (MODIFIED)

```text
@@ -7,14 +7,31 @@
   7    7   
   8    8   import { NewAppScreen } from '@react-native/new-app-screen';
   9    9   import { StatusBar, StyleSheet, useColorScheme, View } from 'react-native';
       10 + import {
       11 +   SafeAreaProvider,
       12 +   useSafeAreaInsets,
       13 + } from 'react-native-safe-area-context';
  10   14   
  11   15   function App() {
  12   16     const isDarkMode = useColorScheme() === 'dark';
  13   17   
  14   18     return (
  15      -     <View style={styles.container}>
       19 +     <SafeAreaProvider>
  16   20         <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
  17      -       <NewAppScreen templateFileName="App.tsx" />
       21 +       <AppContent />
       22 +     </SafeAreaProvider>
       23 +   );
       24 + }
       25 + 
       26 + function AppContent() {
       27 +   const safeAreaInsets = useSafeAreaInsets();
       28 + 
       29 +   return (
       30 +     <View style={styles.container}>
       31 +       <NewAppScreen
       32 +         templateFileName="App.tsx"
       33 +         safeAreaInsets={safeAreaInsets}
       34 +       />
  18   35       </View>
  19   36     );
  20   37   }
```

### `Gemfile` (MODIFIED)

```text
@@ -14,3 +14,4 @@ gem 'bigdecimal'
  14   14   gem 'logger'
  15   15   gem 'benchmark'
  16   16   gem 'mutex_m'
       17 + gem 'nkf'
```

### `android/app/build.gradle` (MODIFIED)

```text
@@ -19,9 +19,9 @@ react {
  19   19   
  20   20       /* Variants */
  21   21       //   The list of variants to that are debuggable. For those we're going to
  22      -     //   skip the bundling of the JS bundle and the assets. By default is just 'debug'.
       22 +     //   skip the bundling of the JS bundle and the assets. Default is "debug", "debugOptimized".
  23   23       //   If you add flavors like lite, prod, etc. you'll have to list your debuggableVariants.
  24      -     // debuggableVariants = ["liteDebug", "prodDebug"]
       24 +     // debuggableVariants = ["liteDebug", "liteDebugOptimized", "prodDebug", "prodDebugOptimized"]
  25   25   
  26   26       /* Bundling */
  27   27       //   A list containing the node command and its flags. Default is just 'node'.
```

### `android/app/src/debug/AndroidManifest.xml` (DELETED)

```text
```

### `android/app/src/main/AndroidManifest.xml` (MODIFIED)

```text
@@ -9,6 +9,7 @@
   9    9         android:roundIcon="@mipmap/ic_launcher_round"
  10   10         android:allowBackup="false"
  11   11         android:theme="@style/AppTheme"
       12 +       android:usesCleartextTraffic="${usesCleartextTraffic}"
  12   13         android:supportsRtl="true">
  13   14         <activity
  14   15           android:name=".MainActivity"
```

### `android/app/src/main/java/com/rndiffapp/MainApplication.kt` (MODIFIED)

```text
@@ -5,32 +5,21 @@ import com.facebook.react.PackageList
   5    5   import com.facebook.react.ReactApplication
   6    6   import com.facebook.react.ReactHost
   7    7   import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative
   8      - import com.facebook.react.ReactNativeHost
   9      - import com.facebook.react.ReactPackage
  10    8   import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
  11      - import com.facebook.react.defaults.DefaultReactNativeHost
  12    9   
  13   10   class MainApplication : Application(), ReactApplication {
  14   11   
  15      -   override val reactNativeHost: ReactNativeHost =
  16      -       object : DefaultReactNativeHost(this) {
  17      -         override fun getPackages(): List<ReactPackage> =
       12 +   override val reactHost: ReactHost by lazy {
       13 +     getDefaultReactHost(
       14 +       context = applicationContext,
       15 +       packageList =
  18   16           PackageList(this).packages.apply {
  19   17             // Packages that cannot be autolinked yet can be added manually here, for example:
  20   18             // add(MyReactNativePackage())
       19 +         },
       20 +     )
  21   21     }
  22   22   
  23      -         override fun getJSMainModuleName(): String = "index"
  24      - 
  25      -         override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG
  26      - 
  27      -         override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
  28      -         override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
  29      -       }
  30      - 
  31      -   override val reactHost: ReactHost
  32      -     get() = getDefaultReactHost(applicationContext, reactNativeHost)
  33      - 
  34   23     override fun onCreate() {
  35   24       super.onCreate()
  36   25       loadReactNative(this)
```

### `android/build.gradle` (MODIFIED)

```text
@@ -1,9 +1,9 @@
   1    1   buildscript {
   2    2       ext {
   3      -         buildToolsVersion = "35.0.0"
        3 +         buildToolsVersion = "36.0.0"
   4    4           minSdkVersion = 24
   5      -         compileSdkVersion = 35
   6      -         targetSdkVersion = 35
        5 +         compileSdkVersion = 36
        6 +         targetSdkVersion = 36
   7    7           ndkVersion = "27.1.12297006"
   8    8           kotlinVersion = "2.1.20"
   9    9       }
```

### `android/gradle.properties` (MODIFIED)

```text
@@ -37,3 +37,8 @@ newArchEnabled=true
  37   37   # Use this property to enable or disable the Hermes JS engine.
  38   38   # If set to false, you will be using JSC instead.
  39   39   hermesEnabled=true
       40 + 
       41 + # Use this property to enable edge-to-edge display support.
       42 + # This allows your app to draw behind system bars for an immersive UI.
       43 + # Note: Only works with ReactActivity and should not be used with custom Activity.
       44 + edgeToEdgeEnabled=false
```

### `android/gradle/wrapper/gradle-wrapper.jar` (MODIFIED)

```text
```

### `android/gradle/wrapper/gradle-wrapper.properties` (MODIFIED)

```text
@@ -1,6 +1,6 @@
   1    1   distributionBase=GRADLE_USER_HOME
   2    2   distributionPath=wrapper/dists
   3      - distributionUrl=https\://services.gradle.org/distributions/gradle-8.14.1-bin.zip
        3 + distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.1-bin.zip
   4    4   networkTimeout=10000
   5    5   validateDistributionUrl=true
   6    6   zipStoreBase=GRADLE_USER_HOME
```

### `android/gradlew` (MODIFIED)

```text
@@ -1,7 +1,7 @@
   1    1   #!/bin/sh
   2    2   
   3    3   #
   4      - # Copyright © 2015-2021 the original authors.
        4 + # Copyright © 2015 the original authors.
   5    5   #
   6    6   # Licensed under the Apache License, Version 2.0 (the "License");
   7    7   # you may not use this file except in compliance with the License.
@@ -114,7 +114,6 @@ case "$( uname )" in #(
 114  114     NONSTOP* )        nonstop=true ;;
 115  115   esac
 116  116   
 117      - CLASSPATH="\\\"\\\""
 118  117   
 119  118   
 120  119   # Determine the Java command to use to start the JVM.
@@ -172,7 +171,6 @@ fi
 172  171   # For Cygwin or MSYS, switch paths to Windows format before running java
 173  172   if "$cygwin" || "$msys" ; then
 174  173       APP_HOME=$( cygpath --path --mixed "$APP_HOME" )
 175      -     CLASSPATH=$( cygpath --path --mixed "$CLASSPATH" )
 176  174   
 177  175       JAVACMD=$( cygpath --unix "$JAVACMD" )
 178  176   
@@ -212,7 +210,6 @@ DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'
 212  210   
 213  211   set -- \
 214  212           "-Dorg.gradle.appname=$APP_BASE_NAME" \
 215      -         -classpath "$CLASSPATH" \
 216  213           -jar "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" \
 217  214           "$@"
 218  215   
```

### `android/gradlew.bat` (MODIFIED)

```text
@@ -75,11 +75,10 @@ goto fail
  75   75   :execute
  76   76   @rem Setup the command line
  77   77   
  78      - set CLASSPATH=
  79   78   
  80   79   
  81   80   @rem Execute Gradle
  82      - "%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" -jar "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" %*
       81 + "%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -jar "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" %*
  83   82   
  84   83   :end
  85   84   @rem End local scope for the variables with windows NT shell
```

### `ios/Podfile` (MODIFIED)

```text
@@ -24,7 +24,6 @@ target 'RnDiffApp' do
  24   24     )
  25   25   
  26   26     post_install do |installer|
  27      -     # https://github.com/facebook/react-native/blob/main/packages/react-native/scripts/react_native_pods.rb#L197-L202
  28   27       react_native_post_install(
  29   28         installer,
  30   29         config[:reactNativePath],
```

### `ios/RnDiffApp.xcodeproj/project.pbxproj` (MODIFIED)

```text
```

### `ios/RnDiffApp/Info.plist` (MODIFIED)

```text
@@ -2,6 +2,8 @@
   2    2   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   3    3   <plist version="1.0">
   4    4   <dict>
        5 + 	<key>CADisableMinimumFrameDurationOnPhone</key>
        6 + 	<true/>
   5    7   	<key>CFBundleDevelopmentRegion</key>
   6    8   	<string>en</string>
   7    9   	<key>CFBundleDisplayName</key>
@@ -43,8 +45,13 @@
  43   45   	<key>UISupportedInterfaceOrientations</key>
  44   46   	<array>
  45   47   		<string>UIInterfaceOrientationPortrait</string>
       48 + 	</array>
       49 + 	<key>UISupportedInterfaceOrientations~ipad</key>
       50 + 	<array>
  46   51   		<string>UIInterfaceOrientationLandscapeLeft</string>
  47   52   		<string>UIInterfaceOrientationLandscapeRight</string>
       53 + 		<string>UIInterfaceOrientationPortrait</string>
       54 + 		<string>UIInterfaceOrientationPortraitUpsideDown</string>
  48   55   	</array>
  49   56   	<key>UIViewControllerBasedStatusBarAppearance</key>
  50   57   	<false/>
```

### `jest.config.js` (MODIFIED)

```text
@@ -1,3 +1,3 @@
   1    1   module.exports = {
   2      -   preset: 'react-native',
        2 +   preset: '@react-native/jest-preset',
   3    3   };
```

### `tsconfig.json` (MODIFIED)

```text
@@ -1,3 +1,8 @@
   1    1   {
   2      -   "extends": "@react-native/typescript-config"
        2 +   "extends": "@react-native/typescript-config",
        3 +   "compilerOptions": {
        4 +     "types": ["jest"]
        5 +   },
        6 +   "include": ["**/*.ts", "**/*.tsx"],
        7 +   "exclude": ["**/node_modules", "**/Pods"]
   3    8   }
```

## 저장소 매핑

helper 템플릿 경로는 이 저장소에 1:1로 대응하지 않는다. 실행 시에는 아래 매핑을 기준으로 삼는다.

- `package.json`
  매핑 대상 경로:
  `pnpm-workspace.yaml`, `package.json`, `example/package.json`, `pnpm-lock.yaml`
  비고:
  루트 라이브러리와 `example/` 모두 workspace catalog를 통해 RN 버전을 해석한다.

- `App.tsx`
  매핑 대상 경로:
  `example/src/App.tsx`
  비고:
  이 저장소는 stock NewAppScreen 전용 템플릿 대신 커스텀 example 셸을 사용한다.

- `Gemfile`
  매핑 대상 경로:
  `example/Gemfile`

- `android/build.gradle`
  매핑 대상 경로:
  `example/android/build.gradle`

- `android/gradle.properties`
  매핑 대상 경로:
  `example/android/gradle.properties`

- `android/gradle/wrapper/gradle-wrapper.jar`
  매핑 대상 경로:
  `example/android/gradle/wrapper/gradle-wrapper.jar`

- `android/gradle/wrapper/gradle-wrapper.properties`
  매핑 대상 경로:
  `example/android/gradle/wrapper/gradle-wrapper.properties`

- `android/gradlew`
  매핑 대상 경로:
  `example/android/gradlew`

- `android/gradlew.bat`
  매핑 대상 경로:
  `example/android/gradlew.bat`

- `android/app/build.gradle`
  매핑 대상 경로:
  `example/android/app/build.gradle`

- `android/app/src/debug/AndroidManifest.xml`
  매핑 대상 경로:
  `example/android/app/src/debug/AndroidManifest.xml`
  비고:
  helper는 이 파일을 삭제한다. 이 저장소에서는 debug overlay manifest 없이도 Metro/debug 네트워킹이 정상 동작할 때만 제거해야 한다.

- `android/app/src/main/AndroidManifest.xml`
  매핑 대상 경로:
  `example/android/app/src/main/AndroidManifest.xml`

- `android/app/src/main/java/com/rndiffapp/MainApplication.kt`
  매핑 대상 경로:
  `example/android/app/src/main/java/com/example/MainApplication.kt`
  비고:
  패키지 이름은 다르지만 host bootstrap 형태는 비교 가능하다.

- `ios/Podfile`
  매핑 대상 경로:
  `example/ios/Podfile`

- `ios/RnDiffApp.xcodeproj/project.pbxproj`
  매핑 대상 경로:
  `example/ios/example.xcodeproj/project.pbxproj`

- `ios/RnDiffApp/Info.plist`
  매핑 대상 경로:
  `example/ios/example/Info.plist`

- `jest.config.js`
  매핑 대상 경로:
  No current equivalent
  비고:
  저장소가 실제 Jest 사용을 도입하지 않는 한 이 파일을 추가하지 않는다. 현재 저장소에는 Jest config나 test script가 없다.

- `tsconfig.json`
  매핑 대상 경로:
  `example/tsconfig.json`
  비고:
  example tsconfig는 루트 tsconfig를 확장하므로, helper 변경은 그대로 복사하지 말고 맞춰서 적용해야 한다.

## 이 저장소에서 중요한 Upgrade Helper 변경점

- JS 의존성 기준선은 `react-native 0.85.1`, `react 19.2.3`으로 이동한다.
- RN 동반 패키지도 RN과 함께 올라간다:
  `@react-native/new-app-screen`, `@react-native/babel-preset`, `@react-native/metro-config`, `@react-native/typescript-config`.
- Community CLI 계열은 `20.1.0`으로 올라간다.
- helper 템플릿은 example Node 엔진 하한을 `>=22.11.0`으로 높인다.
- helper 템플릿은 `@react-native/jest-preset`을 사용하지만, 이 저장소는 현재 Jest를 사용하지 않는다.
- helper 템플릿은 NewAppScreen safe-area 처리를 위해 `react-native-safe-area-context`를 유지하고, 이 저장소도 이미 `example/src/App.tsx`에서 그 패키지를 사용한다.
- Android helper 템플릿은 build tools / compile SDK / target SDK를 `36`으로 올리고, `edgeToEdgeEnabled=false`를 추가하며, wrapper 파일도 갱신한다.
- Android helper 템플릿은 `MainApplication.kt`를 더 새로운 `reactHost` 중심 형태로 옮긴다.
- Android helper 템플릿은 manifest placeholder 기반 cleartext 처리로 전환하면서 `src/debug/AndroidManifest.xml`을 삭제한다.
- iOS helper 템플릿은 `CADisableMinimumFrameDurationOnPhone`을 추가하고 iPad orientation 선언을 확장한다.
- iOS helper 템플릿은 `Gemfile`, `Podfile`, Xcode project 기준선을 갱신한다.
