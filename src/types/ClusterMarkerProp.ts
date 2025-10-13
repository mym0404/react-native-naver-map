import type { Coord } from './Coord';
import type { MapImageProp } from './MapImageProp.ts';

/**
 * 클러스터에 포함될 수 있는 마커의 속성입니다.
 */
export interface ClusterMarkerProp extends Coord {
  /**
   * 클러스터 내에서 마커를 구분하는 고유 식별자입니다.
   * 클러스터 이벤트에서 개별 마커를 식별하는 데 사용됩니다.
   */
  identifier: string;

  image?: MapImageProp;

  /**
   * 마커의 너비 (픽셀 단위).
   */
  width?: number;

  /**
   * 마커의 높이 (픽셀 단위).
   */
  height?: number;
}
