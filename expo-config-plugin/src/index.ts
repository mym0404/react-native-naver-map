/* eslint-disable @typescript-eslint/no-shadow */
import {
  withInfoPlist,
  withAndroidManifest,
  AndroidConfig,
  type ConfigPlugin,
} from '@expo/config-plugins';

const withNaverMap: ConfigPlugin<{
  client_id: string;
  android?: {
    ACCESS_FINE_LOCATION?: boolean;
    ACCESS_COARSE_LOCATION?: boolean;
  };
  ios?: {
    NSLocationAlwaysUsageDescription?: string;
    NSLocationWhenInUseUsageDescription?: string;
  };
}> = (config, { client_id, android = {}, ios = {} }) => {
  config = withInfoPlist(config, (config) => {
    config.modResults.NMFClientId = client_id;
    if (ios.NSLocationAlwaysUsageDescription) {
      config.modResults.NSLocationAlwaysUsageDescription =
        ios.NSLocationAlwaysUsageDescription;
    }
    if (ios.NSLocationAlwaysUsageDescription) {
      config.modResults.NSLocationAlwaysUsageDescription =
        ios.NSLocationAlwaysUsageDescription;
    }
    return config;
  });

  config = withAndroidManifest(config, (config) => {
    const mainApplication = AndroidConfig.Manifest.getMainApplicationOrThrow(
      config.modResults
    );

    AndroidConfig.Manifest.addMetaDataItemToMainApplication(
      mainApplication,
      'com.naver.maps.map.CLIENT_ID',
      client_id
    );

    return config;
  });

  config = AndroidConfig.Permissions.withPermissions(
    config,
    [
      android.ACCESS_FINE_LOCATION
        ? 'android.permission.ACCESS_FINE_LOCATION'
        : '',
      android.ACCESS_COARSE_LOCATION
        ? 'android.permission.ACCESS_COARSE_LOCATION'
        : '',
    ].filter(Boolean)
  );

  return config;
};

export default withNaverMap;
