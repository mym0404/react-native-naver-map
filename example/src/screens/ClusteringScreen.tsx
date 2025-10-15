import { generateArray } from '@mj-studio/js-util';
import { type ClusterMarkerProp } from '@mj-studio/react-native-naver-map';
import React, { useMemo, useState } from 'react';
import { Btn } from '../component/components';
import { Header } from '../components/Header';
import { ScreenLayout } from '../components/ScreenLayout';

const Cameras = {
  Jeju: {
    latitude: 33.39530773,
    longitude: 126.54656715029,
    zoom: 8,
  },
};

export const ClusteringScreen = ({ onBack }: { onBack: () => void }) => {
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

  return (
    <>
      <Header title={'Clustering'} onBack={onBack} />
      <ScreenLayout
        mapProps={{
          camera: Cameras.Jeju,
          clusters,
          onTapClusterLeaf: ({ markerIdentifier }) => {
            console.log('onTapClusterLeaf', markerIdentifier);
          },
        }}
        controls={
          <>
            <Btn
              title={'Refresh Images'}
              onPress={() => setHash((h) => h + 1)}
            />
          </>
        }
      />
    </>
  );
};
