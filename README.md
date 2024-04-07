- [English Documentation(not yet written)](/doc/en.md)

>[!WARNING]
>This project is ongoing. See the supporting table for progress.
>
>I want to release `1.0` until May, 2024

---

![rnnm](https://github.com/mj-studio-library/react-native-naver-map/assets/33388801/de8cbe13-1fc7-453b-88a4-41c23a2b2d8b)

리액트 네이티브 [Naver Map](https://www.ncloud.com/product/applicationService/maps) 컴포넌트입니다.

[![NPM - alpha](https://img.shields.io/badge/NPM-alpha-3af2f2)](https://) [![Android SDK - 3.18.0](https://img.shields.io/badge/Android_SDK-3.18.0-2ea44f)](https://) [![iOS SDK - 3.18.0](https://img.shields.io/badge/iOS_SDK-3.18.0-3522ff)](https://)

![preview](https://raw.githubusercontent.com/mym0404/image-archive/master/202404072321046.webp)


## 왜 이 라이브러리를 써야하나요?

1. 새롭게 만드는 이 라이브러리는 Naver Map SDK의 **최신 기능들을 모두 지원**합니다. Seamless한 Props와 Command들로 Naver Map을 조작할 수 있습니다.
2. **Fabric**과 Old Architecture모두 지원합니다.
3. Event Coalescing를 통해 Native -> JS 로의 이벤트 중 쓸모없는 이벤트들을 걸러내 성능이 최적화가 됩니다.


## 목적

이 프로젝트는 다음과 같은 목적을 가집니다.

1. 더 이상 관리되지 않는 [기존 라이브러리](https://github.com/QuadFlask/react-native-naver-map) 대체

기존 라이브러리의 모든 기능을 가져간 채로 API의 변경도 마이그레이션을 위해 되도록이면 지양하려고 했으나
개선이 필요한 부분들은 필요하다고 생각되면 바꿉니다. 예를 들어, 기존 라이브러리에서 `region`이
잘못 계산되고 있던 버그 등입니다.

Usage는 [`react-native-map`의 Usage](https://github.com/react-native-maps/react-native-maps/blob/master/docs/mapview.md)를 되도록 따릅니다.

2. New Architecture Renderer Fabric 지원

>[!NOTE]
>Fabric을 지원한다고 Old Architecture를 지원하지 않는 것이 아닌 두 Architecture모두에서 작동하는 컴포넌트를 제작합니다.

[이전 라이브러리](https://github.com/QuadFlask/react-native-naver-map)의 코드를 참고하며 동일한 버그를 반복하지 않도록 주의하며 작업이 진행됩니다.

## Supporting Table

|        | iOS                    | Android                | Web        |
|--------|------------------------|------------------------|------------|
| Bridge | Working In Progress ⚒️ | Working In Progress ⚒️ | Planned 📦 |
| Fabric | Working In Progress ⚒️ | Working In Progress ⚒️ | Planned 📦 |

>[!TIP]
>Bridge와 Fabric 아키텍쳐 모두 따로따로 지원을 준비해야 하는 것은 아닙니다.
>추상화 레이어로 분리되어 있고 실제 내부 구현이 완료되면 플랫폼마다 Bridge/Fabric모두 출시가 될 것입니다.
> 
>작업 우선순위는 Android -> iOS -> Web 입니다.

[//]: # (## Installation)

[//]: # (```sh)
[//]: # (npm install @mj-studio/react-native-naver-map)
[//]: # (```)

## Milestone

- [x] Project Started (23.04.01)
- [x] Android/iOS - Project Setup & Component Structure (23.04.03)
- [x] Android/iOS - General Props & Commands (23.04.05)
- [x] Android/iOS - Camera, Region, Commands, Events (23.04.07)
- [ ] Android/iOS - Implement Basic Overlays  <- 🔥
- [ ] Android/iOS - Implement Advanced Overlays
- [ ] Release
- [ ] Docs - Docusaurus docs


## Usage

### Install

```shell
yarn add @mj-studio/react-native-naver-map
# for ios, you should install pods
```

### Android

### iOS

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
