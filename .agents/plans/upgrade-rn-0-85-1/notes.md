# React Native 0.85.1 업그레이드

## 발견 사항 (Discoveries)

- [2026-04-14 00:16Z] 발견: `pnpm-workspace.yaml`의 workspace catalog가 루트 라이브러리 패키지와 `example/` 모두의 실제 버전 원천이다.
- [2026-04-14 00:16Z] 발견: `0.80.0 -> 0.85.1` Upgrade Helper 렌더링 diff에는 `android/app/src/debug/AndroidManifest.xml` 삭제를 포함해 18개의 변경 파일 항목이 노출된다.
- [2026-04-14 00:16Z] 발견: `example/src/App.tsx`는 이미 `react-native-safe-area-context`를 사용하므로, helper의 safe-area 가이드는 stock 템플릿 재작성 대상이 아니라 선택적 검토 대상이다.
- [2026-04-14 00:16Z] 발견: 현재 저장소에는 `jest.config.js`나 Jest 스크립트가 없으므로, helper의 Jest preset 위치 변경은 자동으로 반영할 항목이 아니다.
- [2026-04-14 00:16Z] 발견: `0.85.1`까지의 RN changelog는 Node 22+, New Architecture 강제, Android 툴체인 drift, iOS 템플릿 drift를 주요 업그레이드 압력으로 보여준다.

## 결정 사항 (Decisions)

- [2026-04-14 00:16Z] 결정: 번들 경로는 `.agents/plans/upgrade-rn-0-85-1/` 하나만 사용한다. 근거: 목표 버전을 직접 드러내고, 겹치는 기존 번들이 없다.
- [2026-04-14 00:16Z] 결정: Upgrade Helper는 루트 라이브러리 패키지용 패치가 아니라 `example/` 템플릿 기준선으로만 취급한다. 근거: 이 저장소는 workspace catalog에 버전을 중앙화하고 있고 example 구조도 커스텀이다.
- [2026-04-14 00:16Z] 결정: 실제 Jest 사용이 도입되지 않는 한 helper 전용 Jest 설정은 추가하지 않는다. 근거: 현재 저장소는 Jest를 사용하지 않으며, 이를 추가하면 검증 근거 없이 범위가 넓어진다.
- [2026-04-14 00:16Z] 결정: 초기 템플릿/툴체인 정렬과 루트 라이브러리 호환성 수정은 분리한다. 근거: 실패 원인을 올바른 표면에 귀속시킬 수 있고 추측성 native churn을 막을 수 있다.

## 리스크 (Risks)

- [2026-04-14 00:16Z] 리스크: Node 22+가 설치되어 있지 않으면 로컬 실행이 즉시 실패할 수 있다.
- [2026-04-14 00:16Z] 리스크: helper가 제안하는 `example/android/app/src/debug/AndroidManifest.xml` 삭제는 현재 저장소의 Metro/debug 동작과 충돌할 수 있다.
- [2026-04-14 00:16Z] 리스크: 루트 라이브러리 native 코드는 템플릿 diff만으로 보이지 않는 RN `0.82+`~`0.85` API 제거에 걸릴 수 있다.
- [2026-04-14 00:16Z] 리스크: 빌드가 통과하더라도 로컬 Naver Map 시크릿이 없으면 수동 런타임 검증이 막힐 수 있다.

## 수정 이력 (Revision Notes)

- [2026-04-14 00:16Z] 수정 이력: Upgrade Helper evidence와 RN changelog evidence를 포함한 초기 의사결정 완료 planner 번들을 생성했다.

## 회고 (Retrospective)

- 아직 없음
