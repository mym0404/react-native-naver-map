//
//  RNCNaverMapClusterKey.h
//  DoubleConversion
//
//  Created by mj on 4/18/24.
//

#import <Foundation/Foundation.h>
#import <NMapsMap/NMCClusteringKey.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapClusterKey : NSObject <NMCClusteringKey>

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NMGLatLng* position;

+ (instancetype)markerKeyWithIdentifier:(NSString*)identifier position:(NMGLatLng*)position;

@end

NS_ASSUME_NONNULL_END
