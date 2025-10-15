import React, { useState } from 'react';
import { Text } from 'react-native';
import { Btn, Toggle } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const LocationOverlayScreen = ({ onBack }: { onBack: () => void }) => {
  const [showLocationOverlay, setShowLocationOverlay] = useState(true);
  const [locationOverlayBearing, setLocationOverlayBearing] = useState(0);

  return (
    <>
      <Header title={'Location Overlay'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
          locationOverlay: showLocationOverlay
            ? {
                isVisible: true,
                position: {
                  latitude: Cameras.Jeju.latitude + 0.02,
                  longitude: Cameras.Jeju.longitude + 0.02,
                },
                bearing: locationOverlayBearing,
                image: require('../logo180.png'),
                anchor: { x: 0.5, y: 0.5 },
                subImage: { symbol: 'green' },
                subImageWidth: 72,
                subImageHeight: 72,
                subAnchor: { x: 1, y: 0.5 },
                circleRadius: 100,
                circleColor: '#4285F433',
                circleOutlineWidth: 4,
                circleOutlineColor: '#4285F4AA',
              }
            : { isVisible: false },
        }}
        controls={
          <>
            <Toggle
              value={showLocationOverlay}
              onChange={setShowLocationOverlay}
              text={'Show Location Overlay'}
            />
            {showLocationOverlay && (
              <>
                <Btn
                  title={'Rotate +45°'}
                  onPress={() =>
                    setLocationOverlayBearing((prev) => (prev + 45) % 360)
                  }
                />
                <Btn
                  title={'Rotate -45°'}
                  onPress={() =>
                    setLocationOverlayBearing((prev) => (prev - 45 + 360) % 360)
                  }
                />
                <Text style={{ color: 'white', fontSize: 12 }}>
                  Bearing: {locationOverlayBearing}°
                </Text>
              </>
            )}
          </>
        }
      />
    </>
  );
};
