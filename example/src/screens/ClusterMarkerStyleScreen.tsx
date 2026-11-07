import {
  type ClusterMarkerCaption,
  type ClusterMarkerTapParams,
  type MapImageProp,
  type NaverMapViewRef,
} from '@mj-studio/react-native-naver-map';
import React, { useMemo, useRef, useState } from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

type Capture = Awaited<ReturnType<NaverMapViewRef['takeSnapshot']>> & {
  sequence: number;
};
type Mode = 'initial' | 'updated' | 'count' | 'hidden';
const camera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };
const waiting = 'waiting';
const textColor = '#fff';
const markers = ['first', 'second', 'third', 'fourth', 'fifth'].map(
  (identifier, index) => ({
    identifier,
    latitude: camera.latitude + (index < 3 ? 0 : 0.00675),
    longitude: camera.longitude,
  })
);
const images: Record<'initial' | 'updated', MapImageProp> = {
  initial: require('../assets/cluster-magenta.png'),
  updated: require('../assets/cluster-cyan.png'),
};

export const ClusterMarkerStyleScreen = ({
  onBack,
}: {
  onBack: () => void;
}) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const sequence = useRef(0);
  const [isLoaded, setIsLoaded] = useState(false);
  const [isRendered, setIsRendered] = useState(false);
  const [mode, setMode] = useState<Mode>('initial');
  const [mapSize, setMapSize] = useState({ width: 0, height: 0 });
  const [capture, setCapture] = useState<Capture>();
  const [decoded, setDecoded] = useState(waiting);
  const [error, setError] = useState('');
  const [tap, setTap] = useState<ClusterMarkerTapParams>();
  const [zoom, setZoom] = useState<number | undefined>(camera.zoom);
  const clusters = useMemo(() => {
    const isInitial = mode === 'initial';
    const caption: ClusterMarkerCaption = {
      text: isInitial
        ? 'I I I I'
        : mode === 'count'
          ? undefined
          : mode === 'hidden'
            ? ''
            : 'W W W W',
      color: isInitial ? '#ffff00' : '#ff00ff',
      haloColor: 'transparent',
      textSize: 22,
      align: isInitial ? 'Top' : 'Bottom',
      offset: 8,
    };
    return [
      {
        markers,
        animate: false,
        image: isInitial ? images.initial : images.updated,
        width: isInitial ? 64 : 80,
        height: isInitial ? 48 : 56,
        caption,
      },
    ];
  }, [mode]);

  const captureMap = async () => {
    if (!mapRef.current) return;
    try {
      const image = await mapRef.current.takeSnapshot({ showControls: false });
      sequence.current++;
      setDecoded(waiting);
      setCapture({ ...image, sequence: sequence.current });
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : String(cause));
    }
  };

  const changeMode = (value: Mode) => {
    setCapture(undefined);
    setMode(value);
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Cluster Marker Style" onBack={onBack} />
      <View style={{ flex: 1 }}>
        <ScreenLayout
          mapRef={mapRef}
          mapProps={{
            testID: 'cluster-marker-style-map',
            initialCamera: camera,
            onTapCluster: setTap,
            onCameraIdle: ({ zoom }) => setZoom(zoom),
            mapType: 'None',
            clusters,
            onLayout: ({ nativeEvent: { layout } }) =>
              setMapSize({ width: layout.width, height: layout.height }),
            onMapLoaded: () => setIsLoaded(true),
            onMapRendered: ({ isFullyRendered, isRenderingStable }) => {
              if (isFullyRendered && isRenderingStable) setIsRendered(true);
            },
          }}
          controls={
            <View style={{ width: '100%', height: 216, gap: 4 }}>
              <Text testID="cluster-marker-style-ready" style={styles.status}>
                {isLoaded && isRendered && mapSize.width > 0
                  ? 'ready'
                  : waiting}
              </Text>
              <Text testID="cluster-marker-style-layout" style={styles.status}>
                {mapSize.width},{mapSize.height}
              </Text>
              <Text
                testID="cluster-marker-style-file"
                numberOfLines={1}
                style={styles.status}
              >
                {capture
                  ? `${capture.sequence}|${capture.uri}|${capture.width},${capture.height}`
                  : waiting}
              </Text>
              <Text testID="cluster-marker-style-decoded" style={styles.status}>
                {decoded}
              </Text>
              <Text testID="cluster-marker-style-error" style={styles.status}>
                {error}
              </Text>
              <Text
                testID="cluster-tap-result"
                numberOfLines={1}
                style={styles.status}
              >
                {tap ? JSON.stringify(tap) : waiting}
              </Text>
              <Text testID="cluster-tap-zoom" style={styles.status}>
                {zoom ?? waiting}
              </Text>
              <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 4 }}>
                <Btn
                  title="Update cluster style"
                  onPress={() => changeMode('updated')}
                />
                <Btn
                  title="Use member count"
                  onPress={() => changeMode('count')}
                />
                <Btn
                  title="Hide cluster caption"
                  onPress={() => changeMode('hidden')}
                />
                <Btn title="Capture map image" onPress={captureMap} />
                {capture && (
                  <Btn
                    title="Close map image"
                    onPress={() => setCapture(undefined)}
                  />
                )}
              </View>
            </View>
          }
        />
        {capture && (
          <Image
            key={capture.uri}
            testID="cluster-marker-style-preview"
            source={{ uri: capture.uri }}
            resizeMode="stretch"
            fadeDuration={0}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: mapSize.height,
            }}
            onLoad={({ nativeEvent: { source } }) =>
              setDecoded(`${capture.sequence}|${source.width},${source.height}`)
            }
            onError={({ nativeEvent }) => setError(nativeEvent.error)}
          />
        )}
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  status: { color: textColor, fontSize: 10, lineHeight: 12 },
});
