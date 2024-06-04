import type { Region } from '@mj-studio/react-native-naver-map';

export interface City {
  region: string;
  lat: number;
  lng: number;
}

const items: City[] = [
  { region: 'Seoul', lat: 37.5665, lng: 126.978 },
  { region: 'Busan', lat: 35.1796, lng: 129.0756 },
  { region: 'Incheon', lat: 37.4563, lng: 126.7052 },
  { region: 'Daegu', lat: 35.8722, lng: 128.6014 },
  { region: 'Daejeon', lat: 36.351, lng: 127.385 },
  { region: 'Gwangju', lat: 35.1595, lng: 126.8526 },
  { region: 'Suwon', lat: 37.2636, lng: 127.0286 },
  { region: 'Ulsan', lat: 35.5384, lng: 129.3114 },
  { region: 'Goyang', lat: 37.6584, lng: 126.832 },
  { region: 'Yongin', lat: 37.2411, lng: 127.177 },
  { region: 'Changwon', lat: 35.2286, lng: 128.6811 },
  { region: 'Seongnam', lat: 37.42, lng: 127.1264 },
  { region: 'Hwaseong', lat: 37.1996, lng: 126.831 },
  { region: 'Uijeongbu', lat: 37.738, lng: 127.045 },
  { region: 'Pohang', lat: 36.019, lng: 129.3435 },
  { region: 'Cheongju', lat: 36.6372, lng: 127.4898 },
  { region: 'Jeonju', lat: 35.8219, lng: 127.148 },
  { region: 'Cheonan', lat: 36.8065, lng: 127.1522 },
  { region: 'Gimhae', lat: 35.2281, lng: 128.8899 },
  { region: 'Pyeongtaek', lat: 36.9921, lng: 127.1127 },
  { region: 'Jinju', lat: 35.1799, lng: 128.1076 },
  { region: 'Asan', lat: 36.7897, lng: 127.0069 },
  { region: 'Wonju', lat: 37.3422, lng: 127.9202 },
  { region: 'Gunsan', lat: 35.9676, lng: 126.7367 },
  { region: 'Jeju', lat: 33.4996, lng: 126.5312 },
  { region: 'Boryeong', lat: 36.3335, lng: 126.6186 },
  { region: 'Gimcheon', lat: 36.1398, lng: 128.1136 },
  { region: 'Gumi', lat: 36.1195, lng: 128.3446 },
  { region: 'Yeosu', lat: 34.7604, lng: 127.6622 },
  { region: 'Suncheon', lat: 34.9506, lng: 127.4875 },
  { region: 'Mokpo', lat: 34.8118, lng: 126.392 },
  { region: 'Yangsan', lat: 35.3386, lng: 129.0373 },
  { region: 'Andong', lat: 36.5684, lng: 128.7294 },
  { region: 'Samcheok', lat: 37.4498, lng: 129.165 },
  { region: 'Mungyeong', lat: 36.5943, lng: 128.2037 },
  { region: 'Yeongju', lat: 36.8059, lng: 128.624 },
  { region: 'Gangneung', lat: 37.7519, lng: 128.8761 },
  { region: 'Chuncheon', lat: 37.8813, lng: 127.7298 },
  { region: 'Donghae', lat: 37.5244, lng: 129.1142 },
  { region: 'Sokcho', lat: 38.207, lng: 128.5919 },
  { region: 'Yangyang', lat: 38.0755, lng: 128.6191 },
  { region: 'Gapyeong', lat: 37.8314, lng: 127.509 },
  { region: 'Paju', lat: 37.759, lng: 126.7806 },
  { region: 'Gimpo', lat: 37.6157, lng: 126.7155 },
  { region: 'Namyangju', lat: 37.6367, lng: 127.2165 },
  { region: 'Hanam', lat: 37.5407, lng: 127.2146 },
  { region: 'Icheon', lat: 37.279, lng: 127.4423 },
  { region: 'Anseong', lat: 37.0078, lng: 127.27 },
  { region: 'Pyeongchang', lat: 37.3709, lng: 128.3902 },
  { region: 'Hongcheon', lat: 37.6913, lng: 127.8884 },
  { region: 'Hwacheon', lat: 38.1061, lng: 127.707 },
  { region: 'Inje', lat: 38.0697, lng: 128.1707 },
  { region: 'Yeongwol', lat: 37.1837, lng: 128.4617 },
  { region: 'Jeongseon', lat: 37.3809, lng: 128.6605 },
  { region: 'Pohang', lat: 36.0323, lng: 129.365 },
  { region: 'Gyeongju', lat: 35.8562, lng: 129.2247 },
  { region: 'Yeongcheon', lat: 35.4019, lng: 128.9387 },
  { region: 'Goryeong', lat: 35.7289, lng: 128.2622 },
  { region: 'Cheongdo', lat: 35.6484, lng: 128.7369 },
  { region: 'Gimcheon', lat: 36.1275, lng: 128.1435 },
  { region: 'Pilseung', lat: 35.1814, lng: 128.1065 },
  { region: 'Miryang', lat: 35.4933, lng: 128.7463 },
  { region: 'Geoje', lat: 34.8808, lng: 128.6219 },
  { region: 'Tongyeong', lat: 34.8855, lng: 128.6263 },
  { region: 'Sacheon', lat: 35.0718, lng: 128.0936 },
  { region: 'Namhae', lat: 34.837, lng: 127.8927 },
  { region: 'Hapcheon', lat: 35.5649, lng: 128.1622 },
  { region: 'Geochang', lat: 35.5651, lng: 127.9095 },
  { region: 'Changnyeong', lat: 35.4096, lng: 128.4972 },
  { region: 'Boseong', lat: 34.7717, lng: 127.0794 },
  { region: 'Nagwamyeon', lat: 35.0222, lng: 127.256 },
  { region: 'Gwangyang', lat: 34.9756, lng: 127.5891 },
  { region: 'Hwasun', lat: 35.0621, lng: 126.9854 },
  { region: 'Naju', lat: 35.0153, lng: 126.7135 },
  { region: 'Muan', lat: 34.9895, lng: 126.4784 },
  { region: 'Haenam', lat: 34.5721, lng: 126.6006 },
  { region: 'Jangheung', lat: 34.6821, lng: 126.9086 },
  { region: 'Goheung', lat: 34.619, lng: 127.2875 },
  { region: 'Boseong', lat: 34.7707, lng: 127.079 },
  { region: 'Hampyeong', lat: 35.0653, lng: 126.5211 },
  { region: 'Yeongam', lat: 34.8001, lng: 126.6987 },
  { region: 'Jindo', lat: 34.4882, lng: 126.2644 },
  { region: 'Wando', lat: 34.3115, lng: 126.754 },
  { region: 'Jeongeup', lat: 35.5682, lng: 126.8555 },
  { region: 'Namwon', lat: 35.4167, lng: 127.3855 },
  { region: 'Imsil', lat: 35.6149, lng: 127.2845 },
  { region: 'Jinan', lat: 35.7914, lng: 127.4255 },
  { region: 'Muju', lat: 35.9204, lng: 127.6604 },
  { region: 'Gochang', lat: 35.4434, lng: 126.7047 },
  { region: 'Buan', lat: 35.7288, lng: 126.7337 },
  { region: 'Uljin', lat: 36.993, lng: 129.4 },
  { region: 'Gyeongju', lat: 35.8562, lng: 129.2247 },
  { region: 'Pohang', lat: 36.0323, lng: 129.365 },
  { region: 'Yeongdeok', lat: 36.4173, lng: 129.3661 },
  { region: 'Yeongyang', lat: 36.665, lng: 129.117 },
  { region: 'Cheongsong', lat: 36.4354, lng: 129.0573 },
];

export function getCitiesByRegion({
  longitudeDelta,
  latitudeDelta,
  longitude,
  latitude,
}: Region): City[] {
  const ret: City[] = [];

  for (const item of items) {
    if (
      item.lat >= latitude &&
      item.lat < latitude + latitudeDelta &&
      item.lng >= longitude &&
      item.lng < longitude + longitudeDelta
    ) {
      ret.push({ ...item });
    }
  }
  return ret;
}
