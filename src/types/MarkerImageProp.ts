import type { MarkerSymbol } from './MarkerSymbol';
import type { ImageRequireSource } from 'react-native/Libraries/Image/ImageSource';

export type MarkerImageProp =
  | ImageRequireSource
  | {
      symbol?: MarkerSymbol;
      httpUri?: string;
      assetName?: string;
      reuseIdentifier?: string;
    };
