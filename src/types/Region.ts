import type { Coord } from '@mj-studio/react-native-naver-map';

export type Region = Coord & {
  latitudeDelta: number;
  longitudeDelta: number;
};
