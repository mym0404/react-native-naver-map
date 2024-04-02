- [English Documentation(WIP)](/doc/en.md)

>[!WARNING]
>This project is ongoing. See the supporting table for progress.

---

리액트 네이티브 [Naver Map](https://www.ncloud.com/product/applicationService/maps) 컴포넌트입니다.

이 프로젝트는 다음과 같은 목적을 가집니다.

1. 더 이상 관리되지 않는 [기존 라이브러리](https://github.com/QuadFlask/react-native-naver-map) 대체
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


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
