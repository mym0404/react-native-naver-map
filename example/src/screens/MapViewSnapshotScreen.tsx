import {
  NaverMapCircleOverlay,
  type NaverMapViewRef,
} from '@mj-studio/react-native-naver-map';
import React, { useRef, useState } from 'react';
import { Image, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

type Snapshot = Awaited<ReturnType<NaverMapViewRef['takeSnapshot']>>;
const initialCamera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };
const waiting = 'waiting';

export const MapViewSnapshotScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [isRendered, setIsRendered] = useState(false);
  const [snapshots, setSnapshots] = useState<Snapshot[]>([]);
  const [previewIndex, setPreviewIndex] = useState(0);
  const [decoded, setDecoded] = useState(waiting);
  const [busyResult, setBusyResult] = useState(waiting);
  const [error, setError] = useState('');
  const preview = snapshots[previewIndex];

  const capture = async () => {
    if (!mapRef.current || !isLoaded || !isRendered) return;
    try {
      const first = mapRef.current.takeSnapshot();
      await mapRef.current.takeSnapshot({ showControls: false }).then(
        () => setBusyResult('accepted'),
        () => setBusyResult('rejected')
      );
      const withControls = await first;
      const withoutControls = await mapRef.current.takeSnapshot({
        showControls: false,
      });
      setDecoded(waiting);
      setPreviewIndex(0);
      setSnapshots([withControls, withoutControls]);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : String(cause));
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Map Snapshot" onBack={onBack} />
      <View style={{ flex: 1 }}>
        <ScreenLayout
          mapRef={mapRef}
          mapProps={{
            initialCamera,
            mapType: 'None',
            isShowZoomControls: true,
            isShowScaleBar: true,
            isShowLocationButton: false,
            onMapLoaded: () => setIsLoaded(true),
            onMapRendered: ({ isFullyRendered, isRenderingStable }) => {
              if (isFullyRendered && isRenderingStable) setIsRendered(true);
            },
          }}
        >
          <NaverMapCircleOverlay
            latitude={initialCamera.latitude}
            longitude={initialCamera.longitude}
            radius={80}
            color="#ff00ff"
          />
        </ScreenLayout>
        {preview && (
          <Image
            key={preview.uri}
            testID="map-view-snapshot-preview"
            source={{ uri: preview.uri }}
            resizeMode="stretch"
            fadeDuration={0}
            style={{ position: 'absolute', inset: 0 }}
            onLoad={({ nativeEvent: { source } }) =>
              setDecoded(`${previewIndex}:${source.width},${source.height}`)
            }
            onError={({ nativeEvent }) => setError(nativeEvent.error)}
          />
        )}
      </View>
      <View style={{ gap: 4, paddingVertical: 8 }}>
        <Text testID="map-view-snapshot-ready" style={{ color: '#fff' }}>
          {isLoaded && isRendered ? 'ready' : waiting}
        </Text>
        <Text testID="map-view-snapshot-busy" style={{ color: '#fff' }}>
          {busyResult}
        </Text>
        <Text testID="map-view-snapshot-decoded" style={{ color: '#fff' }}>
          {decoded}
        </Text>
        {snapshots.map((snapshot, index) => (
          <Text
            key={snapshot.uri}
            testID={`map-view-snapshot-file-${index}`}
            style={{ color: '#fff', fontSize: 8 }}
          >
            {`${snapshot.uri}|${snapshot.width},${snapshot.height}`}
          </Text>
        ))}
        <Text testID="map-view-snapshot-error" style={{ color: '#fff' }}>
          {error}
        </Text>
        <Btn title="Capture snapshots" onPress={capture} />
        <Btn
          title="Show snapshot without controls"
          onPress={() => {
            setDecoded(waiting);
            setPreviewIndex(1);
          }}
        />
      </View>
    </SafeAreaView>
  );
};
