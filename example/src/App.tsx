import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { NaverMapView } from '@mj-studio/react-native-naver-map';

export default function App() {
  return (
    <View style={{ flex: 1 }}>
      <NaverMapView
        style={StyleSheet.absoluteFill}
        onInitialized={() => {
          console.log('initialized!');
        }}
        mapType={'Terrain'}
        buildingHeight={0.5}
        onOptionChanged={() => {
          console.log('Option Changed!');
        }}
        center={{
          latitude: 37.50663442764957,
          longitude: 127.04102406190495,
        }}
      />
    </View>
  );
}
