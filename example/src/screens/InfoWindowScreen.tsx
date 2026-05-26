import {
  NaverMapMarkerOverlay,
  type NaverMapMarkerOverlayRef,
  type NaverMapViewRef,
  useInfoWindow,
} from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Button, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
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

type InfoWindowTarget = 'none' | 'marker' | 'map';

export const InfoWindowScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const markerRef = useRef<NaverMapMarkerOverlayRef>(null);
  const [revision, setRevision] = useState(1);
  const [activeTarget, setActiveTarget] = useState<InfoWindowTarget>('none');

  const markerInfoWindow = useInfoWindow({
    title: `서울역 ${revision}`,
    subtitle: '마커 위에 열린 기본 텍스트 정보 창',
  });

  const mapInfoWindow = useInfoWindow({
    title: `한강대교 ${revision}`,
    subtitle: '지도 좌표에 열린 기본 텍스트 정보 창',
  });

  const showMarkerInfoWindow = () => {
    const didShow = markerInfoWindow.showOnMarker({ markerRef });
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

  return (
    <SafeAreaView
      style={styles.container}
      testID="info-window-screen"
      accessibilityLabel="info-window-screen"
    >
      <Header title={'InfoWindow Example'} onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          camera,
        }}
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

      <View style={styles.controlPanel}>
        <Text style={styles.title}>InfoWindow controls</Text>
        <View style={styles.buttonRow}>
          <Button
            title="마커 열기"
            onPress={showMarkerInfoWindow}
            testID="info-window-marker-button"
            accessibilityLabel="info-window-marker-button"
          />
          <Button
            title="지도 열기"
            onPress={showMapInfoWindow}
            testID="info-window-map-button"
            accessibilityLabel="info-window-map-button"
          />
        </View>
        <View style={styles.buttonRow}>
          <Button
            title="내용 갱신"
            onPress={updateOpenInfoWindow}
            testID="info-window-update-button"
            accessibilityLabel="info-window-update-button"
          />
          <Button
            title="모두 닫기"
            onPress={closeAllInfoWindows}
            testID="info-window-close-button"
            accessibilityLabel="info-window-close-button"
          />
        </View>
        <View style={styles.statusContainer}>
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
        </View>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  controlPanel: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'white',
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: '#e0e0e0',
  },
  title: {
    fontSize: 15,
    fontWeight: '600',
    color: '#111',
    marginBottom: 10,
    textAlign: 'center',
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 10,
  },
  statusContainer: {
    backgroundColor: '#f5f5f5',
    padding: 10,
    borderRadius: 8,
  },
  statusText: {
    fontSize: 12,
    color: '#333',
    marginBottom: 3,
  },
});
