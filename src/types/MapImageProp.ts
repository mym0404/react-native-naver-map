import type { ImageRequireSource } from 'react-native/Libraries/Image/ImageSource';
import type { MarkerSymbol } from './MarkerSymbol';

/**
 * 네이버맵에서 쓰이는 이미지 Prop 타입입니다.
 */
export type MapImageProp =
  | ImageRequireSource
  | {
      symbol?: MarkerSymbol;
      httpUri?: string;
      assetName?: string;
      reuseIdentifier?: string;
    };
