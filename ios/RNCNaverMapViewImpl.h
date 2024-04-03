//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <NMapsMap/NMFMapView.h>
#import <NMapsMap/NMFNaverMapView.h>
#import <NMapsMap/NMFMapViewTouchDelegate.h>
#import <NMapsMap/NMFMapViewCameraDelegate.h>
#import <NMapsMap/NMFMapViewOptionDelegate.h>

@interface RNCNaverMapViewImpl : NMFNaverMapView <NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate>

@property (nonatomic, assign) NMFMapType mapType;
@property (nonatomic, assign) BOOL isIndoorEnabled;
@property (nonatomic, assign) BOOL isNightModeEnabled;
@property (nonatomic, assign) NSNumber *lightness;

@end
