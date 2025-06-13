import type { Coord } from './Coord';
import type { MarkerImageProp } from './MarkerImageProp';
import type { CaptionType } from '../component/NaverMapMarkerOverlay';

export interface ClusterMarkerProp extends Coord {
  identifier: string;
  caption?: CaptionType;
  image?: MarkerImageProp;
  width?: number;
  height?: number;
}
