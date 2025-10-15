import {
  NaverMapGroundOverlay,
  type Region,
} from '@mj-studio/react-native-naver-map';
import React from 'react';
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
    <>
      <Header title={'Ground Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapGroundOverlay
          image={{ assetName: 'thumbnail' }}
          region={Regions.Jeju}
          onTap={() => console.log('Ground overlay tapped')}
        />
      </ScreenLayout>
    </>
  );
};
