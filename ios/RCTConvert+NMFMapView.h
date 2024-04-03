//
//  RCTConvert+NMFMapView.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <React/RCTConvert.h>

#import <NMapsMap/NMFCameraPosition.h>
#import <NMapsMap/NMFCameraUpdate.h>
#import <NMapsMap/NMFMapView.h>
#import <NMapsMap/NMFOverlay.h>

@interface RCTConvert (NMFMapView)

+ (NMFCameraUpdate *)NMFCameraUpdate:(id)json;
+ (NMFCameraUpdate *)NMFCameraUpdateWith:(id)json;
+ (NMGLatLng *)NMGLatLng:(id)json;
+ (NMGLatLngBounds *)NMGLatLngBounds:(id)json;
+ (NMFAlignType *)NMFAlignType:(id)json;

@end
