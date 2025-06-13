import type { Coord } from './Coord';
import type { MarkerImageProp } from './MarkerImageProp';
import type { NativeCaptionProp } from '../spec/RNCNaverMapMarkerNativeComponent';

export interface ClusterMarkerProp extends Coord {
  identifier: string;
  caption?: Readonly<NativeCaptionProp>;
  image?: MarkerImageProp;
  width?: number;
  height?: number;
}
