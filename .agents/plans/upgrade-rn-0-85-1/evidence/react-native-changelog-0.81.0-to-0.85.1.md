# React Native changelog 인벤토리 (`0.81.0` -> `0.85.1`)

## 출처

- 1차 출처: `https://github.com/facebook/react-native/blob/main/CHANGELOG.md#v0851`
- 추출에 사용한 raw 출처: `https://raw.githubusercontent.com/facebook/react-native/main/CHANGELOG.md`
- 추출 시각: `2026-04-14 00:16Z`
- 범위: `v0.81.0`부터 `v0.85.1`까지의 모든 stable release 섹션

## 버전 목록

- `0.85.1`
- `0.85.0`
- `0.84.0`
- `0.83.4`
- `0.83.3`
- `0.83.2`
- `0.83.1`
- `0.83.0`
- `0.82.1`
- `0.82.0`
- `0.81.6`
- `0.81.5`
- `0.81.4`
- `0.81.3`
- `0.81.2`
- `0.81.1`
- `0.81.0`

## 릴리스별 요약

### `0.85.1`

- 변경 표면이 작은 patch release다.
- Android debug 환경에서 `FormData` 업로드가 실패하던 문제를 수정한다.
- 실험적 Animated animation backend 동작을 일부 조정한다.

### `0.85.0`

- Node 지원선에서 강한 업그레이드 경계가 생긴다.
  구버전/EOL Node 라인이 제거된다.
- Jest preset 위치가 예전 암묵적 경로에서 `react-native/jest-preset`으로 이동한다.
- deprecated TypeScript alias가 제거된다.
- `StyleSheet.absoluteFillObject`가 제거되고 비권장 경로가 아닌 대체 항목 사용이 요구된다.
- Metro와 Hermes 기준선이 다시 올라간다.
- Animated backend 비중이 커진다.
- Android에는 더 많은 new-architecture 및 runtime 정리가 들어간다.
- iOS에는 더 많은 XCFramework / prebuilt / build-system 변경이 들어간다.
- 저장소 영향:
  이 릴리스는 workspace 버전 pin, example 툴링, deprecated RN type/helper API를 쓰는 코드에 직접 영향을 준다.

### `0.84.0`

- Node 최소 버전이 `22.11`로 올라간다.
- Hermes V1이 기본 엔진이 된다.
- 예전 CxxModule / TurboCxxModule / legacy interop 경로가 제거된다.
- Android와 iOS 모두에서 legacy architecture 제거가 더 빨라진다.
- `SafeAreaView`가 deprecated 처리되고 `react-native-safe-area-context` 사용이 권장된다.
- Android 템플릿/툴체인이 전진한다.
  AGP, Gradle, target SDK, edge-to-edge 관련 기본값이 모두 올라간다.
- JSC 1st-party 지원이 제거된다.
- 저장소 영향:
  이 버전부터 Node 22 하한은 사실상 선택이 아니라 실행 전제 조건이 된다.

### `0.83.4`

- 작은 iOS precompiled binary 수정만 포함한다.
- 저장소 영향:
  iOS prebuilt header가 pod install 중 실제로 문제를 만들 때만 직접 영향이 크다.

### `0.83.3`

- Android dev-support custom header 지원이 추가된다.
- monorepo Gradle property 해석 문제가 수정된다.
- RN core tarball 추출 문제가 수정된다.
- 저장소 영향:
  이 저장소는 `pnpm` workspace + hoisting 구조를 쓰므로 monorepo Gradle 수정이 관련 있다.

### `0.83.2`

- Android에서 `oscompat`용 prefab header 노출이 추가된다.
- Android 15+에서 text clipping 문제가 수정된다.
- 네트워킹 redirect URL 및 asset URL 처리 문제가 수정된다.
- 저장소 영향:
  Android UI 정합성과 Android 15 동작이 이 버전에서 바뀐다.

### `0.83.1`

- Android에서 binary data를 포함한 `FormData` 업로드 문제가 수정된다.
- 저장소 영향:
  `0.85.1`에서 다시 다뤄지는 네트워킹 영역의 초기 수정판으로 볼 수 있다.

### `0.83.0`

- headline급 파괴적 변경은 적지만, 많은 새 기능이 들어온다.
- React가 `19.2`로 올라간다.
- Metro가 `0.83.x`대로 이동한다.
- Animated backend 범위가 커진다.
- DevTools network inspection이 기본 활성화된다.
- Android에는 runtime bundle source API, dev menu 변경, new architecture runtime check가 들어간다.
- iOS에는 더 많은 prebuild / symbolication / style-system 기능이 들어간다.
- 저장소 영향:
  이 시점부터 목표 브랜치는 현재 `0.80` 기준선보다 현대적인 RN `0.85` 템플릿에 가까워진다.

### `0.82.1`

- Android transform 수정 1건, iOS coreutils/precompiled binary 수정 1건이 들어간 작은 patch release다.
- 저장소 영향:
  직접 영향은 낮지만 iOS prebuilt 흐름을 실제로 탈 경우 의미가 있다.

### `0.82.0`

- Android와 iOS 모두에서 New Architecture opt-out 경로가 제거된다.
- `InteractionManager`가 deprecated 처리된다.
- 오래된 TurboModule helper API가 더 제거된다.
- Android 템플릿에 `debugOptimized` build type이 추가된다.
- Android manifest 처리에 단일 manifest / `usesCleartextTraffic` placeholder 경로가 들어간다.
- React가 `19.1.x`대로 올라간다.
- Hermes V1은 이 시점에서는 명시적 opt-in 단계로 등장하고, 이후 기본값이 된다.
- 저장소 영향:
  이 저장소는 이미 New Architecture 전용이므로 영향이 크다. helper의 Android manifest와 `MainApplication` 변경도 이 흐름에서 나온다.

### `0.81.6`

- asset/codegen 수정과 Android metro refresh freeze 수정이 들어간 작은 patch다.
- 저장소 영향:
  직접 영향은 낮고, 주로 codegen과 iOS 산출물 생성 안정성에 관련된다.

### `0.81.5`

- Android permission 해석과 iOS modern-app crash를 고친 patch release다.
- 저장소 영향:
  example 앱이 양 플랫폼에서 위치 권한을 쓰므로 관련성이 있다.

### `0.81.4`

- iOS artifact/codegen 회귀 수정이다.
- 저장소 영향:
  iOS codegen/pod 생성이 업그레이드 중 회귀할 때만 직접 관련된다.

### `0.81.3`

- 이전 iOS autolinking/config-output 변경 하나를 되돌린다.
- 저장소 영향:
  이후 `0.81.4` / `0.81.6`의 pod/codegen 수정 흐름을 이해하는 데 도움이 된다.

### `0.81.2`

- Android에 `debugOptimized` build type이 도입된다.
- New Architecture + Reanimated 성능 관련 Android 실험 플래그가 추가된다.
- 저장소 영향:
  최신 helper 템플릿이 `debugOptimized`를 언급하는 이유를 설명해 준다.

### `0.81.1`

- explicit modules, symbol copying 관련 iOS/Xcode prebuild 수정이 들어간다.
- 작은 accessibility/TextInput/Switch 수정도 포함된다.
- 저장소 영향:
  직접 영향은 낮지만 iOS prebuild 변경이 계속 누적된다는 맥락을 제공한다.

### `0.81.0`

- 이 업그레이드 범위의 첫 번째 주요 breaking step이다.
- 최소 Node 버전이 Node 22 라인으로 이동한다.
- React가 `19`로 올라간다.
- `View` accessibility 기본값이 바뀐다.
- `NewAppScreen`은 내부 safe-area 처리를 더 이상 하지 않고 앱 셸이 이를 책임지도록 바뀐다.
- Android edge-to-edge opt-in 지원이 도입된다.
- 이후 visible해지는 SafeAreaView deprecated 경로의 출발점이 된다.
- 최소 Xcode 버전이 `16.1`로 올라간다.
- 저장소 영향:
  example 앱의 커스텀 safe-area 처리와 현대적인 Node/Xcode 전제를 필수 기준선으로 만드는 릴리스다.

## 이 저장소에 대한 버전 범위 공통 영향

- 워크스페이스는 개별 패키지 문자열이 아니라 공유 catalog를 통해 RN `0.80.0`에서 `0.85.1`로 올라가야 한다.
- `example/` 앱은 RN 템플릿 정렬이 필요하지만, 커스텀 앱 동작을 보존한 상태에서 실제 관련 변경만 가져와야 한다.
- Node 22+는 실행의 하드 전제 조건이다.
- Android 툴체인 drift를 예상해야 한다.
  build tools, SDK 타깃, wrapper, AGP/Gradle 기대치, debug manifest 처리, `MainApplication.kt` bootstrap 패턴이 이 범위에서 모두 바뀌었다.
- iOS 툴체인 drift도 예상해야 한다.
  Podfile/Xcode project/Info.plist 템플릿과 prebuilt 관련 동작이 반복적으로 바뀌었다.
- 루트 라이브러리 호환성 수정은 반드시 검증 기반이어야 한다.
  changelog가 Android, iOS, TurboModule, TypeScript 표면의 legacy/deprecated API를 공격적으로 제거하기 때문이다.

## changelog로부터 도출한 계획 규칙

- “example package.json만 부분 상향” 같은 방식으로는 가지 않는다. 실제 버전 원천은 루트 catalog다.
- 저장소가 현재 쓰지 않는 helper 전용 템플릿 파일은 검증이 요구하지 않는 한 추가하지 않는다.
- legacy architecture에 대한 암묵적 보존 가정을 두지 않는다. 이 저장소도 New Architecture 전용이고, 목표 RN 범위도 그 방향을 강화한다.
- Android/iOS 후속 수정 작업은 manifest/version 상향 이후 따로 분리해 두고, 초기 템플릿 정렬 작업과 섞지 않는다.
