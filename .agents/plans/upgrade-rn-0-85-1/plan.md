# React Native 0.85.1 업그레이드

## 요약 (TL;DR)

워크스페이스가 관리하는 React Native 기준 버전을 `0.80.0`에서 `0.85.1`로 올리고, `example/` 앱을 필요한 범위에서 `0.85.1` 템플릿에 맞춘다. 검증 중 드러나는 루트 라이브러리 호환성 문제는 별도 조건부 작업으로 분리한다. 핵심 경로는 catalog 버전 상향 -> example 템플릿/툴체인 정렬 -> lockfile/pod 동기화 -> 검증 기반 호환성 수정 -> 최종 검증이다.

## 배경 (Context)

- 사용자는 구현 전에 실행 플랜 번들과 사전 조사 산출물을 명시적으로 요청했다.
- 루트 패키지는 배포용 라이브러리지만, 루트 패키지와 `example/` 모두 워크스페이스 catalog를 통해 `react` / `react-native`를 사용한다.
- Upgrade Helper는 example 앱의 템플릿 기준선이지, 루트 라이브러리 패키지에 그대로 적용하는 패치가 아니다.
- 이 저장소는 이미 New Architecture 전용 방향을 문서화하고 있고, 목표 RN 범위에서도 구식 아키텍처 경로가 더 제거되거나 축소된다.
- Upgrade Helper 파일 인벤토리와 RN changelog 조사 결과는 `evidence/` 아래에 저장한다.

## 목표 (Goal)

이 저장소를 React Native `0.85.1`로 업그레이드하기 위한 의사결정 완료 상태의 실행 계약을 만든다. 템플릿 diff와 공식 changelog 영향에 대한 근거도 미리 확보한다.

## 비목표 (Non-Goals)

- 릴리스 발행
- 빌드/런타임 호환성과 무관한 문서 수정
- 검증으로 필요성이 입증되지 않은 라이브러리 API 리팩터링
- 업그레이드가 강제하지 않는 한 현재 저장소가 쓰지 않는 Jest 등 새 툴링 추가
- RN `0.85.1` 호환성 범위를 벗어나는 광범위한 정리 작업

## 제약 (Constraints)

- Planner-only: `.agents/plans/upgrade-rn-0-85-1/` 밖의 소스는 수정하지 않는다.
- 버전의 단일 진실 원천은 workspace catalog다.
- helper/changelog가 필수 변경이라고 보여주지 않는 한, 저장소 고유 커스터마이징은 유지한다.
- `example` 앱은 React Native CLI 앱으로 유지하고 Expo로 바꾸지 않는다.
- 저장소 전반에서 New Architecture는 유지한다.
- 템플릿 기준선을 갱신하더라도 Naver Map 관련 Android/iOS 커스텀 설정은 보존한다.
- 수동 런타임 검증은 로컬 시크릿 유무에 따라 막힐 수 있다.
  `example/android/app/src/main/res/values/secret.xml`, `example/ios/Secret.xcconfig`

## 명령어 (Commands)

- `browser-use --browser chromium --session upgrade-helper open 'https://react-native-community.github.io/upgrade-helper/?from=0.80.0&to=0.85.1'`
- `browser-use --session upgrade-helper get html --selector '[data-testid="diffSection"]'`
- `curl -Ls https://raw.githubusercontent.com/facebook/react-native/main/CHANGELOG.md`
- `pnpm install`
- `pnpm exec tsc -p example/tsconfig.json --noEmit`
- `pnpm run t`
- `cd example/android && ./gradlew help`
- `pnpm ci:android`
- `pnpm pod`
- `pnpm ci:ios`

## 프로젝트 구조 (Project Structure)

- `pnpm-workspace.yaml`: workspace catalog와 hoisting 동작
- `package.json`: 루트 라이브러리 패키지 메타데이터와 루트 개발 툴체인
- `example/package.json`: example 런타임/툴체인 메타데이터
- `example/src/App.tsx`: 커스텀 example 앱 셸
- `example/tsconfig.json`: 루트 TS 설정을 감싸는 example 전용 래퍼
- `example/android/**`: Android example 프로젝트
- `example/ios/**`: iOS example 프로젝트
- `src/**`, `android/**`, `ios/**`: 버전 상향 후 호환성 수정이 필요할 수 있는 루트 라이브러리 표면

## 테스트 전략 (Testing Strategy)

- 먼저 의존성 버전을 올리고 잠근다.
- 저장소 전체 검증 전에 example 셸을 집중된 TS 체크로 확인한다.
- 템플릿 정렬 후 Android/iOS example 프로젝트를 저장소 기본 검증 명령으로 확인한다.
- 의존성 동기화 후 루트 저장소 검증을 실행해 TypeScript/spec/build 회귀를 잡는다.
- 검증 기반 수정 작업은 표면별로 분리한다: JS/spec, Android native, iOS native.
- 마지막에는 최종 검증 웨이브를 수행하고, 시크릿이 있으면 수동 런타임 스모크도 선택적으로 진행한다.

## 성공 기준 (Success Criteria)

- workspace catalog가 루트 패키지와 `example/` 모두에 대해 RN `0.85.1`과 React `19.2.3`을 해석한다.
- `example/`이 저장소 고유 커스터마이징을 잃지 않으면서 필요한 `0.85.1` 템플릿/툴체인 변경을 반영한다.
- `pnpm run t`, `pnpm ci:android`, `pnpm ci:ios`가 통과한다.
- 루트 라이브러리 호환성 수정은 실제 검증으로 입증된 표면에만 한정된다.
- upgrade-helper 인벤토리, changelog 검토, 체크포인트, 최종 검증 근거가 번들 아래에 존재한다.

## 열린 질문 (Open Questions)

- 없음

## 작업 목표 (Work Objectives)

- 워크스페이스 버전 매트릭스를 올바른 중앙 위치에서 갱신한다.
- 템플릿을 맹목적으로 복사하지 않고 `example/`을 helper/changelog 변경에 맞춘다.
- Android/iOS 템플릿 변경과 루트 라이브러리 수정 작업을 분리한다.
- 호환성 수정은 저장소 기본 검증으로 실패가 확인된 경우로만 제한한다.
- `evidence/` 아래에 완전한 감사 추적을 남긴다.

## 검증 전략 (Verification Strategy)

- 임시 셸 스크립트보다 저장소 기본 명령을 우선한다.
- 전체 웨이브를 기다리지 말고 각 작업 직후 집중 검증을 수행한다.
- 검증 통과를 이진 성공 신호로 본다. 조건부 작업에서 실패가 없으면 억지 코드 변경 대신 no-op 근거를 남긴다.
- 수집한 출력, no-op 메모, 체크포인트 요약은 모두 `.agents/plans/upgrade-rn-0-85-1/evidence/` 아래에 저장한다.
- 수동 런타임 검증은 최선을 다하되 로컬 시크릿이 있을 때만 요구한다.

## 실행 전략 (Execution Strategy)

- 이후 모든 작업이 RN 해석 결과에 의존하므로 catalog와 lockfile부터 시작한다.
- example JS/runtime, Android 템플릿/툴체인, iOS 템플릿 갱신을 분리해 플랫폼 실패를 섞지 않는다.
- 수정 작업 전에 체크포인트를 둬서 호환성 수정이 추측이 아니라 실제 검증 결과에 의해 결정되도록 한다.
- 이 저장소에 없는 helper 전용 파일은 필수가 아니라 선택 항목으로 본다.
- 루트 라이브러리 표면에서 검증 실패가 나면, 가장 작은 실패 지점을 고치고 같은 검증을 다시 돌린 뒤에만 다음 단계로 진행한다.

## 병렬 웨이브 (Parallel Waves)

- 웨이브 1: `T1`
  중앙 의존성 상향이 가장 먼저 끝나야 한다.
- 웨이브 2: `T2`, `T3`, `T5`
  `T1` 이후에는 쓰기 범위가 겹치지 않으므로 병렬로 진행할 수 있다.
- 웨이브 3: `T4`
  `T3`의 Android 툴체인 정렬이 선행 조건이다.
- 웨이브 4: `T6`
  example/템플릿 작업 뒤의 체크포인트다.
- 웨이브 5: `T7`, `T8`, `T9`
  조건부 수정 작업이다. 실패 조건이 실제로 발동한 작업만 소스 변경을 수행한다.
- 웨이브 6: `T10`
  필요한 수정 작업이 모두 끝나거나 no-op로 정리된 뒤의 최종 검증이다.

## 산출물 그래프 (Artifact Graph)

- `T1 -> T2`
- `T1 -> T3`
- `T1 -> T5`
- `T3 -> T4`
- `T2 + T4 + T5 -> T6`
- `T6 -> T7`
- `T6 -> T8`
- `T6 -> T9`
- `T7 + T8 + T9 -> T10`
- `T10 ready_when final validations pass and evidence is captured`

## 체크포인트 계획 (Checkpoint Plan)

- `T6`가 주요 중간 체크포인트다.
- `T6`에서 변경 집합과 근거를 다시 읽고, 업그레이드 범위가 의존성/템플릿 정렬과 검증 기반 수정에만 머무르는지 확인한다. 남은 실패는 소유 표면별로 분류한 뒤에만 진행한다.

## 최종 검증 웨이브 (Final Verification Wave)

- `pnpm run t` 실행
- `pnpm ci:android` 실행
- `pnpm pod` 실행
- `pnpm ci:ios` 실행
- 시크릿이 있으면 example 앱을 최소 한 번 수동 실행해서 화면 목록이 렌더링되고 지도 화면 하나 이상에 진입 가능한지 확인
- 모든 출력과 수동 스모크 메모는 `evidence/` 아래에 저장

## 동기화/재조정 규칙 (Sync/Reconcile Rules)

- 실행자는 현재 활성 작업이 명시한 소스 파일, `notes.md`, `evidence/`, 그리고 `tasks.md`의 허용된 상태/근거 필드만 수정할 수 있다.
- 저장소 레이아웃이나 검증 경로가 바뀌어 작업 정의가 낡았으면, 임의로 진행하지 말고 번들을 planner에게 되돌린다.
- 예상했던 호환성 수정 작업이 불필요해지면 범위를 넓히지 말고 no-op 근거를 남긴 뒤 완료 처리한다.
- 계획된 쓰기 범위를 벗어난 새 실패가 나타나면, 미계획 리팩터링으로 확장하지 말고 다시 계획 단계로 올린다.
