import * as React from 'react';
import { useRef, useState, useEffect } from 'react';

import { View, Button, Switch, Text } from 'react-native';
import {
  type MapType,
  MapTypes,
  NaverMapView,
  type NaverMapViewRef,
  type Region,
  type Camera,
  NaverMapMarker,
} from '@mj-studio/react-native-naver-map';
import Slider from '@react-native-community/slider';
import { request, PERMISSIONS } from 'react-native-permissions';
import { formatJson } from '@mj-studio/js-util';

const jejuRegion: Region = {
  latitude: 33.20530773,
  longitude: 126.14656715029,
  latitudeDelta: 0.38,
  longitudeDelta: 0.8,
};
const jejuCamera: Partial<Camera> = {
  latitude: jejuRegion.latitude + jejuRegion.latitudeDelta / 2,
  longitude: jejuRegion.longitude + jejuRegion.longitudeDelta / 2,
  zoom: 8.5,
};

export default function App() {
  const ref = useRef<NaverMapViewRef>(null);

  const [nightMode, setNightMode] = useState(false);
  const [indoor, setIndoor] = useState(false);
  const [mapType, setMapType] = useState<MapType>(MapTypes[0]!);
  const [symbolScale, setSymbolScale] = useState(1);
  const [lightness, setLightness] = useState(0);
  const [compass, setCompass] = useState(true);
  const [scaleBar, setScaleBar] = useState(true);
  const [zoomControls, setZoomControls] = useState(true);
  const [indoorLevelPicker, setIndoorLevelPicker] = useState(true);
  const [myLocation, setMyLocation] = useState(true);

  useEffect(() => {
    request(PERMISSIONS.IOS.LOCATION_ALWAYS);
  }, []);

  return (
    <View style={{ flex: 1 }}>
      <NaverMapView
        ref={ref}
        style={{ flex: 1 }}
        mapType={mapType}
        // camera={jejuCamera}
        initialCamera={jejuCamera}
        // region={jejuRegion}
        // initialRegion={jejuRegion}
        isIndoorEnabled={indoor}
        symbolScale={symbolScale}
        lightness={lightness}
        isNightModeEnabled={nightMode}
        isShowCompass={compass}
        isShowIndoorLevelPicker={indoorLevelPicker}
        isShowScaleBar={scaleBar}
        isShowZoomControls={zoomControls}
        isShowLocationButton={myLocation}
        isExtentBoundedInKorea
        logoAlign={'TopRight'}
        // onInitialized={() => console.log('initialized!')}
        // onOptionChanged={() => console.log('Option Changed!')}
        // onCameraChanged={(args) =>
        //   console.log(`Camera Changed: ${formatJson(args)}`)
        // }
        onTapMap={(args) => console.log(`Map Tapped: ${formatJson(args)}`)}
      >
        <NaverMapMarker
          latitude={33.1165607356}
          longitude={126.26599018}
          onTap={() => console.log(1)}
          image={'red'}
        />
      </NaverMapView>

      <View
        style={{
          flexDirection: 'row',
          flexWrap: 'wrap',
          alignItems: 'stretch',
          paddingVertical: 24,
          paddingHorizontal: 20,
          gap: 12,
        }}
      >
        <Button
          title={`Type(${mapType})`}
          onPress={() =>
            setMapType(
              MapTypes[
                (MapTypes.findIndex((v) => v === mapType) + 1) % MapTypes.length
              ]!
            )
          }
        />
        <Button
          title={'Move to'}
          onPress={() => {
            ref.current?.animateCameraTo({
              latitude: 33.3932536781,
              longitude: 126.55746544,
            });
          }}
        />
        <Button
          title={'Move by'}
          onPress={() => {
            ref.current?.animateCameraBy({
              x: 100,
              y: 100,
            });
          }}
        />
        <Button
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
        <Button
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

        <Toggle value={nightMode} onChange={setNightMode} text={'Night'} />
        <Toggle value={indoor} onChange={setIndoor} text={'Indoor'} />
        <Toggle value={compass} onChange={setCompass} text={'Compass'} />
        <Toggle value={scaleBar} onChange={setScaleBar} text={'Scale Bar'} />
        <Toggle
          value={myLocation}
          onChange={setMyLocation}
          text={'Location Button'}
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
          min={0}
          max={1}
          value={symbolScale}
          onChange={setSymbolScale}
          text={'Symbol Scale'}
        />
        <Range
          min={-1}
          max={1}
          value={lightness}
          onChange={setLightness}
          text={'Lightness'}
        />
      </View>
    </View>
  );
}

const Toggle = ({
  onChange,
  text,
  value,
}: {
  value: boolean;
  onChange: (value: boolean) => void;
  text: string;
}) => {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
      <Text>{text}</Text>
      <Switch value={value} onValueChange={onChange} />
    </View>
  );
};

const Range = ({
  onChange,
  text,
  value,
  max,
  min,
}: {
  value: number;
  onChange: (value: number) => void;
  text: string;
  min?: number;
  max?: number;
}) => {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
      <Text>{text}</Text>
      <Slider
        style={{ width: 100, height: 32 }}
        minimumValue={min}
        maximumValue={max}
        minimumTrackTintColor={'#222222'}
        maximumTrackTintColor={'#000000'}
        onValueChange={onChange}
        value={value}
      />
    </View>
  );
};
