import {
  NaverMapInfoWindow,
  type NaverMapInfoWindowRef,
  NaverMapMarkerOverlay,
  type NaverMapMarkerOverlayRef,
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
const camera = { latitude: 37.5665, longitude: 126.978, zoom: 14 };
const waiting = 'waiting';
const textColor = '#fff';

export const InfoWindowContentScreen = ({ onBack }: { onBack: () => void }) => {
  const mapRef = useRef<NaverMapViewRef>(null);
  const markerRef = useRef<NaverMapMarkerOverlayRef>(null);
  const infoRef = useRef<NaverMapInfoWindowRef>(null);
  const sequence = useRef(0);
  const [isLoaded, setIsLoaded] = useState(false);
  const [isRendered, setIsRendered] = useState(false);
  const [isContentLaidOut, setIsContentLaidOut] = useState(false);
  const [revision, setRevision] = useState(1);
  const [isReversed, setIsReversed] = useState(false);
  const [mapHeight, setMapHeight] = useState(0);
  const [capture, setCapture] = useState<Capture>();
  const [decoded, setDecoded] = useState(waiting);
  const [error, setError] = useState('');

  const content = useMemo(
    () => (
      <View
        style={{
          width: 144,
          height: 64,
          padding: 4,
          backgroundColor: revision === 1 ? '#ff00ff' : '#00ffff',
        }}
        onLayout={({ nativeEvent: { layout } }) =>
          setIsContentLaidOut(layout.width > 0 && layout.height > 0)
        }
      >
        <Text style={{ color: textColor, fontSize: 16, lineHeight: 20 }}>
          {revision === 1 ? 'AAAAAA' : 'WWWWWW'}
        </Text>
      </View>
    ),
    [revision]
  );

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

  const markerElement = (
    <NaverMapMarkerOverlay
      key="marker"
      ref={markerRef}
      latitude={camera.latitude}
      longitude={camera.longitude}
      width={8}
      height={8}
      anchor={{ x: 0.5, y: 0.5 }}
    />
  );
  const infoWindowElement = (
    <NaverMapInfoWindow
      key="info-window"
      ref={infoRef}
      anchor={{ x: 0.5, y: 0.5 }}
    >
      {content}
    </NaverMapInfoWindow>
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Custom Info Window" onBack={onBack} />
      <View style={{ flex: 1 }}>
        <ScreenLayout
          mapRef={mapRef}
          mapProps={{
            initialCamera: camera,
            mapType: 'None',
            onLayout: ({ nativeEvent: { layout } }) =>
              setMapHeight(layout.height),
            onMapLoaded: () => setIsLoaded(true),
            onMapRendered: ({ isFullyRendered, isRenderingStable }) => {
              if (isFullyRendered && isRenderingStable) setIsRendered(true);
            },
          }}
          controls={
            <View style={{ width: '100%', height: 180, gap: 4 }}>
              <Text testID="info-window-content-ready" style={styles.status}>
                {isLoaded && isRendered && isContentLaidOut ? 'ready' : waiting}
              </Text>
              <Text
                testID="info-window-content-file"
                numberOfLines={1}
                style={styles.status}
              >
                {capture
                  ? `${capture.sequence}|${capture.uri}|${capture.width},${capture.height}`
                  : waiting}
              </Text>
              <Text testID="info-window-content-decoded" style={styles.status}>
                {decoded}
              </Text>
              <Text testID="info-window-content-error" style={styles.status}>
                {error}
              </Text>
              <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 4 }}>
                <Btn
                  title="Open on map"
                  onPress={() => {
                    setCapture(undefined);
                    infoRef.current?.showOnMap({ mapRef, position: camera });
                  }}
                />
                <Btn
                  title="Update custom content"
                  onPress={() => {
                    setCapture(undefined);
                    setRevision(2);
                  }}
                />
                <Btn
                  title="Close info window"
                  onPress={() => {
                    setCapture(undefined);
                    infoRef.current?.close();
                  }}
                />
                <Btn
                  title="Open on marker"
                  onPress={() => {
                    setCapture(undefined);
                    infoRef.current?.showOnMarker({
                      markerRef,
                      alignType: 'Center',
                    });
                  }}
                />
                <Btn title="Capture map image" onPress={captureMap} />
                <Btn
                  title="Reorder overlays"
                  onPress={() => {
                    setCapture(undefined);
                    setIsReversed((value) => !value);
                  }}
                />
              </View>
            </View>
          }
        >
          {isReversed
            ? [infoWindowElement, markerElement]
            : [markerElement, infoWindowElement]}
        </ScreenLayout>
        {capture && (
          <Image
            key={capture.uri}
            testID="info-window-content-preview"
            source={{ uri: capture.uri }}
            resizeMode="stretch"
            fadeDuration={0}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: mapHeight,
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
