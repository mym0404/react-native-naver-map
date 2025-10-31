import { NaverMapMarkerOverlay } from '@mj-studio/react-native-naver-map';
import React from 'react';
import { Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const MarkerScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title={'Marker Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        <NaverMapMarkerOverlay
          latitude={30.4165607356}
          longitude={123.48599018}
          onTap={() => console.log('Custom view marker tapped')}
          anchor={{ x: 0.5, y: 1 }}
          width={100}
          height={100}
        >
          <View
            style={{
              width: 100,
              height: 100,
              backgroundColor: 'red',
              alignItems: 'center',
              justifyContent: 'center',
            }}
            collapsable={false}
          >
            <Text style={{ color: 'white', fontWeight: 'bold' }}>Custom</Text>
          </View>
        </NaverMapMarkerOverlay>
        <NaverMapMarkerOverlay
          latitude={31.1565607356}
          longitude={123.88599018}
          onTap={() => console.log('Require image marker tapped')}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: 'Require Image',
          }}
          subCaption={{
            text: 'caption',
          }}
          image={require('../logo180.png')}
        />
        <NaverMapMarkerOverlay
          latitude={30.0565607356}
          longitude={123.88599018}
          onTap={() => console.log('Asset marker tapped')}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: 'Asset Name',
          }}
          subCaption={{
            text: 'thumbnail',
          }}
          width={100}
          height={50}
          image={{ assetName: 'thumbnail' }}
        />
        <NaverMapMarkerOverlay
          latitude={30.2565607356}
          longitude={123.8599018}
          onTap={() => console.log('HTTP image marker tapped')}
          anchor={{ x: 0.5, y: 1 }}
          width={100}
          height={100}
          image={{ httpUri: 'https://picsum.photos/1000/1201' }}
        />
      </ScreenLayout>
    </SafeAreaView>
  );
};
