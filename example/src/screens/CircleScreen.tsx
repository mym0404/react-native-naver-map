import { NaverMapCircleOverlay } from '@mj-studio/react-native-naver-map';
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

export const CircleScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title={'Circle Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapCircleOverlay
          latitude={33.17827398}
          longitude={126.349895729}
          radius={10000}
          color={'#ff00ff88'}
          outlineColor={'#aaa'}
          outlineWidth={2}
          globalZIndex={0}
          onTap={() => console.log('Circle tapped')}
        />
      </ScreenLayout>
    </SafeAreaView>
  );
};
