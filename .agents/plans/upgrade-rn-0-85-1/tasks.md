# React Native 0.85.1 업그레이드

이 파일은 이 번들의 유일한 진행 상태 기록이다.

## 상태 보드 (Status Board)

- `Doing`: 없음
- `Ready Now`: T1 - 워크스페이스 RN 의존성 매트릭스 업데이트
- `Blocked`: 없음
- `Todo`: T2 - example JS 런타임 셸 검토, T3 - Android example 툴체인 정렬, T4 - Android example 앱 통합 정렬, T5 - iOS example 템플릿 정렬, T6 - 중간 체크포인트 실행, T7 - 필요 시 루트 JS/spec 회귀 수정, T8 - 필요 시 Android 라이브러리 회귀 수정, T9 - 필요 시 iOS 라이브러리 회귀 수정, T10 - 최종 검증 웨이브 실행
- `Done`: 없음

## 작업 (Tasks)

### T1 - 워크스페이스 RN 의존성 매트릭스 업데이트
- `ID`: T1
- `Slice`: 의존성 기준선
- `Status`: Todo
- `Depends On`: 없음
- `Start When`: 실행자가 의존성 manifest를 수정할 준비가 되었고, 더 앞선 계획 작업이 활성 상태가 아닐 때 시작한다.
- `Files`: `pnpm-workspace.yaml`, `package.json`, `example/package.json`, `pnpm-lock.yaml`
- `Context`: 루트 패키지와 `example/` 모두 workspace catalog를 통해 RN을 해석하므로, 버전 상향은 여기서 시작해야 한다.
- `Produces`: 갱신된 catalog 버전, 상향된 example Node 엔진 하한, 새로고침된 lockfile 상태
- `Must Do`: 공유 catalog를 RN `0.85.1`, React `19.2.3`에 맞춘다. 루트와 example이 계속 공유 RN 패키지에 `catalog:`를 쓰도록 유지한다. `pnpm install`로 `pnpm-lock.yaml`을 갱신한다.
- `Must Not Do`: 저장소가 쓰지 않는 helper 전용 의존성, 특히 `@react-native/jest-preset`을 추가하지 않는다. 이후 검증으로 비호환이 증명되기 전에는 `react-native-safe-area-context` 같은 저장소 전용 의존성을 내리지 않는다.
- `Implementation Notes`: `react`, `react-native`, `react-test-renderer`, `@react-native-community/cli`, `@react-native-community/cli-platform-android`, `@react-native-community/cli-platform-ios`, `@react-native/new-app-screen`, `@react-native/babel-preset`, `@react-native/metro-config`, `@react-native/typescript-config`, `typescript`의 catalog 엔트리를 `0.85.1` 기준선으로 올린다. `example/package.json`의 `engines.node`는 `>=22.11.0`으로 높인다. 루트 패키지의 라이브러리 전용 deps와 peerDependencies는 유지한다.
- `Verification Strategy`: 1. `pnpm install` 실행. 2. `pnpm list react react-native react-test-renderer --depth 0 --filter example` 실행. 3. 성공 신호: install이 `0`으로 끝나고, example이 `react-native 0.85.1`을 해석하며, lockfile에 새 catalog 버전이 기록된다.
- `Acceptance Criteria`: workspace catalog가 새 RN 기준선의 단일 진실 원천이 되고, example이 사용하지 않는 helper 전용 툴링 없이 목표 RN/React 버전을 해석한다.
- `Definition of Done`: 의존성 manifest와 lockfile이 업데이트되고, 검증이 성공하며, 근거가 저장되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md`를 다시 읽어 상태가 유지됐는지 확인한다.
- `Delegation`: 부모 직접 수행. 다른 모든 작업보다 먼저 실행 가능. 쓰기 범위는 명시된 파일로 제한한다.
- `Evidence`: `evidence/t1-dependency-matrix.txt`
- `Reopen When`: 이후 작업이나 검증에서 workspace가 실제로 RN `0.85.1`을 해석하지 못하는 것이 드러날 때
- `Size`: M

### T2 - example JS 런타임 셸 검토
- `ID`: T2
- `Slice`: example JS 셸
- `Status`: Todo
- `Depends On`: T1
- `Start When`: T1이 `Done`이고 새 의존성 기준선이 설치된 뒤 시작한다.
- `Files`: `example/src/App.tsx`, `example/tsconfig.json`
- `Context`: helper의 `App.tsx`, `tsconfig.json` 변경은 이 저장소의 커스텀 example 셸과 루트 config를 확장하는 tsconfig 구조 때문에 그대로 대응되지 않는다.
- `Produces`: 최소 호환성 패치 또는 example 셸에 대한 근거 있는 no-op 결정
- `Must Do`: helper의 safe-area 및 tsconfig 변경을 현재 커스텀 example과 비교 검토한다. safe-area 처리는 `react-native-safe-area-context` 소유로 유지하고, example의 화면 내비게이션은 보존한다.
- `Must Not Do`: example을 stock RN 템플릿으로 다시 쓰지 않는다. 저장소가 실제 Jest 사용을 도입하지 않는 한 Jest types나 Jest config를 추가하지 않는다.
- `Implementation Notes`: 현재 `example/src/App.tsx`는 이미 `SafeAreaProvider`, `SafeAreaView`를 사용한다. RN `0.85.1`이 `NewAppScreen` 또는 example 셸을 실제로 비호환으로 만들 때만 바꾼다. `example/tsconfig.json`은 집중 TS 체크가 include/exclude 또는 compiler options 추가 필요성을 보여주지 않는 한 확장 기반 구조를 유지한다.
- `Verification Strategy`: `pnpm exec tsc -p example/tsconfig.json --noEmit` 실행. 성공 신호는 종료 코드 `0`. 파일 변경이 필요 없었다면 현재 셸이 helper 시대 요구사항을 이미 만족한다는 no-op 근거를 evidence 경로에 기록한다.
- `Acceptance Criteria`: example JS 셸이 커스텀 상태를 유지한 채 새 RN 기준선에서 typecheck를 통과하고, 불필요한 helper 전용 churn이 들어가지 않는다.
- `Definition of Done`: 집중 TS 검증이 성공하고, 적용된 패치 또는 no-op 사유가 근거에 남으며, 작업 `Status`가 `Done`이 되고, 상태 보드가 갱신되며, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T3, T5와 병렬 가능. 쓰기 범위는 명시된 파일로 제한한다.
- `Evidence`: `evidence/t2-example-js-shell.txt`
- `Reopen When`: 이후 검증에서 example 셸이 여전히 RN `0.85.1` 호환성 문제를 갖는 것이 드러날 때
- `Size`: S

### T3 - Android example 툴체인 정렬
- `ID`: T3
- `Slice`: example Android 툴체인
- `Status`: Todo
- `Depends On`: T1
- `Start When`: T1이 `Done`이고 example Android 프로젝트가 아직 옛 `0.80.0` 시대 툴체인을 가리킬 때 시작한다.
- `Files`: `example/android/build.gradle`, `example/android/gradle.properties`, `example/android/gradle/wrapper/`, `example/android/gradlew`, `example/android/gradlew.bat`
- `Context`: helper와 changelog 모두 Android SDK/툴체인 기대치를 앞으로 끌어올리며, 이 저장소의 example 프로젝트에는 Naver 저장소 override가 있는 커스텀 Android 루트가 있다.
- `Produces`: RN `0.85.1`과 호환되는 갱신된 Android wrapper/툴체인 기준선
- `Must Do`: Naver Maven 저장소를 유지한다. `newArchEnabled=true`, `hermesEnabled=true`를 유지한다. 이후 제품 결정이 없는 한 helper 시대의 `edgeToEdgeEnabled=false` 기본값을 가져간다.
- `Must Not Do`: 이 작업에서 루트 라이브러리 `android/` 모듈을 수정하지 않는다. 템플릿/툴체인과 무관한 저장소 고유 Android 설정을 제거하지 않는다.
- `Implementation Notes`: example Android 프로젝트를 helper 시대 SDK 및 wrapper 기준선으로 옮긴다. build tools / compile SDK / target SDK는 기대값인 `36`으로 올린다. 업그레이드된 툴체인이 강제하지 않는 한 `minSdkVersion`은 `24`로 유지한다. wrapper 파일은 생성된 jar까지 포함해 한 세트로 갱신한다.
- `Verification Strategy`: `cd example/android && ./gradlew help` 실행. 성공 신호는 새 wrapper와 프로젝트 설정으로 Gradle이 정상 부팅하는 것이다.
- `Acceptance Criteria`: example Android 프로젝트가 갱신된 wrapper/툴체인에서 부팅되고, 저장소의 커스텀 repository 설정이 유지된다.
- `Definition of Done`: Android 툴체인 파일이 업데이트되고, 검증이 성공하며, 근거가 저장되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T2, T5와 병렬 가능. 쓰기 범위는 명시된 Android example 파일로 제한한다.
- `Evidence`: `evidence/t3-android-toolchain.txt`
- `Reopen When`: 이후 Android 검증에서 wrapper/툴체인 기준선이 여전히 낡은 것으로 드러날 때
- `Size`: M

### T4 - Android example 앱 통합 정렬
- `ID`: T4
- `Slice`: example Android 앱
- `Status`: Todo
- `Depends On`: T3
- `Start When`: T3가 `Done`이고 앱 모듈이 아직 옛 템플릿 형태를 반영하고 있을 때 시작한다.
- `Files`: `example/android/app/build.gradle`, `example/android/app/src/main/AndroidManifest.xml`, `example/android/app/src/debug/AndroidManifest.xml`, `example/android/app/src/main/java/com/example/MainApplication.kt`
- `Context`: 앱 모듈에는 RN `0.85.1` helper 템플릿의 핵심 변경점이 들어 있다. 여기에는 manifest 전략과 host bootstrap 형태가 포함된다.
- `Produces`: 앱/패키지 식별자와 Naver Map 설정을 유지하면서 새 RN 템플릿에 맞춰진 Android 앱 모듈
- `Must Do`: 기존 application id, package name, permissions, 그리고 이 저장소에 필요한 Metro/debug 동작을 유지한다. helper가 삭제한 debug manifest는 도입 또는 유지 여부를 근거와 함께 판단한다.
- `Must Not Do`: 패키지 이름을 바꾸지 않는다. 필요한 permission이나 앱 전용 네트워킹 동작을 제거하지 않는다. 범위를 무관한 Android 정리 작업으로 넓히지 않는다.
- `Implementation Notes`: helper의 `MainApplication.kt` bootstrap 형태는 현재 저장소의 실제 package path와 import에 맞는 범위까지만 이식한다. manifest/app build 설정 중 템플릿 소유인 부분만 갱신한다. `src/debug/AndroidManifest.xml` 삭제가 debug cleartext나 Metro 동작을 깨면, helper 삭제를 억지로 따르지 말고 파일을 유지하며 이유를 기록한다.
- `Verification Strategy`: `pnpm ci:android` 실행. 성공 신호는 `assembleDebug`가 `0`으로 끝나는 것이다.
- `Acceptance Criteria`: example Android 앱이 업그레이드된 RN 기준선에서 빌드되고, 앱 전용 필수 동작이 유지된다.
- `Definition of Done`: 필요한 Android 앱 통합 파일이 업데이트되고, 빌드가 통과하며, 근거가 기록되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T3 이후 순차 실행. 쓰기 범위는 명시된 Android 앱 파일로 제한한다.
- `Evidence`: `evidence/t4-android-app.txt`
- `Reopen When`: 이후 Android 검증에서 manifest 또는 host bootstrap 호환성 누락이 드러날 때
- `Size`: M

### T5 - iOS example 템플릿 정렬
- `ID`: T5
- `Slice`: example iOS 템플릿
- `Status`: Todo
- `Depends On`: T1
- `Start When`: T1이 `Done`이고 iOS example이 아직 옛 템플릿 기준선을 반영하고 있을 때 시작한다.
- `Files`: `example/Gemfile`, `example/ios/Podfile`, `example/ios/example/Info.plist`, `example/ios/example.xcodeproj/project.pbxproj`
- `Context`: helper와 changelog는 `0.81`부터 `0.85`까지 Podfile / Info.plist / Xcode project가 반복적으로 바뀌는 흐름을 보여준다.
- `Produces`: Naver Map 전용 설정을 잃지 않으면서 `0.85.1` 시대 템플릿에 정렬된 iOS example 파일
- `Must Do`: 기존 Naver Map plist key, 위치 권한 문자열, scheme/workspace 이름, New Architecture 플래그를 유지한다. 템플릿 소유 빌드 설정은 필요한 범위에서 갱신한다.
- `Must Not Do`: 앱 전용 plist key를 제거하지 않는다. Xcode target 이름을 바꾸지 않는다. 무관한 iOS 정리 작업을 강제하지 않는다.
- `Implementation Notes`: 업데이트된 bundle / pod 흐름이 요구할 때만 `Gemfile` gem을 추가한다. `CADisableMinimumFrameDurationOnPhone`, iPad orientation block 같은 helper 시대 Info.plist 변경은 example 앱의 의도된 orientation 동작과 충돌하지 않을 때만 가져간다. Xcode project 값은 보수적으로 갱신하고 저장소의 target 이름은 유지한다.
- `Verification Strategy`: 1. `pnpm pod` 실행. 2. `pnpm ci:ios` 실행. 성공 신호는 두 명령 모두 `0`으로 끝나는 것이다.
- `Acceptance Criteria`: 업그레이드된 RN 기준선에서 iOS example의 pod/install/build 흐름이 성공하고, 앱 전용 plist/project 설정이 보존된다.
- `Definition of Done`: 필요한 iOS example 파일이 업데이트되고, 검증이 성공하며, 근거가 기록되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T2, T3와 병렬 가능. 쓰기 범위는 명시된 iOS example 파일로 제한한다.
- `Evidence`: `evidence/t5-ios-template.txt`
- `Reopen When`: 이후 iOS 검증 또는 런타임 동작에서 템플릿 drift가 남아 있는 것이 드러날 때
- `Size`: M

### T6 - 중간 체크포인트 실행
- `ID`: T6
- `Slice`: 체크포인트
- `Status`: Todo
- `Depends On`: T2, T4, T5
- `Start When`: T2, T4, T5가 모두 `Done`일 때 시작한다.
- `Files`: `pnpm-workspace.yaml`, `package.json`, `example/package.json`, `example/src/App.tsx`, `example/android/**`, `example/ios/**`
- `Context`: 계획은 `src/**`, `android/**`, `ios/**`를 건드리기 전에 example 템플릿 정렬과 루트 라이브러리 수정 작업을 분리해야 한다.
- `Produces`: 재확인된 범위 경계와 남은 이슈의 실패 분류
- `Must Do`: 변경 파일을 계획과 대조 검토하고, 실패한 검증이 있다면 소유 표면별로 분류한 뒤 T7/T8/T9 중 실제 실행이 필요한 작업을 결정한다.
- `Must Not Do`: 체크포인트 중 새 소스 변경을 하지 않는다. example 템플릿 작업과 루트 라이브러리 수정 작업을 한 단계로 뭉개지 않는다.
- `Implementation Notes`: T1-T5에서 생성된 diff와 evidence를 다시 읽는다. 목표 검증이 모두 이미 통과했다면, 이후 회귀가 나오지 않는 한 T7/T8/T9는 no-op 종료라고 기록한다.
- `Verification Strategy`: 현재 diff를 검토하고 `pnpm run t`를 한 번 다시 실행한다. 성공 신호는 저장소 검증이 통과하거나, 실패 표면이 `src/**`, `android/**`, `ios/**` 중 하나로 명확히 분류되는 것이다.
- `Acceptance Criteria`: 남은 작업이 소유 주체가 명확한 수정 작업으로 축소되고, 실패 위치에 대한 미해결 모호성이 남지 않는다.
- `Definition of Done`: 범위가 다시 확인되고, 근거가 기록되며, 작업 `Status`가 `Done`이 되고, 상태 보드가 갱신되며, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. 순차 실행만 허용. 체크포인트 중 병렬 쓰기 작업은 금지한다.
- `Evidence`: `evidence/t6-checkpoint.txt`
- `Reopen When`: 이후 검증에서 분류되지 않은 표면의 실패가 나타날 때
- `Size`: S

### T7 - 필요 시 루트 JS/spec 회귀 수정
- `ID`: T7
- `Slice`: 루트 JS/spec 수정
- `Status`: Todo
- `Depends On`: T6
- `Start When`: T6가 `Done`이고, `pnpm run t`가 여전히 `src/**` / 루트 TS / codegen 표면에서 실패하거나, 그런 실패가 없다는 no-op 근거가 준비되었을 때 시작한다.
- `Files`: `src/**`, `tsconfig.json`, `package.json`, `script/codegen.mjs`
- `Context`: RN `0.85.1`은 여러 TypeScript 및 codegen 인접 API를 제거하거나 deprecated 처리한다. 루트 라이브러리 수정은 최소 범위이면서 검증 기반이어야 한다.
- `Produces`: 최소한의 JS/spec/codegen 호환성 패치 또는 루트 JS/spec 회귀가 없다는 no-op 종료
- `Must Do`: `src/spec/`, `src/`에 대한 저장소 knowledge 문서를 따른다. public API는 안정적으로 유지하고, 수정 후에는 정확히 실패했던 검증을 다시 실행한다.
- `Must Not Do`: 무관한 wrapper나 public API를 리팩터링하지 않는다. JS/spec 계약 수정이 일치하는 codegen 출력을 요구하지 않는 한 native 코드를 이 작업에서 수정하지 않는다.
- `Implementation Notes`: T6 이후 `pnpm run t`가 통과하면 소스 수정 없이 no-op 메모를 남기고 작업을 끝낸다. 루트 JS/spec 표면에서 실패하면 보고된 호환성 문제만 고치고, wrapper는 얇게 유지하며, helper/template churn은 여기 끌고 오지 않는다.
- `Verification Strategy`: `pnpm run t` 실행. 반복 작업에 너무 넓으면 먼저 `pnpm typecheck`, `pnpm codegen`을 실행한 뒤 다시 `pnpm run t`를 돌린다. 성공 신호는 JS/spec 오류가 사라지거나, 그런 실패가 없었다는 no-op 근거가 존재하는 것이다.
- `Acceptance Criteria`: RN 상향으로 인한 루트 JS/spec 호환성 문제가 해결되었거나, 없다는 것이 명시적으로 입증된다.
- `Definition of Done`: 검증이 성공하거나 no-op 근거가 기록되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T8, T9와는 쓰기 범위가 분리된 경우에만 병렬 가능. 쓰기 범위는 루트 JS/spec 파일로 제한한다.
- `Evidence`: `evidence/t7-root-js-spec.txt`
- `Reopen When`: 이후 검증 단계에서 또 다른 루트 JS/spec 회귀가 드러날 때
- `Size`: M

### T8 - 필요 시 Android 라이브러리 회귀 수정
- `ID`: T8
- `Slice`: 루트 Android 수정
- `Status`: Todo
- `Depends On`: T6
- `Start When`: T6가 `Done`이고, `pnpm ci:android`가 루트 라이브러리 Android/native 표면에서 실패하거나, 그런 실패가 없다는 no-op 근거가 준비되었을 때 시작한다.
- `Files`: `android/**`, `src/spec/**`
- `Context`: RN `0.82+`부터 `0.85`까지는 legacy/new-architecture 인접 Android API가 더 많이 제거되거나 deprecated 처리된다. 라이브러리 수정은 실패한 native 표면에만 한정되어야 한다.
- `Produces`: 최소한의 Android 라이브러리 호환성 패치 또는 Android 라이브러리 회귀가 없다는 no-op 종료
- `Must Do`: New Architecture 가정은 유지한다. spec/event/command 이름 일치는 보존한다. 수정 후에는 Android 빌드를 다시 실행한다.
- `Must Not Do`: 일반 Android 정리 작업으로 범위를 넓히지 않는다. 이 작업에서 example 앱 파일을 수정하지 않는다.
- `Implementation Notes`: example Android 빌드가 이미 통과하고 루트 Android 실패도 없다면 no-op 메모를 남긴다. `android/**` 내부에서 실패하면 직접 실패한 API 또는 빌드 통합만 수정하고, 필요 시 JS/native 계약을 동기화한다.
- `Verification Strategy`: `pnpm ci:android` 실행. 성공 신호는 Android 빌드가 `0`으로 끝나거나, 루트 Android 수정이 필요 없었다는 no-op 근거가 존재하는 것이다.
- `Acceptance Criteria`: RN 상향으로 인한 루트 Android 호환성 문제가 해결되었거나, 없다는 것이 명시적으로 입증된다.
- `Definition of Done`: 검증이 성공하거나 no-op 근거가 기록되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T7, T9와는 쓰기 범위가 분리된 경우에만 병렬 가능. 쓰기 범위는 루트 Android/native 파일로 제한한다.
- `Evidence`: `evidence/t8-root-android.txt`
- `Reopen When`: 이후 Android 검증 단계에서 루트 라이브러리 Android 코드 실패가 나타날 때
- `Size`: M

### T9 - 필요 시 iOS 라이브러리 회귀 수정
- `ID`: T9
- `Slice`: 루트 iOS 수정
- `Status`: Todo
- `Depends On`: T6
- `Start When`: T6가 `Done`이고, `pnpm ci:ios`가 루트 라이브러리 iOS/native 표면에서 실패하거나, 그런 실패가 없다는 no-op 근거가 준비되었을 때 시작한다.
- `Files`: `ios/**`, `src/spec/**`
- `Context`: RN `0.81+`부터 `0.85`까지 iOS build/runtime 및 prebuilt 통합 방식이 반복적으로 바뀐다. 라이브러리 수정은 실패한 iOS native 표면에만 한정되어야 한다.
- `Produces`: 최소한의 iOS 라이브러리 호환성 패치 또는 iOS 라이브러리 회귀가 없다는 no-op 종료
- `Must Do`: Fabric 전용 가정을 유지한다. native command/event 동작이 `src/spec/**`와 계속 일치하도록 유지한다. 수정 후에는 pod/build 검증을 다시 실행한다.
- `Must Not Do`: example 전용 iOS 템플릿 파일을 이 작업에서 바꾸지 않는다. Bridge 시대 fallback 로직을 도입하지 않는다.
- `Implementation Notes`: iOS 빌드가 이미 통과하고 루트 iOS 실패도 없다면 no-op 메모를 남긴다. `ios/**` 내부에서 실패하면 직접 실패한 호환성 문제만 고치고, 필요한 경우 spec 일치를 유지한다.
- `Verification Strategy`: `pnpm pod` 후 `pnpm ci:ios` 실행. 성공 신호는 두 명령이 모두 `0`으로 끝나거나, 루트 iOS 수정이 필요 없었다는 no-op 근거가 존재하는 것이다.
- `Acceptance Criteria`: RN 상향으로 인한 루트 iOS 호환성 문제가 해결되었거나, 없다는 것이 명시적으로 입증된다.
- `Definition of Done`: 검증이 성공하거나 no-op 근거가 기록되고, 작업 `Status`가 `Done`이 되며, 상태 보드가 갱신되고, `tasks.md` 재확인으로 상태가 유지되는 것이 확인된다.
- `Delegation`: 부모 직접 수행. T7, T8과는 쓰기 범위가 분리된 경우에만 병렬 가능. 쓰기 범위는 루트 iOS/native 파일로 제한한다.
- `Evidence`: `evidence/t9-root-ios.txt`
- `Reopen When`: 이후 iOS 검증 단계에서 루트 라이브러리 iOS 코드 실패가 나타날 때
- `Size`: M

### T10 - 최종 검증 웨이브 실행
- `ID`: T10
- `Slice`: 최종 검증
- `Status`: Todo
- `Depends On`: T7, T8, T9
- `Start When`: T7, T8, T9가 no-op 종료를 포함해 모두 `Done`일 때 시작한다.
- `Files`: `pnpm-workspace.yaml`, `package.json`, `example/package.json`, `src/**`, `android/**`, `ios/**`, `example/**`
- `Context`: 번들을 닫으려면 새 RN 기준선, example 템플릿 갱신, 필요한 수정 작업이 모두 함께 유지되는지 저장소 전반에서 최종 확인해야 한다.
- `Produces`: 최종 검증 출력과 선택적 런타임 스모크 근거
- `Must Do`: 계획된 검증 명령을 순서대로 실행하고, 출력은 `evidence/` 아래에 저장한다. 시크릿이 있으면 example 앱 수동 스모크 검증을 한 번 포함한다.
- `Must Not Do`: 최종 검증 중에는 실패로 인해 관련 수정 작업을 다시 열어야 하는 경우를 제외하고 추가 소스 변경을 하지 않는다.
- `Implementation Notes`: 정확한 순서는 다음과 같다. 1. `pnpm run t` 2. `pnpm ci:android` 3. `pnpm pod` 4. `pnpm ci:ios` 5. `example/android/app/src/main/res/values/secret.xml`, `example/ios/Secret.xcconfig`가 있으면 `pnpm android` 및/또는 `pnpm ios`를 실행하고, example 화면 목록이 렌더링되며 지도 화면 하나 이상에 진입되는지 확인한다. 시크릿이 없으면 실패로 취급하지 말고 그 사유로 스모크를 건너뛰었다고 기록한다.
- `Verification Strategy`: 위 순서대로 명령을 실행한다. 성공 신호는 필수 명령이 모두 `0`으로 끝나고, 런타임 스모크가 성공하거나 skip 메모가 시크릿 부재를 명시하는 것이다.
- `Acceptance Criteria`: 워크스페이스, example 앱, 루트 라이브러리가 모두 RN `0.85.1` 기준선에서 저장소 기본 명령으로 검증되고, 최종 근거가 남아 있다.
- `Definition of Done`: 최종 검증이 성공하고, 근거가 저장되며, 작업 `Status`가 `Done`이 되고, 상태 보드가 갱신되며, `tasks.md` 재확인으로 남은 실행 작업이 없음을 확인한다.
- `Delegation`: 부모 직접 수행. 순차 실행만 허용. 최종 검증 중 병렬 쓰기 작업은 금지한다.
- `Evidence`: `evidence/t10-final-verification.txt`
- `Reopen When`: 이후 검증이 실패하거나, 런타임 스모크에서 빌드 검증이 잡지 못한 회귀가 발견될 때
- `Size`: M

## 재조정 패스 (Reconciliation Pass)

- 아직 구현을 수행하지 않았으므로, 이 번들은 모든 실행 작업이 `Todo` 상태에서 시작한다.
- 이후 실행이 시작됐을 때 추적되지 않은 선행 업그레이드 작업이 발견되면, 실행자는 계속 진행하기 전에 실제 저장소 상태와 작업 정의를 먼저 재조정해야 한다.
