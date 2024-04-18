import type { Coord, MarkerImageProp } from '@mj-studio/react-native-naver-map';

export interface ClusterMarkerProp extends Coord {
  identifier: string;
  image?: MarkerImageProp;
}
