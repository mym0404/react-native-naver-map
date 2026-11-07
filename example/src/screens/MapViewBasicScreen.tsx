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

export const MapViewBasicScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const [isInitialized, setIsInitialized] = useState(false);
  const [camera, setCamera] = useState(waiting);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Map View Basics" onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          initialCamera,
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
