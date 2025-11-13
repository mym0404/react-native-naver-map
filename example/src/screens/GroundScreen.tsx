import {
  NaverMapGroundOverlay,
  type Region,
} from '@mj-studio/react-native-naver-map';
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

const Regions = {
  Jeju: {
    latitude: 33.39530773 + 1,
    longitude: 126.54656715029 - 1,
    latitudeDelta: 0.05,
    longitudeDelta: 0.05,
  },
} satisfies Record<string, Region>;

export const GroundScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title={'Ground Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
          isShowLocationButton: true,
        }}
      >
        <NaverMapGroundOverlay
          image={require('../logo180.png')}
          region={Regions.Jeju}
          onTap={() => console.log('Ground overlay tapped')}
        />
      </ScreenLayout>
    </SafeAreaView>
  );
};
