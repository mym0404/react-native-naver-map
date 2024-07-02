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
                      image:
                          (facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct)image
                      width:(double)width
                     height:(double)height
            onTapLeafMarker:(OnTapLeafMarker _Nullable)onTapLeafMarerk {
  return [[RNCNaverMapClusterKey alloc] initWithIdentifier:identifier
                                                  position:position
                                                     image:image
                                                     width:width
                                                    height:height
                                           onTapLeafMarker:onTapLeafMarerk];
}

- (instancetype)
    initWithIdentifier:(nonnull NSString*)identifier
              position:(nonnull NMGLatLng*)position
                 image:(facebook::react::RNCNaverMapViewClustersClustersMarkersImageStruct)image
                 width:(double)width
                height:(double)height
       onTapLeafMarker:(OnTapLeafMarker)onTapLeafMarker {
  if (self = [super init]) {
    _identifier = identifier;
    _position = position;
    _image = image;
    _width = width;
    _height = height;
    _onTapLeafMarker = onTapLeafMarker;
  }

  return self;
}

- (void)dealloc {
  _onTapLeafMarker = nil;
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
                                            image:self.image
                                            width:self.width
                                           height:self.height
                                  onTapLeafMarker:self.onTapLeafMarker];
}

@end
