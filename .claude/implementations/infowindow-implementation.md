# InfoWindow Implementation

## 개요

네이버 지도 SDK의 InfoWindow 기능을 React Native Naver Map 라이브러리에 구현했습니다.
InfoWindow는 마커나 특정 좌표에 부가 정보를 표시하는 말풍선 형태의 오버레이입니다.

## 구현 내용

### 1. TypeScript Spec 및 타입 정의

**파일**: `src/spec/RNCNaverMapInfoWindowNativeComponent.ts`

- Fabric Component Spec 정의
- BaseOverlay 속성 상속
- InfoWindow 전용 속성:
  - `coord`: 위치 좌표
  - `markerTag`: 연결할 마커 태그 (선택)
  - `align`: 정렬 방향
  - `anchor`: 앵커 포인트
  - `offsetX`, `offsetY`: 오프셋
  - `alpha`: 불투명도
  - `text`: 표시 텍스트
  - `textSize`, `textColor`: 텍스트 스타일
  - `backgroundColor`: 배경색

### 2. Android 구현

#### RNCNaverMapInfoWindow.kt
**위치**: `android/src/main/java/com/mjstudio/reactnativenavermap/overlay/infowindow/`

- `NMFInfoWindow` 래핑
- 커스텀 어댑터 패턴 구현 (`RNCNaverMapInfoWindowAdapter`)
- 텍스트 및 스타일 동적 업데이트
- 마커 연결 지원 (예정)

#### RNCNaverMapInfoWindowManager.kt
**위치**: `android/src/main/java/com/mjstudio/reactnativenavermap/overlay/infowindow/`

- ViewManager 구현 (Codegen Delegate 패턴)
- ReactProp을 통한 속성 처리

#### RNCNaverMapInfoWindowManagerSpec.kt
**위치**: `android/src/newarch/`

- New Architecture Spec 클래스
- ViewManagerDelegate 연결

### 3. iOS 구현

#### RNCNaverMapInfoWindow.h/mm
**위치**: `ios/Overlay/InfoWindow/`

- `NMFInfoWindow` 래핑
- Fabric Component View 구현
- Props 업데이트 처리
- `dataSource` 블록을 통한 커스텀 뷰 생성
- UILabel 기반 텍스트 렌더링
- 스타일링 (테두리, 라운드 코너, 패딩)

### 4. React Component

**파일**: `src/component/NaverMapInfoWindow.tsx`

- Props interface 정의 (`NaverMapInfoWindowProps`)
- JSDoc 문서화
- 사용 예제 포함
- 기본값 설정
- Color 처리 (`processColor`)
- Align 변환

### 5. 등록 및 Export

- **Android**: `RNCNaverMapPackage.kt`에 ViewManager 등록
- **iOS**: `RNCNaverMapViewImpl.h`에 import 추가, `insertReactSubview`에 처리 추가
- **Export**: `src/index.tsx`에 컴포넌트 및 타입 export

## 사용 예제

```tsx
import { NaverMapInfoWindow } from '@mj-studio/react-native-naver-map';

// 특정 좌표에 InfoWindow 표시
<NaverMapInfoWindow
  latitude={37.5666102}
  longitude={126.9783881}
  text="서울시청"
  textSize={14}
  textColor="black"
  backgroundColor="white"
/>

// 마커에 연결된 InfoWindow
<NaverMapMarkerOverlay
  identifier="marker1"
  latitude={37.5666102}
  longitude={126.9783881}
/>
<NaverMapInfoWindow
  identifier="marker1"
  latitude={37.5666102}
  longitude={126.9783881}
  text="마커 정보"
  isOpen={true}
  // Android only: 커스텀 스타일
  fontWeight="bold"
  borderRadius={10}
  borderColor="#4263eb"
/>
```

## 참고 자료

- [Android InfoWindow 공식 문서](https://navermaps.github.io/android-map-sdk/guide-ko/5-3.html)
- [iOS NMFInfoWindow API](https://navermaps.github.io/maps.js.ncp/docs/naver.maps.InfoWindow.html)

## 플랫폼별 스타일 지원 현황

### Android ✅ (완전 지원)
- ✅ `text`, `textSize`, `textColor`
- ✅ `fontWeight` - Bold/Regular/Medium/Semibold (100-900)
- ✅ `backgroundColor`
- ✅ `borderRadius` - 둥근 모서리
- ✅ `borderWidth`, `borderColor` - 테두리
- ✅ `padding` - 내부 여백
- ✅ 마커 연결 (`identifier`)
- ✅ 열림/닫힘 제어 (`isOpen`)

**구현 방식:**
```kotlin
// GradientDrawable로 커스텀 스타일 구현
val drawable = GradientDrawable().apply {
  setColor(backgroundColor)
  cornerRadius = borderRadius
  setStroke(borderWidth.toInt(), borderColor)
}
```

### iOS ⚠️ (텍스트만 지원)
- ✅ `text` - 텍스트 내용
- ✅ 마커 연결 (`identifier`)
- ✅ 열림/닫힘 제어 (`isOpen`)
- ❌ `textSize`, `textColor` - 무시됨
- ❌ `fontWeight`, `borderRadius`, `borderWidth`, `borderColor`, `padding` - 무시됨

**제한 이유:**
iOS의 `NMFInfoWindow`는 기본적으로 `NMFInfoWindowDefaultTextSource`를 사용하며, 이는 말풍선 스타일의 텍스트만 표시합니다.

커스텀 스타일을 위해 `NMFOverlayImageDataSource`를 시도했으나:
- `NMFInfoWindow`가 내부적으로 `toUIImage` 메서드 호출 (존재하지 않음)
- 일반 오버레이와 달리 InfoWindow는 이미지 기반 커스터마이징 미지원
- 구현 시도 시 에러 발생 내용:  `-[NMFOverlayImage toUIImage]: unrecognized selector`

### iOS에서 커스텀 스타일이 필요한 경우

**Option 1: Marker의 Custom View 사용**
```tsx
<NaverMapMarkerOverlay latitude={37.5} longitude={126.5}>
  <View style={{ 
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 10,
    borderWidth: 2,
    borderColor: '#4263eb'
  }}>
    <Text style={{ fontWeight: 'bold' }}>커스텀 정보</Text>
  </View>
</NaverMapMarkerOverlay>
```

**Option 2: 플랫폼별 조건부 렌더링**
```tsx
{Platform.OS === 'android' ? (
  <NaverMapInfoWindow
    identifier="marker1"
    text="마커 정보"
    fontWeight="bold"
    borderRadius={10}
  />
) : (
  <NaverMapMarkerOverlay identifier="info-marker">
    <CustomInfoView />
  </NaverMapMarkerOverlay>
)}
```

## 구현 패턴

이 구현은 다음 패턴을 따릅니다:

- **Pattern #001**: Fabric Native Component Definition
- **Pattern #008**: Android ViewManager with Codegen
- **Pattern #004**: iOS Fabric Component Implementation

## 테스트

구현 후 다음을 확인해야 합니다:

1. Codegen 정상 실행 (`pnpm codegen`)
2. Lint 오류 없음
3. 예제 앱에서 InfoWindow 표시 확인
4. Android/iOS 모두에서 동작 확인
5. 속성 변경 시 동적 업데이트 확인

## 완료 상태

- ✅ TypeScript Spec 및 타입 정의
- ✅ Android 네이티브 구현 (모든 스타일 지원)
- ✅ iOS 네이티브 구현 (기본 텍스트)
- ✅ React Component 작성
- ✅ Package 등록
- ✅ Export 추가
- ✅ 마커 연결 기능 (`identifier`)
- ✅ 열림/닫힘 제어 (`isOpen`)
- ✅ Marker Registry 구현
- ⚠️ iOS 커스텀 스타일 (API 제한으로 미지원)

## 사용 권장사항

- **간단한 텍스트만 필요**: InfoWindow 사용 (양쪽 플랫폼)
- **커스텀 스타일 필요 (Android만)**: InfoWindow 사용, iOS는 기본 스타일
- **커스텀 스타일 필요 (양쪽 플랫폼)**: Marker의 Custom View 사용

