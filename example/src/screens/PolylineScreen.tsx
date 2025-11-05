import { NaverMapPolylineOverlay } from '@mj-studio/react-native-naver-map';
import React from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const PolylineScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title={'Polyline Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapPolylineOverlay
          color={'#00668888'}
          coords={[
            { latitude: 33.2249594, longitude: 126.54180047 },
            { latitude: 33.25683311547, longitude: 126.18193 },
            { latitude: 33.3332807, longitude: 126.838389399 },
          ]}
        />
      </ScreenLayout>
    </SafeAreaView>
  );
};
