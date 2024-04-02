- [English Documentation(not yet written)](/doc/en.md)

>[!WARNING]
>This project is ongoing. See the supporting table for progress.
>
>I want to release `1.0` until May, 2025

---

![rnnm](https://github.com/mj-studio-library/react-native-naver-map/assets/33388801/de8cbe13-1fc7-453b-88a4-41c23a2b2d8b)

리액트 네이티브 [Naver Map](https://www.ncloud.com/product/applicationService/maps) 컴포넌트입니다.

[![NPM - alpha](https://img.shields.io/badge/NPM-alpha-3af2f2)](https://) [![Android SDK - 3.18.0](https://img.shields.io/badge/Android_SDK-3.18.0-2ea44f)](https://) [![iOS SDK - 3.16.2](https://img.shields.io/badge/iOS_SDK-3.16.2-3522ff)](https://)

## 왜 이 라이브러리를 써야하나요?

1. 새롭게 만드는 이 라이브러리는 Naver Map SDK의 **최신 기능들을 모두 지원**합니다. Seamless한 Props와 Command들로 Naver Map을 조작할 수 있습니다.
  - 기존의 라이브러리에 없었던 화면/지도내 위치간 좌표변환 및 여러 추가된 기능들을 탑재합니다.
2. **Fabric**과 Old Architecture모두 지원합니다.
3. Event Coalescing를 통해 Native -> JS 로의 이벤트 중 쓸모없는 이벤트들을 걸러내 성능이 최적화가 됩니다.


## 목적

이 프로젝트는 다음과 같은 목적을 가집니다.

1. 더 이상 관리되지 않는 [기존 라이브러리](https://github.com/QuadFlask/react-native-naver-map) 대체

기존 라이브러리의 모든 기능을 가져간 채로 API의 변경도 되도록이면 마이그레이션을 위해 지양하려고 합니다.

2. New Architecture Renderer Fabric 지원

>[!NOTE]
>Fabric을 지원한다고 Old Architecture를 지원하지 않는 것이 아닌 두 Architecture모두에서 작동하는 컴포넌트를 제작합니다.

[이전 라이브러리](https://github.com/QuadFlask/react-native-naver-map)의 코드를 참고하며 동일한 버그를 반복하지 않도록 주의하며 작업이 진행되며 Usage를 비슷하게 만들고 있습니다.

## Supporting Table

|        | iOS        | Android                | Web        |
|--------|------------|------------------------|------------|
| Bridge | Planned 📦 | Working In Progress ⚒️ | Planned 📦 |
| Fabric | Planned 📦 | Working In Progress ⚒️ | Planned 📦 |

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

- [x] Project Started (23.04.02)
- [ ] Android - General Props, Commands, Rendering, Camera, Move <- 🔥(here)
- [ ] iOS - General Props, Comamnds, Rendering, Camera, Move
- [ ] Android - Implement Basic Overlays
- [ ] iOS - Implement Basic Overlays
- [ ] Android - Implement Advanced Overlays
- [ ] iOS - Implement Advanced Overlays
- [ ] Docs - Docusaurus docs
- [ ] Release


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
