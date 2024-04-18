//
//  RNCNaverMapClusterKey.h
//  DoubleConversion
//
//  Created by mj on 4/18/24.
//

#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMGLatLng.h>
#import <NMapsMap/NMCClusteringKey.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapClusterKey : NSObject <NMCClusteringKey>

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NMGLatLng* position;
@property(nonatomic, weak) RCTBridge* bridge;
@property(nonatomic, strong) NSDictionary* image;

+ (instancetype)markerKeyWithIdentifier:(nonnull NSString*)identifier
                               position:(nonnull NMGLatLng*)position
                                 bridge:(RCTBridge*)bridge
                                  image:(nonnull NSDictionary*)image;

@end

NS_ASSUME_NONNULL_END
