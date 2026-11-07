//
//  RNCNaverMapUtil.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import <NMapsMap/NMapsMap.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapSpec.h"

@interface RNCNaverMapUtil : NativeRNCNaverMapUtilSpecBase <NativeRNCNaverMapUtilSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RNCNaverMapUtil : NSObject <RCTBridgeModule>
#endif

+ (NMFInfoWindow*)getInfoWindow:(NSString*)infoWindowId;
+ (void)registerInfoWindow:(NMFInfoWindow*)infoWindow withIdentifier:(NSString*)infoWindowId;
+ (void)unregisterInfoWindow:(NMFInfoWindow*)infoWindow withIdentifier:(NSString*)infoWindowId;
+ (void)closeInfoWindowsForMapView:(NMFMapView*)mapView;
+ (void)closeInfoWindowsForMarker:(NMFMarker*)marker;

@end
