export type BaseOverlayProps = {
  latitude: number;
  longitude: number;
  zIndex?: number;
  isHidden?: boolean;
  minZoom?: number;
  maxZoom?: number;
  isMinZoomInclusive?: boolean;
  isMaxZoomInclusive?: boolean;
  onTap?: () => void;
};
