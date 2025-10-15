import { formatJson } from '@mj-studio/js-util';
import { NaverMapMarkerOverlay } from '@mj-studio/react-native-naver-map';
import React, { useState, useTransition } from 'react';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';
import { type City, getCitiesByRegion } from '../db/CityDatabase';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const CitiesScreen = ({ onBack }: { onBack: () => void }) => {
  const [cities, setCities] = useState<City[]>([]);
  const [, startTransition] = useTransition();

  return (
    <>
      <Header title={'Cities (Performance Test)'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
          onCameraChanged: ({ region }) => {
            console.log(
              `Camera: ${formatJson({ latitude: region.latitude, longitude: region.longitude })}`
            );

            startTransition(() => {
              const newCities = getCitiesByRegion(region);
              setCities(newCities);
            });
          },
          onCameraIdle: () => {
            console.log('Camera idle');
          },
        }}
      >
        {cities.map((city, i) => (
          <NaverMapMarkerOverlay
            key={`${city.region}-${city.lat}-${i}`}
            latitude={city.lat}
            longitude={city.lng}
            alpha={0.2}
            image={require('../logo180.png')}
            width={1}
            height={1}
          />
        ))}
      </ScreenLayout>
    </>
  );
};
