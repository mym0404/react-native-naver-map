import { type MapType } from '@mj-studio/react-native-naver-map';
import React, { useState } from 'react';
import { Btn, Range, Toggle } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const MapTypes = [
  'Basic',
  'Navi',
  'Satellite',
  'Hybrid',
  'Terrain',
  'NaviHybrid',
  'None',
] satisfies MapType[];

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const CommonScreen = ({ onBack }: { onBack: () => void }) => {
  const [nightMode, setNightMode] = useState(false);
  const [indoor, setIndoor] = useState(false);
  const [mapType, setMapType] = useState<MapType>(MapTypes[0]!);
  const [lightness, setLightness] = useState(0);
  const [compass, setCompass] = useState(true);
  const [scaleBar, setScaleBar] = useState(true);
  const [zoomControls, setZoomControls] = useState(true);
  const [indoorLevelPicker, setIndoorLevelPicker] = useState(true);
  const [myLocation, setMyLocation] = useState(true);
  const [customStyle, setCustomStyle] = useState(false);
  const [rerenderKey, setRerenderKey] = useState(0);

  return (
    <>
      <Header title={'Common Settings'} onBack={onBack} />
      <ScreenLayout
        showMap={rerenderKey % 2 === 0}
        mapProps={{
          camera: Cameras.Jeju,
          mapType,
          layerGroups: {
            BUILDING: true,
            BICYCLE: false,
            CADASTRAL: false,
            MOUNTAIN: false,
            TRAFFIC: false,
            TRANSIT: false,
          },
          isIndoorEnabled: indoor,
          lightness,
          isNightModeEnabled: nightMode,
          isShowCompass: compass,
          isShowIndoorLevelPicker: indoorLevelPicker,
          isShowScaleBar: scaleBar,
          isShowZoomControls: zoomControls,
          isShowLocationButton: myLocation,
          customStyleId: customStyle
            ? 'bf462d9f-fa82-413d-ab7c-df9c5e3c9f7f'
            : undefined,
          onCustomStyleLoaded: () => {
            console.log('Custom style loaded successfully!');
          },
          onCustomStyleLoadFailed: ({ message }) => {
            console.log('Custom style load failed:', message);
          },
        }}
        controls={
          <>
            <Btn
              title={`Type(${mapType})`}
              onPress={() =>
                setMapType(
                  MapTypes[
                    (MapTypes.findIndex((v) => v === mapType) + 1) %
                      MapTypes.length
                  ]!
                )
              }
            />
            <Btn
              title={'Rerender'}
              onPress={() => setRerenderKey((k) => k + 1)}
            />
            <Toggle value={nightMode} onChange={setNightMode} text={'Night'} />
            <Toggle value={indoor} onChange={setIndoor} text={'Indoor'} />
            <Toggle value={compass} onChange={setCompass} text={'Compass'} />
            <Toggle
              value={scaleBar}
              onChange={setScaleBar}
              text={'Scale Bar'}
            />
            <Toggle
              value={myLocation}
              onChange={setMyLocation}
              text={'Location Btn'}
            />
            <Toggle
              value={zoomControls}
              onChange={setZoomControls}
              text={'Zoom Controls'}
            />
            <Toggle
              value={indoorLevelPicker}
              onChange={setIndoorLevelPicker}
              text={'Indoor Level'}
            />
            <Range
              min={-1}
              max={1}
              value={lightness}
              onChange={setLightness}
              text={'Lightness'}
            />
            <Toggle
              value={rerenderKey % 2 === 0}
              onChange={() => setRerenderKey((k) => k + 1)}
              text={'show'}
            />
            <Toggle
              value={customStyle}
              onChange={setCustomStyle}
              text={'Custom Style'}
            />
          </>
        }
      />
    </>
  );
};
