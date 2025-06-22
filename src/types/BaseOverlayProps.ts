export interface BaseOverlayProps {
  /** z index의 위치입니다. 기본값은 0입니다.
   *
   * 주의해야 할 점은 이 zIndex가 높다고 항상 위에 보이는 것이 아니라는 점입니다.
   *
   * global zIndex와 보조 zIndex가 존재하며 이 값은 보조 zIndex입니다.
   *
   * 보조 zIndex는 global zIndex가 같은 오버레이들 중 겹침 우선순위를 조절하는 옵션입니다.
   *
   * @see {@link globalZIndex}
   * @default 0
   * */
  zIndex?: number;
  /** 지도에서 global z index의 위치입니다. 기본값은 오버레이의 타입에 따라 다릅니다.
   *
   * 전역 Z 인덱스. 여러 오버레이가 화면에서 겹쳐지면 전역 Z 인덱스가 큰 오버레이가 작은 오버레이를 덮습니다.
   *
   * 또한 값이 0 이상이면 오버레이가 심벌 위에, 0 미만이면 심벌 아래에 그려집니다.
   *
   * 다음은 global zIndex의 값들입니다.
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
   *
   * @see {@link zIndex}
   * @default null
   * */
  globalZIndex?: number;
  /** 감춰진 여부입니다. */
  isHidden?: boolean;
  /**
   * 지도에 보이는 최소 줌 레벨입니다.
   *
   * @default 0
   */
  minZoom?: number;
  /**
   * 지도에 보이는 최대 줌 레벨입니다.
   *
   * @default 21
   */
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
