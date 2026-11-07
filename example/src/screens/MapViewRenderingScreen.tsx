import type { NaverMapViewRef } from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const initialCamera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };
const destination = { latitude: 37.49804, longitude: 127.02758 };
const coordinateTolerance = 0.0001;
const waiting = 'waiting';

export const MapViewRenderingScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const isMoveRequested = useRef(false);
  const hasReachedDestination = useRef(false);
  const [isLoaded, setIsLoaded] = useState(false);
  const [renderingResult, setRenderingResult] = useState(waiting);
  const [destinationRenderingResult, setDestinationRenderingResult] =
    useState(waiting);
  const [camera, setCamera] = useState(waiting);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Map Rendering" onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          initialCamera,
          onMapLoaded: () => setIsLoaded(true),
          onMapRendered: ({ isFullyRendered, isRenderingStable }) => {
            const result = `${isFullyRendered},${isRenderingStable}`;
            setRenderingResult(result);
            if (
              hasReachedDestination.current &&
              isFullyRendered &&
              isRenderingStable
            ) {
              setDestinationRenderingResult(result);
            }
          },
          onCameraChanged: ({ latitude, longitude }) => {
            if (
              isMoveRequested.current &&
              Math.abs(latitude - destination.latitude) < coordinateTolerance &&
              Math.abs(longitude - destination.longitude) < coordinateTolerance
            ) {
              hasReachedDestination.current = true;
            }
          },
          onCameraIdle: ({ latitude, longitude }) =>
            setCamera(`${latitude.toFixed(4)},${longitude.toFixed(4)}`),
        }}
        controls={
          <>
            <Text testID="map-view-rendering-loaded" style={{ color: '#fff' }}>
              {isLoaded ? 'loaded' : waiting}
            </Text>
            <Text testID="map-view-rendering-result" style={{ color: '#fff' }}>
              {renderingResult}
            </Text>
            <Text
              testID="map-view-rendering-destination-result"
              style={{ color: '#fff' }}
            >
              {destinationRenderingResult}
            </Text>
            <Text testID="map-view-rendering-camera" style={{ color: '#fff' }}>
              {camera}
            </Text>
            <Btn
              title="Animate to Gangnam"
              onPress={() => {
                isMoveRequested.current = true;
                hasReachedDestination.current = false;
                setDestinationRenderingResult(waiting);
                mapRef.current?.animateCameraTo({
                  ...destination,
                  duration: 1000,
                });
              }}
            />
          </>
        }
      />
    </SafeAreaView>
  );
};
