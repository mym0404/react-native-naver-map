import { formatJson, generateArray } from '@mj-studio/js-util';
import {
  type Camera,
  type ClusterMarkerProp,
  type MapType,
  NaverMapArrowheadPathOverlay,
  NaverMapCircleOverlay,
  NaverMapGroundOverlay,
  NaverMapMarkerOverlay,
  NaverMapMultiPathOverlay,
  NaverMapPathOverlay,
  NaverMapPolygonOverlay,
  NaverMapPolylineOverlay,
  NaverMapView,
  type NaverMapViewRef,
  type Region,
} from '@mj-studio/react-native-naver-map';
import React, {
  useEffect,
  useMemo,
  useRef,
  useState,
  useTransition,
} from 'react';
import { Platform, Text, View } from 'react-native';
import {
  PERMISSIONS,
  request,
  requestLocationAccuracy,
} from 'react-native-permissions';
import { Btn, Range, Toggle } from './component/components';
import { type City, getCitiesByRegion } from './db/CityDatabase';

// const jejuRegion: Region = {
//   latitude: 33.20530773,
//   longitude: 126.14656715029,
//   latitudeDelta: 0.38,
//   longitudeDelta: 0.8,
// };

const Cameras = {
  Seolleung: {
    latitude: 37.50497126,
    longitude: 127.04905021,
    zoom: 14,
  },
  Gangnam: {
    latitude: 37.498040483,
    longitude: 127.02758183,
    zoom: 14,
  },
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
} satisfies Record<string, Camera>;

const Regions = {
  Seolleung: {
    latitude: 37.50497126 - 0.025,
    longitude: 127.04905021 - 0.025,
    latitudeDelta: 0.05,
    longitudeDelta: 0.05,
  },
  Gangnam: {
    latitude: 37.498040483 - 0.025,
    longitude: 127.02758183 - 0.025,
    latitudeDelta: 0.05,
    longitudeDelta: 0.05,
  },
  Jeju: {
    latitude: 33.39530773 + 1,
    longitude: 126.54656715029 - 1,
    latitudeDelta: 0.05,
    longitudeDelta: 0.05,
  },
} satisfies Record<string, Region>;

/**
 * @private
 */
const MapTypes = [
  'Basic',
  'Navi',
  'Satellite',
  'Hybrid',
  'Terrain',
  'NaviHybrid',
  'None',
] satisfies MapType[];

export default function App() {
  const ref = useRef<NaverMapViewRef>(null);

  const [camera, setCamera] = useState(Cameras.Jeju);

  const [nightMode, setNightMode] = useState(false);
  const [indoor, setIndoor] = useState(false);
  const [mapType, setMapType] = useState<MapType>(MapTypes[0]!);
  const [lightness, setLightness] = useState(0);
  const [compass, setCompass] = useState(true);
  const [scaleBar, setScaleBar] = useState(true);
  const [zoomControls, setZoomControls] = useState(true);
  const [indoorLevelPicker, setIndoorLevelPicker] = useState(true);
  const [myLocation, setMyLocation] = useState(true);

  useEffect(() => {
    if (Platform.OS === 'ios') {
      request(PERMISSIONS.IOS.LOCATION_ALWAYS).then((status) => {
        console.log(`Location request status: ${status}`);
        if (status === 'granted') {
          requestLocationAccuracy({
            purposeKey: 'common-purpose', // replace your purposeKey of Info.plist
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
      // requestMultiple([
      //   PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
      //   PERMISSIONS.ANDROID.ACCESS_BACKGROUND_LOCATION,
      // ])
      //   .then((status) => {
      //     console.log(`Location request status: ${status}`)
      //   })
      //   .catch((e) => {
      //     console.error(`Location request has been failed: ${e}`)
      //   })
    }
  }, []);

  const [hash, setHash] = useState(0);
  const clusters = useMemo<
    {
      markers: ClusterMarkerProp[];
      screenDistance?: number;
      minZoom?: number;
      maxZoom?: number;
      animate?: boolean;
      width?: number;
      height?: number;
    }[]
  >(() => {
    return generateArray(5).map((i) => {
      return {
        width: 40,
        height: 40,
        markers: generateArray(3).map<ClusterMarkerProp>(
          (j) =>
            ({
              image: {
                httpUri: `https://picsum.photos/seed/${hash}-${i}-${j}/32/32`,
              },
              width: 40,
              height: 40,
              latitude: Cameras.Jeju.latitude + Math.random() + 1.5,
              longitude: Cameras.Jeju.longitude + Math.random() + 1.5,
              identifier: `${hash}-${i}-${j}`,
            }) satisfies ClusterMarkerProp
        ),
      };
    });
  }, [hash]);

  const renderOverlays = () => {
    return (
      <>
        <NaverMapMarkerOverlay
          latitude={30.4165607356}
          longitude={123.48599018}
          onTap={() => console.log(1)}
          anchor={{ x: 0.5, y: 1 }}
          width={100}
          height={100}
          key={3}
        >
          <View
            style={{
              width: 100,
              height: 100,
              backgroundColor: 'red',
              alignItems: 'center',
              alignSelf: 'center',
            }}
            collapsable={false}
            key={5}
          >
            <Text>123456</Text>
          </View>
        </NaverMapMarkerOverlay>
        <NaverMapMarkerOverlay
          latitude={31.1565607356}
          longitude={123.88599018}
          onTap={() => console.log(1)}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: 'helloj2',
          }}
          subCaption={{
            text: '123',
          }}
          image={require('./logo180.png')}
        />
        <NaverMapMarkerOverlay
          latitude={30.0565607356}
          longitude={123.88599018}
          onTap={() => console.log(1)}
          anchor={{ x: 0.5, y: 1 }}
          caption={{
            text: 'helloj2',
          }}
          subCaption={{
            text: '123',
          }}
          width={100}
          height={50}
          image={{ assetName: 'thumbnail' }}
        />
        <NaverMapMarkerOverlay
          latitude={30.2565607356}
          longitude={123.8599018}
          onTap={() => console.log(1)}
          anchor={{ x: 0.5, y: 1 }}
          // caption={{
          //   text: 'hello',
          // }}
          // subCaption={{
          //   text: '123',
          // }}
          width={100}
          height={100}
          image={{ httpUri: 'https://picsum.photos/1000/1201' }}
        />

        <NaverMapArrowheadPathOverlay
          coords={[
            { longitude: 126.93240597362552, latitude: 32.433509943138404 },
            { longitude: 126.93474226289788, latitude: 32.6383463419792 },
            { longitude: 127.07281803100506, latitude: 32.57085962943823 },
            { longitude: 126.96403036772739, latitude: 32.52862726684933 },
          ]}
          zIndex={0}
          headSizeRatio={2.5}
          width={8}
          color={'red'}
          outlineColor={'blue'}
          outlineWidth={2}
        />
        <NaverMapCircleOverlay
          latitude={33.17827398}
          longitude={126.349895729}
          radius={10000}
          color={'#f2f'}
          isHidden
          outlineColor={'#aaa'}
          outlineWidth={2}
          globalZIndex={-1}
          onTap={() => console.log('hi')}
        />

        <NaverMapGroundOverlay
          image={{ assetName: 'thumbnail' }}
          region={Regions.Jeju}
          onTap={() => console.log(1)}
        />
        <NaverMapPathOverlay
          coords={[
            { latitude: 32.345332063, longitude: 126.24180047 },
            { latitude: 32.70066, longitude: 126.2719053 },
            { latitude: 32.360030018, longitude: 126.37221049 },
            { longitude: 126.4661129593128, latitude: 32.671851556552205 },
            { longitude: 126.52469300979067, latitude: 32.38556958856244 },
          ]}
          width={8}
          color={'white'}
          progress={0.5}
          passedColor={'black'}
          outlineWidth={1}
        />
        <NaverMapMultiPathOverlay
          coordParts={[
            [
              { latitude: 33.5744287, longitude: 126.982625 },
              { latitude: 33.57152, longitude: 126.97714 },
              { latitude: 33.56607, longitude: 126.98268 },
            ],
            [
              { latitude: 33.56607, longitude: 126.98268 },
              { latitude: 33.56445, longitude: 126.97707 },
              { latitude: 33.55855, longitude: 126.97822 },
            ],
            [
              { latitude: 33.55855, longitude: 126.97822 },
              { latitude: 33.55234, longitude: 126.98456 },
              { latitude: 33.54789, longitude: 126.97333 },
            ],
          ]}
          colorParts={[
            {
              color: 'red',
              passedColor: 'darkred',
              outlineColor: 'white',
              passedOutlineColor: 'gray',
            },
            {
              color: 'green',
              passedColor: 'darkgreen',
              outlineColor: 'white',
              passedOutlineColor: 'gray',
            },
            {
              color: 'blue',
              passedColor: 'darkblue',
              outlineColor: 'white',
              passedOutlineColor: 'gray',
            },
          ]}
          width={6}
          outlineWidth={2}
          onTap={() => console.log('MultiPath tapped!')}
        />
        <NaverMapPolygonOverlay
          outlineWidth={5}
          outlineColor={'#f2f2'}
          color={'#0068'}
          coords={[
            { latitude: 33.2249594, longitude: 126.54180047 },
            { latitude: 33.25683311547, longitude: 126.18193 },
            { latitude: 33.3332807, longitude: 126.838389399 },
          ]}
        />
        <NaverMapPolylineOverlay
          color={'#0068'}
          coords={[
            { latitude: 33.2249594, longitude: 126.54180047 },
            { latitude: 33.25683311547, longitude: 126.18193 },
            { latitude: 33.3332807, longitude: 126.838389399 },
          ]}
        />
      </>
    );
  };
  const [rerenderKey, setRerenderKey] = useState(0);

  const [cities, setCities] = useState<City[]>([]);
  const [, startTransition] = useTransition();

  return (
    <View
      style={{
        flex: 1,
      }}
    >
      {rerenderKey % 2 === 0 ? (
        <NaverMapView
          camera={camera}
          // initialCamera={Cameras.Jeju}
          // region={Regions.Seolleung}
          // initialRegion={Regions.Seolleung}
          ref={ref}
          style={{ flex: 1 }}
          mapType={mapType}
          layerGroups={{
            BUILDING: true,
            BICYCLE: false,
            CADASTRAL: false,
            MOUNTAIN: false,
            TRAFFIC: false,
            TRANSIT: false,
          }}
          isIndoorEnabled={indoor}
          lightness={lightness}
          isNightModeEnabled={nightMode}
          isShowCompass={compass}
          isShowIndoorLevelPicker={indoorLevelPicker}
          isShowScaleBar={scaleBar}
          isShowZoomControls={zoomControls}
          isShowLocationButton={myLocation}
          // isExtentBoundedInKorea
          onInitialized={() => console.log('initialized!')}
          onOptionChanged={({ locationTrackingMode }) =>
            console.log('Option Changed!', locationTrackingMode)
          }
          onCameraChanged={({ region }) => {
            console.log(
              `Camera: ${formatJson({ latitude: region.latitude, longitude: region.longitude })}`
            );

            startTransition(() => {
              // console.log(`Region: ${formatJson(region)}`);
              // eslint-disable-next-line @typescript-eslint/no-shadow
              const cities = getCitiesByRegion(region);
              // console.log(cities.length);
              setCities(cities);
            });
          }}
          onCameraIdle={() => {
            // console.log('idle', region);
          }}
          onTapMap={(args) => console.log(`Map Tapped: ${formatJson(args)}`)}
          clusters={clusters}
          // locationOverlay={{
          //   isVisible: true,
          //   position: Cameras.Jeju,
          //   circleRadius: 100,
          //   circleOutlineWidth: 10,
          //   circleOutlineColor: 'blue',
          // }}
          onTapClusterLeaf={({ markerIdentifier }) => {
            console.log('onTapClusterLeaf', markerIdentifier);
          }}
        >
          {renderOverlays()}
          {cities.map((city, i) => (
            <NaverMapMarkerOverlay
              key={`${city.region}-${city.lat}-${i}`}
              latitude={city.lat}
              longitude={city.lng}
              alpha={0.2}
              image={require('./logo180.png')}
              width={1}
              height={1}
            />
          ))}
        </NaverMapView>
      ) : (
        <View style={{ flex: 1 }} />
      )}
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
        <Btn title={`Refresh Images`} onPress={() => setHash((h) => h + 1)} />
        <Btn
          title={`Type(${mapType})`}
          onPress={() =>
            setMapType(
              MapTypes[
                (MapTypes.findIndex((v) => v === mapType) + 1) % MapTypes.length
              ]!
            )
          }
        />
        <Btn
          title={'Update Camera'}
          onPress={() => {
            setCamera(Cameras.Gangnam);
          }}
        />
        <Btn
          title={'Move to'}
          onPress={() => {
            ref.current?.animateCameraTo(Cameras.Jeju);
          }}
        />
        <Btn
          title={'Move by'}
          onPress={() => {
            ref.current?.animateCameraBy({
              x: 100,
              y: 100,
            });
          }}
        />
        <Btn
          title={'Move Two Coord'}
          onPress={() => {
            ref.current?.animateCameraWithTwoCoords({
              coord1: {
                latitude: 33.56082727271,
                longitude: 126.170697865,
              },
              coord2: {
                latitude: 33.2439870024,
                longitude: 126.9221848004,
              },
            });
          }}
        />
        <Btn
          title={'Move Region'}
          onPress={() => {
            ref.current?.animateRegionTo({
              latitude: 33.20530773,
              longitude: 126.14656715029,
              latitudeDelta: 0.38,
              longitudeDelta: 0.8,
            });
          }}
        />
        <Btn
          title={'Cancel'}
          onPress={() => {
            ref.current?.cancelAnimation();
          }}
        />
        <Btn
          title={'Face'}
          onPress={() => {
            ref.current?.setLocationTrackingMode('Face');
          }}
        />
        <Btn
          title={'Follow'}
          onPress={() => {
            ref.current?.setLocationTrackingMode('Follow');
          }}
        />
        <Btn
          title={'NoFollow'}
          onPress={() => {
            ref.current?.setLocationTrackingMode('NoFollow');
          }}
        />
        <Btn
          title={'None'}
          onPress={() => {
            ref.current?.setLocationTrackingMode('None');
          }}
        />
        <Btn
          title={'Screen -> Coord'}
          onPress={() => {
            ref.current
              ?.screenToCoordinate({ screenX: 0, screenY: 0 })
              .then(console.log);
          }}
        />
        <Btn
          title={'Coord -> Screen'}
          onPress={() => {
            ref.current
              ?.coordinateToScreen({ ...Cameras.Jeju })
              .then(console.log);
          }}
        />
        <Btn title={'Rerender'} onPress={() => setRerenderKey((k) => k + 1)} />

        <Toggle value={nightMode} onChange={setNightMode} text={'Night'} />
        <Toggle value={indoor} onChange={setIndoor} text={'Indoor'} />
        <Toggle value={compass} onChange={setCompass} text={'Compass'} />
        <Toggle value={scaleBar} onChange={setScaleBar} text={'Scale Bar'} />
        <Toggle
          value={myLocation}
          onChange={setMyLocation}
          text={'Location Btn'}
        />
        <Toggle
          value={zoomControls}
          onChange={setZoomControls}
          text={'Zoom Controls'}
        />
        <Toggle
          value={indoorLevelPicker}
          onChange={setIndoorLevelPicker}
          text={'Indoor Level'}
        />
        {/*<Range*/}
        {/*  min={0}*/}
        {/*  max={1}*/}
        {/*  value={symbolScale}*/}
        {/*  onChange={setSymbolScale}*/}
        {/*  text={'Symbol Scale'}*/}
        {/*/>*/}
        <Range
          min={-1}
          max={1}
          value={lightness}
          onChange={setLightness}
          text={'Lightness'}
        />
        <Toggle
          value={rerenderKey % 2 === 0}
          onChange={() => setRerenderKey((k) => k + 1)}
          text={'show'}
        />
      </View>
    </View>
  );
}
