import type { Coord } from './Coord';
import type { MarkerImageProp } from './MarkerImageProp';

export interface ClusterMarkerProp extends Coord {
  identifier: string;
  image?: MarkerImageProp;
  width?: number;
  height?: number;
}
