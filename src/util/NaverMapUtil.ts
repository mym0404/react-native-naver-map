// import { Platform, NativeModules } from 'react-native';
// import type { Spec } from '../spec/NativeRNCNaverMapUtil';
//
// const LINKING_ERROR =
//   "The package '@mj-studio/react-native-naver-map' doesn't seem to be linked. Make sure: \n\n" +
//   Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
//   '- You rebuilt the app after installing the package\n' +
//   '- You are not using Expo Go\n';
//
// // @ts-ignore
// const isTurboModuleEnabled = global.__turboModuleProxy != null;
//
// const Module = isTurboModuleEnabled
//   ? require('../spec/NativeRNCNaverMapUtil').default
//   : NativeModules.NativeRNCNaverMapUtil;
//
// const Native: Spec = Module
//   ? Module
//   : new Proxy(
//       {},
//       {
//         get() {
//           throw new Error(LINKING_ERROR);
//         },
//       }
//     );

export const NaverMapUtil = {};
