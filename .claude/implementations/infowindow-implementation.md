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

- `InfoWindow` 래핑
- **커스텀 어댑터 패턴 구현** (`RNCNaverMapInfoWindowAdapter`)
  - `InfoWindow.ViewAdapter()` 상속
  - `getView()` 메서드에서 커스텀 View 생성
  - TextView + FrameLayout으로 구성
  - GradientDrawable로 배경, 테두리, 라운드 코너 구현
- 텍스트 및 스타일 동적 업데이트
- 마커 연결 지원 (`identifier`를 통한 Marker Registry 조회)
- 열림/닫힘 상태 제어

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
- **커스텀 데이터 소스 구현** (`RNCNaverMapInfoWindowDataSource`)
  - `NMFOverlayImageDataSource` 프로토콜 채택
  - `viewWithOverlay:` 메서드로 UIView 직접 반환
  - UILabel 기반 텍스트 렌더링
  - CALayer를 통한 스타일링 (테두리, 라운드 코너, 배경색)
  - 패딩 및 폰트 굵기 지원
- 속성 변경 시 `invalidate()` 호출하여 자동 재렌더링
- Retina 디스플레이 대응
- `nmap::intToColor()` 함수로 색상 변환

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
  // 커스텀 스타일 (Android & iOS 모두 지원)
  fontWeight="bold"
  borderRadius={10}
  borderColor="#4263eb"
/>
```

## 참고 자료

- [Android InfoWindow 공식 문서](https://navermaps.github.io/android-map-sdk/guide-ko/5-3.html)
- [iOS NMFInfoWindow API](https://navermaps.github.io/ios-map-sdk/reference/Classes/NMFInfoWindow.html)
- [iOS NMFOverlayImageDataSource 프로토콜](https://navermaps.github.io/ios-map-sdk/reference/Protocols/NMFOverlayImageDataSource.html)

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

### iOS ✅ (완전 지원)
- ✅ `text`, `textSize`, `textColor`
- ✅ `fontWeight` - Regular/Medium/Semibold/Bold (100-900)
- ✅ `backgroundColor`
- ✅ `borderRadius` - 둥근 모서리
- ✅ `borderWidth`, `borderColor` - 테두리
- ✅ `padding` - 내부 여백
- ✅ 마커 연결 (`identifier`)
- ✅ 열림/닫힘 제어 (`isOpen`)

**구현 방식:**
```objective-c
// NMFOverlayImageDataSource 프로토콜의 viewWithOverlay: 메서드 구현
- (UIView*)viewWithOverlay:(NMFOverlay*)overlay {
  // UILabel과 UIView를 사용하여 커스텀 스타일 구현
  UIView* containerView = [[UIView alloc] init];
  containerView.backgroundColor = backgroundColor;
  containerView.layer.cornerRadius = borderRadius;
  containerView.layer.borderWidth = borderWidth;
  containerView.layer.borderColor = borderColor.CGColor;
  // ... 텍스트와 패딩 설정
  return containerView;
}
```

**주요 특징:**
- Retina 디스플레이 지원
- 동적 스타일 업데이트 (`invalidate()` 호출)
- 빈 텍스트 처리 및 최소 크기 보장
- Android와 동일한 모든 스타일 속성 지원

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
- ✅ iOS 네이티브 구현 (모든 스타일 지원)
- ✅ React Component 작성
- ✅ Package 등록
- ✅ Export 추가
- ✅ 마커 연결 기능 (`identifier`)
- ✅ 열림/닫힘 제어 (`isOpen`)
- ✅ Marker Registry 구현
- ✅ iOS 커스텀 스타일 (NMFOverlayImageDataSource 프로토콜 활용)

## 사용 권장사항

- **텍스트 정보 표시**: InfoWindow 사용 (양쪽 플랫폼 모두 완전 지원)
- **커스텀 스타일**: InfoWindow 사용 (Android & iOS 모두 모든 스타일 속성 지원)
- **복잡한 인터랙션**: 필요한 경우 Marker의 Custom View 사용 고려

