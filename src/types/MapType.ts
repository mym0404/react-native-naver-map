export type MapType =
  | 'Basic'
  | 'Navi'
  | 'Satellite'
  | 'Hybrid'
  | 'Terrain'
  | 'NaviHybrid'
  | 'None';
export const MapTypes = [
  'Basic',
  'Navi',
  'Satellite',
  'Hybrid',
  'Terrain',
  'NaviHybrid',
  'None',
] satisfies MapType[];
