"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/* eslint-disable @typescript-eslint/no-shadow */
var config_plugins_1 = require("@expo/config-plugins");
var withNaverMap = function (config, _a) {
    var client_id = _a.client_id, _b = _a.android, android = _b === void 0 ? {} : _b, _c = _a.ios, ios = _c === void 0 ? {} : _c;
    config = (0, config_plugins_1.withInfoPlist)(config, function (config) {
        var _a;
        config.modResults.NMFClientId = client_id;
        if (ios.NSLocationAlwaysAndWhenInUseUsageDescription) {
            config.modResults.NSLocationAlwaysAndWhenInUseUsageDescription =
                ios.NSLocationAlwaysAndWhenInUseUsageDescription;
        }
        if (ios.NSLocationWhenInUseUsageDescription) {
            config.modResults.NSLocationAlwaysUsageDescription =
                ios.NSLocationWhenInUseUsageDescription;
        }
        if (ios.NSLocationTemporaryUsageDescriptionDictionary) {
            var _b = ios.NSLocationTemporaryUsageDescriptionDictionary, purposeKey = _b.purposeKey, usageDescription = _b.usageDescription;
            config.modResults.NSLocationTemporaryUsageDescriptionDictionary = (_a = {},
                _a[purposeKey] = usageDescription,
                _a);
        }
        return config;
    });
    config = (0, config_plugins_1.withAndroidManifest)(config, function (config) {
        var mainApplication = config_plugins_1.AndroidConfig.Manifest.getMainApplicationOrThrow(config.modResults);
        config_plugins_1.AndroidConfig.Manifest.addMetaDataItemToMainApplication(mainApplication, 'com.naver.maps.map.CLIENT_ID', client_id);
        return config;
    });
    config = config_plugins_1.AndroidConfig.Permissions.withPermissions(config, [
        android.ACCESS_FINE_LOCATION
            ? 'android.permission.ACCESS_FINE_LOCATION'
            : '',
        android.ACCESS_COARSE_LOCATION
            ? 'android.permission.ACCESS_COARSE_LOCATION'
            : '',
        android.ACCESS_BACKGROUND_LOCATION
            ? 'android.permission.ACCESS_BACKGROUND_LOCATION'
            : '',
    ].filter(Boolean));
    return config;
};
exports.default = withNaverMap;
