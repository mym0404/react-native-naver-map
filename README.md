<p align="center">
  <a href="https://rnnavermap.mjstudio.net">
    <img width="160px" src="https://raw.githubusercontent.com/mym0404/image-archive/master/202404241422605.webp"><br/>
  </a>
  <h1 align="center">React Native Naver Map</h1>
  <p align="center">
  <a href="https://www.npmjs.com/package/@mj-studio/react-native-naver-map"><img src="https://img.shields.io/npm/dm/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="NPM downloads"></a>
  <a href="https://www.npmjs.com/package/@mj-studio/react-native-naver-map"><img src="https://img.shields.io/npm/v/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="NPM version"></a>
  <img src="https://img.shields.io/badge/Android_SDK-3.22.1-2ea44f?style=flat-square" alt="Android SDK version">
  <img src="https://img.shields.io/badge/iOS_SDK-3.22.1-3522ff?style=flat-square" alt="iOS SDK version">
  <a href="/LICENSE"><img src="https://img.shields.io/npm/l/@mj-studio/react-native-naver-map.svg?style=flat-square" alt="License"></a>
  <h3 align="center">Bring Naver Map to Your React Fingertips</h3>
  </p>
</p>

- [Documentation](https://rnnavermap.mjstudio.net)
- [Tutorial 1 - 설치, 키 발급](https://medium.com/mj-studio/%EB%A6%AC%EC%95%A1%ED%8A%B8-%EB%84%A4%EC%9D%B4%ED%8A%B8%EB%B8%8C%EB%A1%9C-%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%A7%80%EB%8F%84-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-1-%EC%84%A4%EC%B9%98%EC%99%80-%ED%82%A4-%EB%B0%9C%EA%B8%89-%EB%B0%9B%EA%B8%B0-f826d8c0644d)
- [Tutorial 2 - 카메라, 위치 이동](https://medium.com/mj-studio/%EB%A6%AC%EC%95%A1%ED%8A%B8-%EB%84%A4%EC%9D%B4%ED%8A%B8%EB%B8%8C%EB%A1%9C-%EB%84%A4%EC%9D%B4%EB%B2%84-%EC%A7%80%EB%8F%84-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-2-%EC%B9%B4%EB%A9%94%EB%9D%BC-%EC%9C%84%EC%B9%98-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0-ea39843b31d2)


<img src="https://raw.githubusercontent.com/mym0404/image-archive/master/202404240329848.gif" width="400" alt="preview">

> [!IMPORTANT]
> `2.4.x` 버전부터 [AI NAVER API에서 제공되던 지도 API가 아닌 새롭게 출시된 Maps 단독 상품](https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1)이 지원됩니다.

## Usage

### Permission

기본적으로 앱에서 권한은 직접 관리가 되어야 합니다.

이를 관리하기 위해 [react-native-permissions](https://github.com/zoontek/react-native-permissions)라이브러리를 사용하는 예시를 알아보겠습니다.

>[!TIP]
>Expo 사용자라면 [expo-location](https://docs.expo.dev/versions/latest/sdk/location/)를 참고해서 권한을 사용할 예정이다 라고 명시할 수 있습니다.
>따라서 아래 내용들 중 대부분은 필요하지 않고, 필요한 권한이 무엇인지, 어떻게 명시해야 하는지를 살펴보신 다음 [expo-location](https://docs.expo.dev/versions/latest/sdk/location/)에서의 사용법을 따르셔야 합니다.

우선 패키지를 설치하고 설정합니다.

```shell
pnpm add react-native-permissions
```

`react-native-permission`의 각 플랫폼별 설정 방법은 [사용법](https://github.com/zoontek/react-native-permissions#setup)을 직접 참고해
`Podfile(iOS)`, `AndroidManifest.xml(Android)` 를 적절히 변경해주시길 바랍니다.

#### iOS

iOS는 다음과 같은 세 가지의 권한이 연관되어있습니다.

- `NSLocationAlwaysAndWhenInUseUsageDescription(>= iOS 11)`
  - 앱이 foreground와 background 모두에서 위치 정보에 액세스하는 것을 허용합니다.
  - iOS 11 이상에서는 ﻿NSLocationAlwaysUsageDescription 대신 이 키를 사용해야 합니다.
- `NSLocationWhenInUseUsageDescription`
  - 앱이 foreground에 있을 때 (즉, 사용자가 actively하게 앱을 사용 중일 때) 위치 정보에 액세스하는 것을 허용합니다.
- `NSLocationTemporaryUsageDescriptionDictionary(>= iOS 14)`
  - 앱이 임시로 정확한 위치 정보에 액세스할 수 있도록 허용합니다. 이는 앱이 특정 작업을 수행하는 동안에만 정확한 위치가 필요한 경우 사용됩니다.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the
development workflow.

## License

MIT
