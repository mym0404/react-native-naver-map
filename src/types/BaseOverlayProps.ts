export interface BaseOverlayProps {
  // z index의 위치입니다.
  zIndex?: number;
  // 감춰진 여부입니다.
  isHidden?: boolean;
  // 지도에 보이는 최소 줌 레벨입니다.
  minZoom?: number;
  // 지도에 보이는 최대 줌 레벨입니다.
  maxZoom?: number;
  // 최소 줌 레벨이 포함될 때도 보이는 지 여부입니다.
  isMinZoomInclusive?: boolean;
  // 최대 줌 레벨이 포함될 때도 보이는 지 여부입니다.
  isMaxZoomInclusive?: boolean;
  /**
   *  오버레이를 클릭했을 때의 이벤트입니다.
   *  @group Events
   */
  onTap?: () => void;
}
