import {
  addNaverMapAuthFailureListener,
  type NaverMapAuthFailure,
} from '@mj-studio/react-native-naver-map';
import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const waiting = 'waiting';

export const AuthFailureScreen = ({ onBack }: { onBack: () => void }) => {
  const [isListening, setIsListening] = useState(false);
  const [isLoaded, setIsLoaded] = useState(false);
  const [failure, setFailure] = useState<NaverMapAuthFailure>();
  const [count, setCount] = useState(0);
  const [removedListenerCount, setRemovedListenerCount] = useState(0);

  useEffect(() => {
    const removed = addNaverMapAuthFailureListener(() =>
      setRemovedListenerCount((value) => value + 1)
    );
    const subscription = addNaverMapAuthFailureListener((error) => {
      setFailure(error);
      setCount((value) => value + 1);
    });
    removed.remove();
    removed.remove();
    setIsListening(true);
    return () => subscription.remove();
  }, []);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <Header title="Authentication" onBack={onBack} />
      <ScreenLayout
        showMap={isListening}
        mapProps={{
          initialCamera: { latitude: 37.5665, longitude: 126.978, zoom: 14 },
          onMapLoaded: () => setIsLoaded(true),
        }}
        controls={
          <View style={{ width: '100%', minHeight: 140, gap: 4 }}>
            <Text testID="auth-failure-code" style={styles.status}>
              {failure?.code ?? waiting}
            </Text>
            <Text testID="auth-failure-message" style={styles.status}>
              {failure?.message ?? waiting}
            </Text>
            <Text testID="auth-failure-count" style={styles.status}>
              {count}
            </Text>
            <Text testID="auth-failure-removed-count" style={styles.status}>
              {removedListenerCount}
            </Text>
            <Text testID="auth-failure-map-status" style={styles.status}>
              {isLoaded ? 'loaded' : waiting}
            </Text>
          </View>
        }
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  status: { color: '#fff', fontSize: 11 },
});
