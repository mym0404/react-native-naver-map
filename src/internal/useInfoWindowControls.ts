import type { RefObject } from 'react';
import type { NaverMapMarkerOverlayRef } from '../component/NaverMapMarkerOverlay';
import type { NaverMapViewRef } from '../component/NaverMapView';
import NaverMapUtil from '../spec/NativeRNCNaverMapUtil';
import type { Align } from '../types/Align';
import type { Coord } from '../types/Coord';
import { useStableCallback } from './util/useStableCallback';

export const useInfoWindowControls = ({
  id,
  callerName,
}: {
  id: string;
  callerName: string;
}) => {
  const showOnMap = useStableCallback(
    ({
      mapRef,
      position,
    }: {
      mapRef: RefObject<NaverMapViewRef | null>;
      position: Coord;
    }) => {
      if (!mapRef.current) {
        console.warn(`${callerName}: mapRef.current is null`);
        return false;
      }

      mapRef.current.showInfoWindow(id, position);
      return true;
    }
  );

  const showOnMarker = useStableCallback(
    ({
      markerRef,
      alignType,
    }: {
      markerRef: RefObject<NaverMapMarkerOverlayRef | null>;
      alignType?: Align;
    }) => {
      if (!markerRef.current) {
        console.warn(`${callerName}: markerRef.current is null`);
        return false;
      }

      markerRef.current.showInfoWindow(id, alignType);
      return true;
    }
  );

  const close = useStableCallback(() => {
    NaverMapUtil.closeInfoWindow(id);
  });

  return {
    showOnMap,
    showOnMarker,
    close,
  };
};
