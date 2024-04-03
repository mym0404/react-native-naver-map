//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <Foundation/Foundation.h>
#import <React/RCTView.h>
#import <NMapsMap/NMFMapView.h>
#import <NMapsMap/NMFNaverMapView.h>
#import <NMapsMap/NMFMapViewTouchDelegate.h>
#import <NMapsMap/NMFMapViewCameraDelegate.h>
#import <NMapsMap/NMFMapViewOptionDelegate.h>

/**
 Real implementation of Naver Map View
 
 In old architecture, this is instantiated from `- (UIView *)view`.
 
 In new architecture, this is instantiated from `initWithFrame` of `RNCNaverMapView.mm`
 */
@interface RNCNaverMapViewImpl : NMFNaverMapView <NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate>

@property (nonatomic, assign) NMFMapType mapType;
@property (nonatomic, assign) BOOL isIndoorEnabled;
@property (nonatomic, assign) BOOL isNightModeEnabled;
@property (nonatomic, assign) BOOL isLiteModeEnabled;
@property (nonatomic, assign) NSNumber *lightness;
@property (nonatomic, assign) NSNumber *buildingHeight;
@property (nonatomic, assign) NSNumber *symbolScale;
@property (nonatomic, assign) NSNumber *symbolPerspectiveRatio;

@property (nonatomic, copy) RCTDirectEventBlock onInitialized;
@property (nonatomic, copy) RCTDirectEventBlock onOptionChanged;

@end
