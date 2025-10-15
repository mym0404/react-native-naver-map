import {
  type Camera,
  type NaverMapViewRef,
} from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Seolleung: {
    latitude: 37.50497126,
    longitude: 127.04905021,
    zoom: 14,
  },
  Gangnam: {
    latitude: 37.498040483,
    longitude: 127.02758183,
    zoom: 14,
  },
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
} satisfies Record<string, Camera>;

export const CameraScreen = ({ onBack }: { onBack: () => void }) => {
  const ref = useRef<NaverMapViewRef>(null);
  const [camera, setCamera] = useState(Cameras.Jeju);

  return (
    <>
      <Header title={'Camera Controls'} onBack={onBack} />
      <ScreenLayout
        mapRef={ref}
        mapProps={{
          camera,
        }}
        controls={
          <>
            <Btn
              title={'Update Camera'}
              onPress={() => {
                setCamera(Cameras.Gangnam);
              }}
            />
            <Btn
              title={'Move to Jeju'}
              onPress={() => {
                ref.current?.animateCameraTo(Cameras.Jeju);
              }}
            />
            <Btn
              title={'Move by 100,100'}
              onPress={() => {
                ref.current?.animateCameraBy({
                  x: 100,
                  y: 100,
                });
              }}
            />
            <Btn
              title={'Move Two Coord'}
              onPress={() => {
                ref.current?.animateCameraWithTwoCoords({
                  coord1: {
                    latitude: 33.56082727271,
                    longitude: 126.170697865,
                  },
                  coord2: {
                    latitude: 33.2439870024,
                    longitude: 126.9221848004,
                  },
                });
              }}
            />
            <Btn
              title={'Move Region'}
              onPress={() => {
                ref.current?.animateRegionTo({
                  latitude: 33.20530773,
                  longitude: 126.14656715029,
                  latitudeDelta: 0.38,
                  longitudeDelta: 0.8,
                });
              }}
            />
            <Btn
              title={'Cancel'}
              onPress={() => {
                ref.current?.cancelAnimation();
              }}
            />
            <Btn
              title={'Face'}
              onPress={() => {
                ref.current?.setLocationTrackingMode('Face');
              }}
            />
            <Btn
              title={'Follow'}
              onPress={() => {
                ref.current?.setLocationTrackingMode('Follow');
              }}
            />
            <Btn
              title={'NoFollow'}
              onPress={() => {
                ref.current?.setLocationTrackingMode('NoFollow');
              }}
            />
            <Btn
              title={'None'}
              onPress={() => {
                ref.current?.setLocationTrackingMode('None');
              }}
            />
            <Btn
              title={'Screen -> Coord'}
              onPress={() => {
                ref.current
                  ?.screenToCoordinate({ screenX: 0, screenY: 0 })
                  .then(console.log);
              }}
            />
            <Btn
              title={'Coord -> Screen'}
              onPress={() => {
                ref.current
                  ?.coordinateToScreen({ ...Cameras.Jeju })
                  .then(console.log);
              }}
            />
          </>
        }
      />
    </>
  );
};
