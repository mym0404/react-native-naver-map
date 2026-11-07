import { useEffect, useRef } from 'react';
import { useInfoWindowControls } from '../internal/useInfoWindowControls';
import NaverMapUtil from '../spec/NativeRNCNaverMapUtil';
import type { Point } from '../types/Point';

export type InfoWindowContent = {
  text: string;
  anchor?: Point;
  offset?: Point;
  alpha?: number;
};

/**
 * Hook for managing InfoWindow instances on Naver Map.
 * Provides methods to show InfoWindow on map or marker.
 *
 * @param content - Content to display in InfoWindow
 * @returns Object with methods to control InfoWindow
 *
 * @example
 * ```tsx
 * const infoWindow = useInfoWindow({
 *   text: "Location Name"
 * });
 *
 * // Show on map at specific position
 * infoWindow.showOnMap({
 *   mapRef: mapRef,
 *   position: { latitude: 37.5665, longitude: 126.9780 }
 * });
 *
 * // Show on marker
 * infoWindow.showOnMarker({ markerRef });
 * ```
 */
export const useInfoWindow = (content: InfoWindowContent) => {
  const id = useRef(`info_window_${Date.now()}_${Math.random()}`).current;

  useEffect(() => {
    // Create InfoWindow instance on mount
    NaverMapUtil.createInfoWindow(id);
    NaverMapUtil.setInfoWindowContent(id, content.text);

    // Cleanup on unmount
    return () => {
      NaverMapUtil.destroyInfoWindow(id);
    };
  }, [id]);

  useEffect(() => {
    // Update content when it changes
    NaverMapUtil.setInfoWindowContent(id, content.text);
  }, [content.text, id]);

  useEffect(() => {
    NaverMapUtil.setInfoWindowOptions(
      id,
      content.anchor?.x ?? 0.5,
      content.anchor?.y ?? 1,
      content.offset?.x ?? 0,
      content.offset?.y ?? 0,
      content.alpha ?? 1
    );
  }, [
    content.anchor?.x,
    content.anchor?.y,
    content.offset?.x,
    content.offset?.y,
    content.alpha,
    id,
  ]);

  return useInfoWindowControls({ id, callerName: 'useInfoWindow' });
};
