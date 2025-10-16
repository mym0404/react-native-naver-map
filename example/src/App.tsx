import React, { useEffect, useState } from 'react';
import {
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  PERMISSIONS,
  request,
  requestLocationAccuracy,
  requestMultiple,
} from 'react-native-permissions';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { ArrowheadPathScreen } from './screens/ArrowheadPathScreen';
import { CameraScreen } from './screens/CameraScreen';
import { CircleScreen } from './screens/CircleScreen';
import { CitiesScreen } from './screens/CitiesScreen';
import { ClusteringScreen } from './screens/ClusteringScreen';
import { CommonScreen } from './screens/CommonScreen';
import { GroundScreen } from './screens/GroundScreen';
import { InfoWindowScreen } from './screens/InfoWindowScreen';
import { LocationOverlayScreen } from './screens/LocationOverlayScreen';
import { MarkerScreen } from './screens/MarkerScreen';
import { MultiPathScreen } from './screens/MultiPathScreen';
import { PathScreen } from './screens/PathScreen';
import { PolygonScreen } from './screens/PolygonScreen';
import { PolylineScreen } from './screens/PolylineScreen';

const SCREENS = [
  { id: 'common', title: 'Common Settings' },
  { id: 'camera', title: 'Camera Controls' },
  { id: 'marker', title: 'Marker Overlay' },
  { id: 'circle', title: 'Circle Overlay' },
  { id: 'ground', title: 'Ground Overlay' },
  { id: 'path', title: 'Path Overlay' },
  { id: 'multipath', title: 'Multi Path Overlay' },
  { id: 'polygon', title: 'Polygon Overlay' },
  { id: 'polyline', title: 'Polyline Overlay' },
  { id: 'arrowhead', title: 'Arrowhead Path Overlay' },
  { id: 'clustering', title: 'Clustering' },
  { id: 'locationOverlay', title: 'Location Overlay' },
  { id: 'cities', title: 'Cities (Performance Test)' },
  { id: 'infowindow', title: 'InfoWindow' },
];

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<string | null>(null);

  useEffect(() => {
    if (Platform.OS === 'ios') {
      request(PERMISSIONS.IOS.LOCATION_ALWAYS).then((status) => {
        console.log(`Location request status: ${status}`);
        if (status === 'granted') {
          requestLocationAccuracy({
            purposeKey: 'common-purpose',
          })
            .then((accuracy) => {
              console.log(`Location accuracy is: ${accuracy}`);
            })
            .catch((e) => {
              console.error(`Location accuracy request has been failed: ${e}`);
            });
        }
      });
    }
    if (Platform.OS === 'android') {
      requestMultiple([
        PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
        PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION,
      ])
        .then((status) => {
          console.log(`Location request status: ${status}`);
        })
        .catch((e) => {
          console.error(`Location request has been failed: ${e}`);
        });
    }
  }, []);

  const handleBack = () => setCurrentScreen(null);

  const renderScreen = () => {
    switch (currentScreen) {
      case 'common':
        return <CommonScreen onBack={handleBack} />;
      case 'camera':
        return <CameraScreen onBack={handleBack} />;
      case 'marker':
        return <MarkerScreen onBack={handleBack} />;
      case 'circle':
        return <CircleScreen onBack={handleBack} />;
      case 'ground':
        return <GroundScreen onBack={handleBack} />;
      case 'path':
        return <PathScreen onBack={handleBack} />;
      case 'multipath':
        return <MultiPathScreen onBack={handleBack} />;
      case 'polygon':
        return <PolygonScreen onBack={handleBack} />;
      case 'polyline':
        return <PolylineScreen onBack={handleBack} />;
      case 'arrowhead':
        return <ArrowheadPathScreen onBack={handleBack} />;
      case 'clustering':
        return <ClusteringScreen onBack={handleBack} />;
      case 'locationOverlay':
        return <LocationOverlayScreen onBack={handleBack} />;
      case 'cities':
        return <CitiesScreen onBack={handleBack} />;
      default:
        return (
          <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
            <View
              style={{
                paddingVertical: 20,
                paddingHorizontal: 16,
                borderBottomWidth: 1,
                borderBottomColor: '#333',
              }}
            >
              <Text style={{ color: '#fff', fontSize: 24, fontWeight: 'bold' }}>
                Naver Map Examples
              </Text>
            </View>
            <ScrollView
              style={{ flex: 1 }}
              contentContainerStyle={{ padding: 16, gap: 12 }}
            >
              {SCREENS.map((screen) => (
                <TouchableOpacity
                  key={screen.id}
                  onPress={() => setCurrentScreen(screen.id)}
                  style={{
                    backgroundColor: '#1a1a1a',
                    paddingVertical: 16,
                    paddingHorizontal: 20,
                    borderRadius: 8,
                    borderWidth: 1,
                    borderColor: '#333',
                  }}
                >
                  <Text
                    style={{ color: '#fff', fontSize: 16, fontWeight: '600' }}
                  >
                    {screen.title}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </SafeAreaView>
        );
    }
  };

  return <SafeAreaProvider>{renderScreen()}</SafeAreaProvider>;
}
