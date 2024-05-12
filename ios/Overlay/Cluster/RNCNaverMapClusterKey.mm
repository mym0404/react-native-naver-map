//
//  RNCNaverMapClusterKey.m
//  DoubleConversion
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapClusterKey.h"

@implementation RNCNaverMapClusterKey

+ (instancetype)
    markerKeyWithIdentifier:(NSString*)identifier
                   position:(NMGLatLng*)position
                     bridge:(RCTBridge*)bridge
                      image:
                          (facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct)image
                      width:(double)width
                     height:(double)height {
  return [[RNCNaverMapClusterKey alloc] initWithIdentifier:identifier
                                                  position:position
                                                    bridge:bridge
                                                     image:image
                                                     width:width
                                                    height:height];
}

- (instancetype)
    initWithIdentifier:(nonnull NSString*)identifier
              position:(nonnull NMGLatLng*)position
                bridge:(RCTBridge*)bridge
                 image:(facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct)image
                 width:(double)width
                height:(double)height {
  if (self = [super init]) {
    _identifier = identifier;
    _position = position;
    _bridge = bridge;
    _image = image;
    _width = width;
    _height = height;
  }

  return self;
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }

  if (object == nil || [self class] != [object class]) {
    return NO;
  }

  RNCNaverMapClusterKey* key = object;
  return [key.identifier isEqualToString:self.identifier];
}

- (NSUInteger)hash {
  return self.identifier.hash;
}

- (nonnull id)copyWithZone:(NSZone*)zone {
  return [[[self class] alloc] initWithIdentifier:[self.identifier copy]
                                         position:[self.position copy]
                                           bridge:self.bridge
                                            image:self.image
                                            width:self.width
                                           height:self.height];
}

@end
