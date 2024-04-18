//
//  RNCNaverMapClusterKey.m
//  DoubleConversion
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapClusterKey.h"

@implementation RNCNaverMapClusterKey

+ (instancetype)markerKeyWithIdentifier:(NSString*)identifier position:(NMGLatLng*)position {
  return [[RNCNaverMapClusterKey alloc] initWithIdentifier:identifier position:position];
}

- (instancetype)initWithIdentifier:(NSString*)identifier position:(NMGLatLng*)position {
  if (self = [super init]) {
    _identifier = identifier;
    _position = position;
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
  return [[[self class] alloc] initWithIdentifier:self.identifier position:self.position];
}

@end
