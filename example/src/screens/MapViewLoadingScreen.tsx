import React, { useState } from 'react';
import { Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const initialCamera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };

export const MapViewLoadingScreen = ({ onBack }: { onBack: () => void }) => {
  const [initializedCount, setInitializedCount] = useState(0);
  const [loadedCount, setLoadedCount] = useState(0);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Map Loading" onBack={onBack} />
      <ScreenLayout
        mapProps={{
          initialCamera,
          onInitialized: () => setInitializedCount((count) => count + 1),
          onMapLoaded: () => setLoadedCount((count) => count + 1),
        }}
        controls={
          <>
            <Text
              testID="map-view-loading-initialized-count"
              style={{ color: '#fff' }}
            >
              {initializedCount}
            </Text>
            <Text
              testID="map-view-loading-loaded-count"
              style={{ color: '#fff' }}
            >
              {loadedCount}
            </Text>
          </>
        }
      />
    </SafeAreaView>
  );
};
