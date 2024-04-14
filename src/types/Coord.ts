/**
 * Coord는 하나의 위경도 좌표를 나타내는 객체입니다.
 * latitude 속성이 위도를, longitude 속성이 경도를 나타냅니다.
 */
export interface Coord {
  /** 위도 */
  latitude: number;
  /** 경도 */
  longitude: number;
}
