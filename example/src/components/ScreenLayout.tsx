import {
  NaverMapView,
  type NaverMapViewProps,
} from '@mj-studio/react-native-naver-map';
import React, { type ReactNode } from 'react';
import { View } from 'react-native';

export const ScreenLayout = ({
  mapProps,
  controls,
  children,
  showMap = true,
}: {
  mapProps: NaverMapViewProps;
  controls?: ReactNode;
  children?: ReactNode;
  showMap?: boolean;
}) => {
  return (
    <View style={{ flex: 1 }}>
      {showMap ? (
        <NaverMapView {...mapProps} style={{ flex: 1 }}>
          {children}
        </NaverMapView>
      ) : (
        <View style={{ flex: 1, backgroundColor: '#222' }} />
      )}
      {controls && (
        <View
          style={{
            flexDirection: 'row',
            flexWrap: 'wrap',
            alignItems: 'stretch',
            paddingVertical: 20,
            paddingHorizontal: 12,
            gap: 6,
            backgroundColor: '#000',
          }}
        >
          {controls}
        </View>
      )}
    </View>
  );
};
