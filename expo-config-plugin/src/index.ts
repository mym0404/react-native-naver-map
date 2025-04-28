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
    ACCESS_BACKGROUND_LOCATION?: boolean;
  };
  ios?: {
    NSLocationAlwaysAndWhenInUseUsageDescription?: string;
    NSLocationTemporaryUsageDescriptionDictionary?: {
      purposeKey: string;
      usageDescription: string;
    };
    NSLocationWhenInUseUsageDescription?: string;
  };
}> = (config, { client_id, android = {}, ios = {} }) => {
  config = withInfoPlist(config, (config) => {
    config.modResults.NMFNcpKeyId = client_id;
    config.modResults.NMFClientId = client_id; // For legacy AI Naver API, https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1
    if (ios.NSLocationAlwaysAndWhenInUseUsageDescription) {
      config.modResults.NSLocationAlwaysAndWhenInUseUsageDescription =
        ios.NSLocationAlwaysAndWhenInUseUsageDescription;
    }
    if (ios.NSLocationWhenInUseUsageDescription) {
      config.modResults.NSLocationAlwaysUsageDescription =
        ios.NSLocationWhenInUseUsageDescription;
    }
    if (ios.NSLocationTemporaryUsageDescriptionDictionary) {
      const { purposeKey, usageDescription } =
        ios.NSLocationTemporaryUsageDescriptionDictionary;
      config.modResults.NSLocationTemporaryUsageDescriptionDictionary = {
        [purposeKey]: usageDescription,
      };
    }
    return config;
  });

  config = withAndroidManifest(config, (config) => {
    const mainApplication = AndroidConfig.Manifest.getMainApplicationOrThrow(
      config.modResults
    );

    const clientIdMetadataKeys = [
      'com.naver.maps.map.NCP_KEY_ID',
      'com.naver.maps.map.CLIENT_ID', // For legacy AI Naver API, https://www.ncloud.com/support/notice/all/1930?searchKeyword=map&page=1
    ];

    clientIdMetadataKeys.forEach((metadataKey) => {
      AndroidConfig.Manifest.addMetaDataItemToMainApplication(
        mainApplication,
        metadataKey,
        client_id
      );
    });

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
      android.ACCESS_BACKGROUND_LOCATION
        ? 'android.permission.ACCESS_BACKGROUND_LOCATION'
        : '',
    ].filter(Boolean)
  );

  return config;
};

export default withNaverMap;
