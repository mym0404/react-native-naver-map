//
//  FnUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//
#ifndef FnUtil_h
#define FnUtil_h

//#import <Foundation/Foundation.h>
//#import <NMapsGeometry/NMGLatLng.h>
//#import <NMapsGeometry/NMGLatLngBounds.h>
//#import <NMapsMap/NMFCameraPosition.h>

//#import <NMapsMap/NMFMapView.h>
//#import <NMapsMap/NMFMapViewCameraDelegate.h>
//#import <NMapsMap/NMFMapViewOptionDelegate.h>
//#import <NMapsMap/NMFMapViewTouchDelegate.h>
//#import <NMapsMap/NMFNaverMapView.h>
//#import <NMapsMap/NMFOverlay.h>

BOOL isValidNumber(NSNumber *value) {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return false;
    }

    double INVALID = -123123123.0;

    if ([value doubleValue] < INVALID + 1 &&
        [value doubleValue] > INVALID - 1) {
        return false;
    }

    return true;
}

BOOL isValidNumber(double value) {
    return isValidNumber([NSNumber numberWithDouble:value]);
}

NSNumber * getNumberOrNil(NSNumber *value) {
    if (!isValidNumber(value)) {
        return nil;
    }

    return value;
}

double getDoubleOrDefault(NSNumber *value, double def) {
    if (!isValidNumber(value)) {
        return def;
    }

    return [value doubleValue];
}

#endif /* ifndef FnUtil_h */
