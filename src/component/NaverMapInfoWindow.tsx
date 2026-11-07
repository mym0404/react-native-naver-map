import React, {
  Children,
  cloneElement,
  forwardRef,
  type ReactElement,
  useCallback,
  useId,
  useImperativeHandle,
  useLayoutEffect,
  useRef,
} from 'react';
import type { ViewProps } from 'react-native';
import type { InfoWindowContent, useInfoWindow } from '../hooks/useInfoWindow';
import { useInfoWindowControls } from '../internal/useInfoWindowControls';
import NativeNaverMapInfoWindow, {
  Commands,
} from '../spec/RNCNaverMapInfoWindowNativeComponent';

export type NaverMapInfoWindowProps = Pick<
  InfoWindowContent,
  'anchor' | 'offset' | 'alpha'
> & {
  children: ReactElement<ViewProps>;
};

export type NaverMapInfoWindowRef = ReturnType<typeof useInfoWindow> & {
  /** Redraws the native InfoWindow after state inside the child changes. */
  invalidate: () => void;
};

/**
 * Displays a React view as a native Naver Map InfoWindow.
 *
 * Mount this component directly under `NaverMapView`. Its single child must
 * have explicit non-zero dimensions and own its entire visual background.
 * Changes to the child element redraw automatically. After child-local state
 * or an asynchronous image changes, call `invalidate()` after that commit.
 * The child is rasterized and is not exposed as a live accessibility element.
 */
export const NaverMapInfoWindow = forwardRef<
  NaverMapInfoWindowRef,
  NaverMapInfoWindowProps
>(({ anchor, offset, alpha, children }, ref) => {
  const reactId = useId();
  const infoWindowId = `custom_info_window_${reactId}`;
  const nativeRef =
    useRef<React.ElementRef<typeof NativeNaverMapInfoWindow>>(null);
  const child = Children.only(children);
  const { showOnMap, showOnMarker, close } = useInfoWindowControls({
    id: infoWindowId,
    callerName: 'NaverMapInfoWindow',
  });

  const invalidate = useCallback(() => {
    if (nativeRef.current) Commands.invalidateContent(nativeRef.current);
  }, []);

  useLayoutEffect(() => {
    invalidate();
  }, [child, invalidate]);

  useImperativeHandle(
    ref,
    () => ({ showOnMap, showOnMarker, close, invalidate }),
    [showOnMap, showOnMarker, close, invalidate]
  );

  return (
    <NativeNaverMapInfoWindow
      ref={nativeRef}
      infoWindowId={infoWindowId}
      anchorX={anchor?.x ?? 0.5}
      anchorY={anchor?.y ?? 1}
      offsetX={offset?.x ?? 0}
      offsetY={offset?.y ?? 0}
      alpha={alpha ?? 1}
      style={{ width: 0, height: 0 }}
      accessibilityElementsHidden
      importantForAccessibility="no-hide-descendants"
    >
      {cloneElement(child, { collapsable: false })}
    </NativeNaverMapInfoWindow>
  );
});
