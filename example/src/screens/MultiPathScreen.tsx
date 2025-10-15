import { NaverMapMultiPathOverlay } from '@mj-studio/react-native-naver-map';
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

export const MultiPathScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <>
      <Header title={'Multi Path Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapMultiPathOverlay
          width={40}
          patternInterval={120}
          progress={0.5}
          outlineWidth={10}
          patternImage={{ symbol: 'blue' }}
          pathParts={[
            {
              coords: [
                { latitude: 33.5744287, longitude: 126.982625 },
                { latitude: 33.57152, longitude: 126.97714 },
                { latitude: 33.56607, longitude: 126.98268 },
              ],
              color: 'orange',
              outlineColor: 'red',
              passedColor: 'blue',
              passedOutlineColor: 'gray',
            },
            {
              coords: [
                { latitude: 33.56607, longitude: 126.98268 },
                { latitude: 33.56445, longitude: 126.97707 },
                { latitude: 33.55855, longitude: 126.97822 },
              ],
              color: 'green',
              passedColor: 'darkgreen',
              outlineColor: 'white',
              passedOutlineColor: 'gray',
            },
            {
              coords: [
                { latitude: 33.55855, longitude: 126.97822 },
                { latitude: 33.55234, longitude: 126.98456 },
                { latitude: 33.54789, longitude: 126.97333 },
              ],
              color: 'blue',
              passedColor: 'darkblue',
              outlineColor: 'white',
              passedOutlineColor: 'gray',
            },
          ]}
          onTap={() => console.log('MultiPath tapped!')}
        />
      </ScreenLayout>
    </>
  );
};
