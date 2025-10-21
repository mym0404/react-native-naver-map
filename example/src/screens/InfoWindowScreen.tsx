import {
  NaverMapInfoWindow,
  NaverMapMarkerOverlay,
} from '@mj-studio/react-native-naver-map';
import React from 'react';
import { Platform } from 'react-native';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const InfoWindowScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <>
      <Header title="InfoWindow" onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
        }}
      >
        {/* infoWindow 와 연결된 마커들 */}
        <NaverMapMarkerOverlay
          identifier="jeju-center"
          latitude={33.5}
          longitude={126.5}
          width={40}
          height={40}
          image={{ symbol: 'blue' }}
        />
        <NaverMapMarkerOverlay
          identifier="seongsan"
          latitude={33.4}
          longitude={126.6}
          width={40}
          height={40}
          image={{ symbol: 'red' }}
        />
        <NaverMapMarkerOverlay
          identifier="tourist-spot"
          latitude={33.3}
          longitude={126.4}
          width={35}
          height={35}
          image={{ symbol: 'yellow' }}
        />

        {/* infoWindow 1: 마커와 연결된 infoWindow (font bold 사용) */}
        <NaverMapInfoWindow
          identifier="jeju-center"
          latitude={33.5}
          longitude={126.5}
          text="제주도 중심"
          textSize={12}
          textColor="black"
          fontWeight="bold"
          backgroundColor="white"
          borderRadius={Platform.OS === 'ios' ? 16 : 99}
          paddingHorizontal={10}
          paddingVertical={8}
          alpha={0.95}
        />

        {/* infoWindow 2: 마커와 연결된 infoWindow (borderRadius, backgroundColor 사용) */}
        <NaverMapInfoWindow
          identifier="seongsan"
          latitude={33.4}
          longitude={126.6}
          text="성산일출봉 ➡️"
          textSize={16}
          textColor="white"
          fontWeight="700"
          backgroundColor="#ff6b6b"
          borderRadius={14}
          paddingHorizontal={12}
          paddingVertical={10}
          alpha={1}
          isOpen={true}
        />

        {/* infoWindow 3: 마커와 연결된 infoWindow (all custom styles) */}
        <NaverMapInfoWindow
          identifier="tourist-spot"
          latitude={33.3}
          longitude={126.4}
          text="📍 관광지"
          textSize={12}
          textColor="#333"
          fontWeight="500"
          backgroundColor="#ffd93d"
          borderRadius={8}
          borderWidth={1}
          borderColor="#f39c12"
          paddingHorizontal={8}
          paddingVertical={6}
          alpha={0.9}
        />

        {/* infoWindow 4: 좌표에 독립적으로 표시된 infoWindow */}
        <NaverMapInfoWindow
          latitude={33.6}
          longitude={126.7}
          text="독립 InfoWindow"
          textSize={14}
          textColor="#2d3436"
          backgroundColor="#dfe6e9"
          alpha={0.9}
        />

        {/* infoWindow 5: 처음부터 닫힌 infoWindow */}
        <NaverMapInfoWindow
          latitude={33.2}
          longitude={126.3}
          text="닫힌 InfoWindow"
          textSize={13}
          textColor="white"
          backgroundColor="#6c5ce7"
          isOpen={false}
        />
      </ScreenLayout>
    </>
  );
};
