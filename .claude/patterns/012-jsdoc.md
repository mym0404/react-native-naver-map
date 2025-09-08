# jsdoc

# JSDoc Documentation

[EXPLANATION] JSDoc documentation patterns for TypeScript components and methods

## Usage

### Component Documentation
```typescript
/**
 * 네이티브 렌더링을 사용하는 네이버 지도 컴포넌트입니다.
 */
export const NaverMapView: React.FC<NaverMapViewProps> = (props) => {};
```

### Method Documentation
```typescript
/**
 * 화면 좌표를 지리 좌표로 변환합니다.
 * @param x 화면 X 좌표
 * @param y 화면 Y 좌표
 * @returns LatLng를 반환하는 Promise
 */
screenToCoordinate(x: number, y: number): Promise<LatLng>;
```

### With Examples
```typescript
/**
 * 카메라를 지정된 위치로 애니메이션합니다.
 * @param latitude 위도
 * @param longitude 경도
 * @param zoom 줌 레벨 (선택사항)
 * @default zoom 현재 줌 레벨 유지
 * @example
 * ```typescript
 * mapRef.current?.animateCameraTo(37.5665, 126.9780, 15);
 * ```
 */
animateCameraTo(latitude: number, longitude: number, zoom?: number): void;
```
