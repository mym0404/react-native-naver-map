/**
 * Coord는 하나의 위경도 좌표를 나타내는 클래스입니다. latitude 속성이 위도를,
 * longitude 속성이 경도를 나타냅니다. LatLng의 모든 속성은 final이므로 각 속성은 생성자로만 지정할 수 있고, 한 번 생성된 객체의 속성은 변경할 수 없습니다.
 */
export type Coord = {
  latitude: number;
  longitude: number;
};
