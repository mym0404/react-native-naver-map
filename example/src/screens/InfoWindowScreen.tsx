import {
  type Align,
  NaverMapMarkerOverlay,
  type NaverMapMarkerOverlayRef,
  type NaverMapViewRef,
  useInfoWindow,
} from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { StyleSheet, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Btn, Range } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const camera = {
  latitude: 37.559,
  longitude: 126.982,
  zoom: 12,
};

const mapInfoWindowPosition = {
  latitude: 37.5219,
  longitude: 126.9918,
};

const alignTypes = [
  undefined,
  'Center',
  'Left',
  'Right',
  'Top',
  'Bottom',
  'TopLeft',
  'TopRight',
  'BottomRight',
  'BottomLeft',
] satisfies (Align | undefined)[];

type InfoWindowTarget = 'none' | 'marker' | 'map';

export const InfoWindowScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const markerRef = useRef<NaverMapMarkerOverlayRef>(null);
  const [revision, setRevision] = useState(1);
  const [activeTarget, setActiveTarget] = useState<InfoWindowTarget>('none');
  const [alignTypeIndex, setAlignTypeIndex] = useState(0);
  const [anchorX, setAnchorX] = useState(0.5);
  const [anchorY, setAnchorY] = useState(1);
  const [offsetX, setOffsetX] = useState(0);
  const [offsetY, setOffsetY] = useState(0);
  const [alpha, setAlpha] = useState(1);

  const alignType = alignTypes[alignTypeIndex];

  const markerInfoWindow = useInfoWindow({
    text: `서울역 ${revision}`,
    anchor: { x: anchorX, y: anchorY },
    offset: { x: offsetX, y: offsetY },
    alpha,
  });

  const mapInfoWindow = useInfoWindow({
    text: `한강대교 ${revision}`,
    anchor: { x: anchorX, y: anchorY },
    offset: { x: offsetX, y: offsetY },
    alpha,
  });

  const showMarkerInfoWindow = () => {
    const didShow = markerInfoWindow.showOnMarker({
      markerRef,
      alignType,
    });
    if (!didShow) return;

    mapInfoWindow.close();
    setActiveTarget('marker');
  };

  const showMapInfoWindow = () => {
    const didShow = mapInfoWindow.showOnMap({
      mapRef,
      position: mapInfoWindowPosition,
    });
    if (!didShow) return;

    markerInfoWindow.close();
    setActiveTarget('map');
  };

  const updateOpenInfoWindow = () => {
    setRevision((value) => value + 1);
  };

  const closeAllInfoWindows = () => {
    markerInfoWindow.close();
    mapInfoWindow.close();
    setActiveTarget('none');
  };

  const changeAlignType = () => {
    setAlignTypeIndex((value) => {
      const nextIndex = (value + 1) % alignTypes.length;
      const nextAlignType = alignTypes[nextIndex];

      if (activeTarget === 'marker') {
        markerInfoWindow.showOnMarker({
          markerRef,
          alignType: nextAlignType,
        });
      }

      return nextIndex;
    });
  };

  return (
    <SafeAreaView
      style={styles.container}
      testID="info-window-screen"
      accessibilityLabel="info-window-screen"
    >
      <Header title={'Info Window'} onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          camera,
        }}
        controls={
          <>
            <Btn title="마커 열기" onPress={showMarkerInfoWindow} />
            <Btn title="지도 열기" onPress={showMapInfoWindow} />
            <Btn title="내용 갱신" onPress={updateOpenInfoWindow} />
            <Btn title="모두 닫기" onPress={closeAllInfoWindows} />
            <Btn
              title={`정렬: ${alignType ?? '기본값'}`}
              onPress={changeAlignType}
            />
            <Range
              min={0}
              max={1}
              value={anchorX}
              onChange={setAnchorX}
              text={`Anchor X ${anchorX.toFixed(2)}`}
            />
            <Range
              min={0}
              max={1}
              value={anchorY}
              onChange={setAnchorY}
              text={`Anchor Y ${anchorY.toFixed(2)}`}
            />
            <Range
              min={-40}
              max={40}
              value={offsetX}
              onChange={setOffsetX}
              text={`Offset X ${Math.round(offsetX)}`}
            />
            <Range
              min={-40}
              max={40}
              value={offsetY}
              onChange={setOffsetY}
              text={`Offset Y ${Math.round(offsetY)}`}
            />
            <Range
              min={0}
              max={1}
              value={alpha}
              onChange={setAlpha}
              text={`Alpha ${alpha.toFixed(2)}`}
            />
            <Text
              style={styles.statusText}
              testID="info-window-selected-status"
              accessibilityLabel={`info-window-selected-status-${activeTarget}`}
            >
              선택: {activeTarget}
            </Text>
            <Text
              style={styles.statusText}
              testID="info-window-marker-status"
              accessibilityLabel={`info-window-marker-status-${
                activeTarget === 'marker' ? 'open' : 'closed'
              }`}
            >
              마커: {activeTarget === 'marker' ? '열림' : '닫힘'}
            </Text>
            <Text
              style={styles.statusText}
              testID="info-window-map-status"
              accessibilityLabel={`info-window-map-status-${
                activeTarget === 'map' ? 'open' : 'closed'
              }`}
            >
              지도: {activeTarget === 'map' ? '열림' : '닫힘'}
            </Text>
            <Text
              style={styles.statusText}
              testID="info-window-revision-status"
              accessibilityLabel={`info-window-revision-status-${revision}`}
            >
              내용 버전: {revision}
            </Text>
          </>
        }
      >
        <NaverMapMarkerOverlay
          ref={markerRef}
          latitude={37.5547}
          longitude={126.9707}
          onTap={showMarkerInfoWindow}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: '서울역',
            textSize: 14,
            color: activeTarget === 'marker' ? '#1A5CFF' : '#111111',
          }}
          image={{ symbol: activeTarget === 'marker' ? 'blue' : 'green' }}
        />
      </ScreenLayout>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  statusText: {
    fontSize: 10,
    fontWeight: 'bold',
    color: '#bbb',
    paddingVertical: 4,
    paddingHorizontal: 6,
  },
});
