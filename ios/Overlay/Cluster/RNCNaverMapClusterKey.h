//
//  RNCNaverMapClusterKey.h
//  DoubleConversion
//
//  Created by mj on 4/18/24.
//

#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMapsGeometry.h>
#import <NMapsMap/NMapsMap.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>

typedef void (^OnTapLeafMarker)();

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapClusterKey : NSObject <NMCClusteringKey>

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NMGLatLng* position;
@property(nonatomic, assign)
    facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct image;
@property(nonatomic, assign) double width;
@property(nonatomic, assign) double height;
@property(nonatomic, nullable) OnTapLeafMarker onTapLeafMarker;

+ (instancetype)
    markerKeyWithIdentifier:(nonnull NSString*)identifier
                   position:(nonnull NMGLatLng*)position
                      image:
                          (facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct)image
                      width:(double)width
                     height:(double)height
            onTapLeafMarker:(OnTapLeafMarker _Nullable)onTapLeafMarerk;

@end

NS_ASSUME_NONNULL_END
