export interface BaseOverlayProps {
  /** z index의 위치입니다. 기본값은 오버레이의 타입에 따라 다릅니다.
   *
   * - 정보 창: 400000
   * - 위치 오버레이: 300000
   * - 마커: 200000
   * - 화살표 오버레이: 100000
   * - (지도 심벌)
   * - 경로선 오버레이: -100000
   * - 셰이프(폴리곤, 폴리라인, 서클): -200000
   * - 지상 오버레이: -300000
   * - (지도 배경)
   * */
  zIndex?: number;
  /** 감춰진 여부입니다. */
  isHidden?: boolean;
  /** 지도에 보이는 최소 줌 레벨입니다. */
  minZoom?: number;
  /** 지도에 보이는 최대 줌 레벨입니다. */
  maxZoom?: number;
  /** 최소 줌 레벨이 포함될 때도 보이는 지 여부입니다. */
  isMinZoomInclusive?: boolean;
  /** 최대 줌 레벨이 포함될 때도 보이는 지 여부입니다. */
  isMaxZoomInclusive?: boolean;
  /**
   *  오버레이를 클릭했을 때의 이벤트입니다.
   *  @group Events
   */
  onTap?: () => void;
}
