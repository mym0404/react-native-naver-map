import type { RefObject } from 'react';
import { useEffect, useRef } from 'react';
import type { NaverMapMarkerOverlayRef } from '../component/NaverMapMarkerOverlay';
import type { NaverMapViewRef } from '../component/NaverMapView';
import NaverMapUtil from '../spec/NativeRNCNaverMapUtil';
import type { Align } from '../types/Align';
import type { Coord } from '../types/Coord';
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

  return {
    showOnMap: ({
      mapRef,
      position,
    }: {
      mapRef: RefObject<NaverMapViewRef | null>;
      position: Coord;
    }) => {
      if (!mapRef.current) {
        console.warn('useInfoWindow: mapRef.current is null');
        return false;
      }

      mapRef.current.showInfoWindow(id, position);
      return true;
    },

    showOnMarker: ({
      markerRef,
      alignType,
    }: {
      markerRef: RefObject<NaverMapMarkerOverlayRef | null>;
      alignType?: Align;
    }) => {
      if (!markerRef.current) {
        console.warn('useInfoWindow: markerRef.current is null');
        return false;
      }

      markerRef.current.showInfoWindow(id, alignType);
      return true;
    },

    close: () => {
      NaverMapUtil.closeInfoWindow(id);
    },
  };
};
