import type { NaverMapViewRef } from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const initialCamera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };
const destination = { latitude: 37.49804, longitude: 127.02758 };
const waiting = 'waiting';
const projectionCoordinates = [
  initialCamera,
  { latitude: 37.5675, longitude: 126.979 },
  { latitude: 37.5655, longitude: 126.977 },
];

export const MapViewBasicScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const [isInitialized, setIsInitialized] = useState(false);
  const [camera, setCamera] = useState(waiting);
  const [mapSize, setMapSize] = useState({ width: 0, height: 0 });
  const [longTap, setLongTap] = useState(waiting);
  const [projection, setProjection] = useState(waiting);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Map View Basics" onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          initialCamera,
          testID: 'map-view-basic-map',
          onLayout: ({ nativeEvent: { layout } }) =>
            setMapSize({ width: layout.width, height: layout.height }),
          onLongTapMap: ({ latitude, longitude, x, y }) =>
            setLongTap(
              `${latitude},${longitude},${x},${y},${mapSize.width},${mapSize.height}`
            ),
          onInitialized: () => setIsInitialized(true),
          onCameraIdle: ({ latitude, longitude }) =>
            setCamera(`${latitude.toFixed(4)},${longitude.toFixed(4)}`),
        }}
        controls={
          <>
            <Text testID="map-view-basic-initialized" style={{ color: '#fff' }}>
              {isInitialized ? 'initialized' : waiting}
            </Text>
            <Text testID="map-view-basic-camera" style={{ color: '#fff' }}>
              {camera}
            </Text>
            <Text
              testID="map-view-basic-long-tap"
              numberOfLines={1}
              style={{ color: '#fff', width: '100%', height: 20 }}
            >
              {longTap}
            </Text>
            <Text
              testID="map-view-basic-projection"
              numberOfLines={1}
              style={{ color: '#fff', width: '100%', height: 20 }}
            >
              {projection}
            </Text>
            <Btn
              title="Check coordinate conversion"
              onPress={async () => {
                const map = mapRef.current;
                if (!map) return;
                const results: string[] = [];
                for (const coordinate of projectionCoordinates) {
                  const screen = await map.coordinateToScreen(coordinate);
                  const result = await map.screenToCoordinate(screen);
                  results.push(
                    `${coordinate.latitude},${coordinate.longitude},${screen.isValid},${result.isValid},${result.latitude},${result.longitude}`
                  );
                }
                setProjection(results.join(';'));
              }}
            />
            <Btn
              title="Move to Gangnam"
              onPress={() =>
                mapRef.current?.animateCameraTo({ ...destination, duration: 0 })
              }
            />
          </>
        }
      />
    </SafeAreaView>
  );
};
