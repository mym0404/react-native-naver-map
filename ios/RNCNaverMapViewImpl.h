//
//  RNCNaverMapViewImpl.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#ifndef RNCNaverMapViewImpl_h
#define RNCNaverMapViewImpl_h

#import "FnUtil.h"
#import "MacroUtil.h"
#import "RNCNaverMapArrowheadPath.h"
#import "RNCNaverMapCircle.h"
#import "RNCNaverMapClusterKey.h"
#import "RNCNaverMapClusterMarkerUpdater.h"
#import "RNCNaverMapGround.h"
#import "RNCNaverMapLeafMarkerUpdater.h"
#import "RNCNaverMapMarker.h"
#import "RNCNaverMapPath.h"
#import "RNCNaverMapPolygon.h"
#import "RNCNaverMapPolyline.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
using namespace facebook::react;

@class RNCNaverMapView;

@interface RNCNaverMapViewImpl
    : NMFNaverMapView <NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate>

@property(nonatomic, weak) RNCNaverMapView* rncParent;
@property(nonatomic, copy) NSDictionary* camera;
@property(nonatomic, copy) NSDictionary* initialCamera;
@property(nonatomic, copy) NMGLatLngBounds* region;
@property(nonatomic, copy) NMGLatLngBounds* initialRegion;
@property(nonatomic, assign) NSInteger animationDuration;
@property(nonatomic, assign) NSInteger animationEasing;

@end

#endif /* ifndef RNCNaverMapViewImpl_h */
