import { NaverMapArrowheadPathOverlay } from '@mj-studio/react-native-naver-map';
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

export const ArrowheadPathScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <>
      <Header title={'Arrowhead Path Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapArrowheadPathOverlay
          coords={[
            { longitude: 126.93240597362552, latitude: 32.433509943138404 },
            { longitude: 126.93474226289788, latitude: 32.6383463419792 },
            { longitude: 127.07281803100506, latitude: 32.57085962943823 },
            { longitude: 126.96403036772739, latitude: 32.52862726684933 },
          ]}
          zIndex={0}
          headSizeRatio={2.5}
          width={8}
          color={'red'}
          outlineColor={'blue'}
          outlineWidth={2}
        />
      </ScreenLayout>
    </>
  );
};
