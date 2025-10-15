import {
  NaverMapMarkerOverlay,
  useInfoWindow,
} from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Button, StyleSheet, Text, View } from 'react-native';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Seoul: {
    latitude: 37.5665,
    longitude: 126.978,
    zoom: 12,
  },
};

export const InfoWindowScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<any>(null);
  const marker1Ref = useRef<any>(null);
  const marker2Ref = useRef<any>(null);
  const marker3Ref = useRef<any>(null);

  const [selectedMarkerId, setSelectedMarkerId] = useState<string | null>(null);

  // 여러 InfoWindow 인스턴스 생성
  const infoWindow1 = useInfoWindow({
    title: '서울역',
    subtitle: '서울특별시 중구 한강대로 405',
  });

  const infoWindow2 = useInfoWindow({
    title: '남산타워',
    subtitle: '서울특별시 용산구 남산공원길 105',
  });

  const infoWindow3 = useInfoWindow({
    title: '경복궁',
    subtitle: '서울특별시 종로구 사직로 161',
  });

  // 맵에 직접 표시할 InfoWindow
  const infoWindowOnMap = useInfoWindow({
    title: '한강대교',
    subtitle: '서울의 중심을 가로지르는 다리',
  });

  const handleMarker1Tap = () => {
    setSelectedMarkerId('marker1');
    infoWindow1.showOnMarker({ markerRef: marker1Ref });
    // 다른 InfoWindow들 닫기
    infoWindow2.close();
    infoWindow3.close();
    infoWindowOnMap.close();
  };

  const handleMarker2Tap = () => {
    setSelectedMarkerId('marker2');
    infoWindow2.showOnMarker({ markerRef: marker2Ref });
    // 다른 InfoWindow들 닫기
    infoWindow1.close();
    infoWindow3.close();
    infoWindowOnMap.close();
  };

  const handleMarker3Tap = () => {
    setSelectedMarkerId('marker3');
    infoWindow3.showOnMarker({ markerRef: marker3Ref });
    // 다른 InfoWindow들 닫기
    infoWindow1.close();
    infoWindow2.close();
    infoWindowOnMap.close();
  };

  const handleShowOnMap = () => {
    if (!mapRef.current) {
      console.warn('Map ref not ready');
      return;
    }

    // 한강대교 위치에 InfoWindow 표시
    infoWindowOnMap.showOnMap({
      mapRef: mapRef,
      position: { latitude: 37.5219, longitude: 126.9918 },
    });

    // 다른 InfoWindow들 닫기
    infoWindow1.close();
    infoWindow2.close();
    infoWindow3.close();
    setSelectedMarkerId(null);
  };

  const handleCloseAll = () => {
    infoWindow1.close();
    infoWindow2.close();
    infoWindow3.close();
    infoWindowOnMap.close();
    setSelectedMarkerId(null);
  };

  return (
    <>
      <Header title={'InfoWindow Example'} onBack={onBack} />
      <ScreenLayout
        mapRef={mapRef}
        mapProps={{
          camera: Cameras.Seoul,
        }}
      >
        {/* 서울역 마커 */}
        <NaverMapMarkerOverlay
          ref={marker1Ref}
          latitude={37.5547}
          longitude={126.9707}
          onTap={handleMarker1Tap}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: '서울역',
            textSize: 14,
            color: selectedMarkerId === 'marker1' ? '#0000FF' : '#000000',
          }}
          image={{ symbol: 'blue' }}
        />

        {/* 남산타워 마커 */}
        <NaverMapMarkerOverlay
          ref={marker2Ref}
          latitude={37.5512}
          longitude={126.9882}
          onTap={handleMarker2Tap}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: '남산타워',
            textSize: 14,
            color: selectedMarkerId === 'marker2' ? '#0000FF' : '#000000',
          }}
          image={{ symbol: 'green' }}
        />

        {/* 경복궁 마커 */}
        <NaverMapMarkerOverlay
          ref={marker3Ref}
          latitude={37.5797}
          longitude={126.977}
          onTap={handleMarker3Tap}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: '경복궁',
            textSize: 14,
            color: selectedMarkerId === 'marker3' ? '#0000FF' : '#000000',
          }}
          image={{ symbol: 'red' }}
        />
      </ScreenLayout>

      {/* 컨트롤 버튼들 */}
      <View style={styles.controlPanel}>
        <Text style={styles.infoText}>
          마커를 탭하여 InfoWindow를 표시합니다
        </Text>

        <View style={styles.buttonContainer}>
          <Button
            title="Map에 InfoWindow 표시"
            onPress={handleShowOnMap}
            color="#4CAF50"
          />
          <Button
            title="모든 InfoWindow 닫기"
            onPress={handleCloseAll}
            color="#FF5722"
          />
        </View>

        <View style={styles.statusContainer}>
          <Text style={styles.statusText}>InfoWindow 상태:</Text>
          <Text style={styles.statusText}>
            서울역: {infoWindow1.isOpen() ? '열림' : '닫힘'}
          </Text>
          <Text style={styles.statusText}>
            남산타워: {infoWindow2.isOpen() ? '열림' : '닫힘'}
          </Text>
          <Text style={styles.statusText}>
            경복궁: {infoWindow3.isOpen() ? '열림' : '닫힘'}
          </Text>
          <Text style={styles.statusText}>
            한강대교 (Map): {infoWindowOnMap.isOpen() ? '열림' : '닫힘'}
          </Text>
        </View>
      </View>
    </>
  );
};

const styles = StyleSheet.create({
  controlPanel: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'white',
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: '#e0e0e0',
  },
  infoText: {
    fontSize: 14,
    color: '#666',
    marginBottom: 12,
    textAlign: 'center',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 12,
  },
  statusContainer: {
    backgroundColor: '#f5f5f5',
    padding: 12,
    borderRadius: 8,
  },
  statusText: {
    fontSize: 12,
    color: '#333',
    marginBottom: 4,
  },
});
