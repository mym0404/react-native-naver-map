import type { RefObject } from 'react';
import { useEffect, useRef } from 'react';
import type { NaverMapMarkerOverlayRef } from '../component/NaverMapMarkerOverlay';
import type { NaverMapViewRef } from '../component/NaverMapView';
import NaverMapUtil from '../spec/NativeRNCNaverMapUtil';
import type { Coord } from '../types/Coord';

export interface InfoWindowContent {
  title: string;
  subtitle?: string;
}

export interface ShowOnMapParams {
  mapRef: RefObject<NaverMapViewRef>;
  position: Coord;
}

export interface ShowOnMarkerParams {
  markerRef: RefObject<NaverMapMarkerOverlayRef>;
}

export interface UseInfoWindowReturn {
  showOnMap: (params: ShowOnMapParams) => void;
  showOnMarker: (params: ShowOnMarkerParams) => void;
  close: () => void;
  isOpen: () => boolean;
}

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
 *   title: "Location Name",
 *   subtitle: "Location details"
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
export const useInfoWindow = (
  content: InfoWindowContent
): UseInfoWindowReturn => {
  const id = useRef(`info_window_${Date.now()}_${Math.random()}`).current;

  useEffect(() => {
    // Create InfoWindow instance on mount
    NaverMapUtil.createInfoWindow(id);
    NaverMapUtil.setInfoWindowContent(id, content.title, content.subtitle);

    // Cleanup on unmount
    return () => {
      NaverMapUtil.destroyInfoWindow(id);
    };
  }, [id]);

  useEffect(() => {
    // Update content when it changes
    NaverMapUtil.setInfoWindowContent(id, content.title, content.subtitle);
  }, [content.title, content.subtitle, id]);

  return {
    showOnMap: ({ mapRef, position }) => {
      if (!mapRef.current) {
        console.warn('useInfoWindow: mapRef.current is null');
        return;
      }

      mapRef.current.showInfoWindow(id, position);
    },

    showOnMarker: ({ markerRef }) => {
      if (!markerRef.current) {
        console.warn('useInfoWindow: markerRef.current is null');
        return;
      }

      markerRef.current.showInfoWindow(id);
    },

    close: () => {
      NaverMapUtil.closeInfoWindow(id);
    },

    isOpen: () => {
      return NaverMapUtil.isInfoWindowOpen(id);
    },
  };
};
