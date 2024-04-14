/**
 * 지도에 보이는 위치의 상태를 의미하는 객체입니다.
 */
export interface Region {
  /** 위도, 대개 더 작은 위도 값이며 정확히는 south-west 지점의 latitude 입니다. */
  latitude: number;
  /** 경도, 대개 더 작은 경도 값이며 정확히는 south-west 지점의 longitude 입니다. */
  longitude: number;
  /** north-east 지점의 latitude와 latitude와의 위도차이 입니다. */
  latitudeDelta: number;
  /** north-east 지점의 longitude와 longitude와의 경도차이 입니다. */
  longitudeDelta: number;
}
