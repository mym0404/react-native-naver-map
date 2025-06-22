import type { ImageRequireSource } from 'react-native/Libraries/Image/ImageSource';
import type { MarkerSymbol } from './MarkerSymbol';

/**
 * 마커의 이미지 Prop 타입입니다.
 */
export type MarkerImageProp =
  | ImageRequireSource
  | {
      symbol?: MarkerSymbol;
      httpUri?: string;
      assetName?: string;
      reuseIdentifier?: string;
    };
