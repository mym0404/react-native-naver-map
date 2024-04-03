import * as React from 'react';
import { useRef, useState } from 'react';

import { View, Button, Switch, Text } from 'react-native';
import NaverMapView, {
  Commands,
  type MapType,
  MapTypes,
} from '@mj-studio/react-native-naver-map';
import Slider from '@react-native-community/slider';

export default function App() {
  const ref = useRef<any>(null);

  const [nightMode, setNightMode] = useState(false);
  const [indoor, setIndoor] = useState(false);
  const [mapType, setMapType] = useState<MapType>(MapTypes[0]!);
  const [symbolScale, setSymbolScale] = useState(1);
  const [lightness, setLightness] = useState(0);

  return (
    <View style={{ flex: 1 }}>
      <NaverMapView
        ref={ref}
        style={{ flex: 1 }}
        mapType={mapType}
        isIndoorEnabled={indoor}
        onInitialized={() => {
          console.log('initialized!');
        }}
        onOptionChanged={() => {
          console.log('Option Changed!');
        }}
        symbolScale={symbolScale}
        lightness={lightness}
        isNightModeEnabled={nightMode}
        center={{
          latitude: 39,
          longitude: 129,
          zoom: 1,
        }}
      />
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
          title={'MapType'}
          onPress={() =>
            setMapType(
              MapTypes[
                (MapTypes.findIndex((v) => v === mapType) + 1) % MapTypes.length
              ]!
            )
          }
        />
        <Button title={'Indoor'} onPress={() => setIndoor((v) => !v)} />
        <Button
          title={'Seoul Station'}
          onPress={() => {
            Commands.animateCameraTo(
              ref.current!,
              37.5559,
              126.9723,
              3000,
              0,
              0.5,
              0.5
            );
          }}
        />
        <Button
          title={'Move (10, 10) dp or pt'}
          onPress={() => {
            Commands.animateCameraBy(ref.current!, 10, 10, 500, 0, 0.5, 0.5);
          }}
        />

        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Text>Night Mode</Text>
          <Switch value={nightMode} onValueChange={setNightMode} />
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Text>Symbol</Text>
          <Slider
            style={{ width: 100, height: 32 }}
            minimumValue={0}
            maximumValue={1}
            minimumTrackTintColor={'#222222'}
            maximumTrackTintColor={'#000000'}
            onValueChange={setSymbolScale}
            value={symbolScale}
          />
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Text>Lightness</Text>
          <Slider
            style={{ width: 100, height: 32 }}
            minimumValue={-1}
            maximumValue={1}
            minimumTrackTintColor={'#222222'}
            maximumTrackTintColor={'#000000'}
            onValueChange={setLightness}
            value={lightness}
          />
        </View>
      </View>
    </View>
  );
}
