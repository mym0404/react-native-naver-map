import { NaverMapPathOverlay } from '@mj-studio/react-native-naver-map';
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

export const PathScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <>
      <Header title={'Path Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapPathOverlay
          coords={[
            { latitude: 32.345332063, longitude: 126.24180047 },
            { latitude: 32.70066, longitude: 126.2719053 },
            { latitude: 32.360030018, longitude: 126.37221049 },
            { longitude: 126.4661129593128, latitude: 32.671851556552205 },
            { longitude: 126.52469300979067, latitude: 32.38556958856244 },
          ]}
          width={8}
          color={'white'}
          progress={0.5}
          passedColor={'black'}
          outlineWidth={1}
        />
      </ScreenLayout>
    </>
  );
};
