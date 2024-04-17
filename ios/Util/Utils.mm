#import "Utils.h"

@implementation Utils
static NSMutableDictionary* imageCache;

+ (UIColor*)hexToColor:(NSString*)stringToConvert {
  NSString* noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#"
                                                                      withString:@""];
  NSScanner* stringScanner = [NSScanner scannerWithString:noHashString];

  unsigned hex;

  if (![stringScanner scanHexInt:&hex]) {
    [UIColor blackColor];
  }

  int a = (hex >> 24) & 0xFF;
  int r = (hex >> 16) & 0xFF;
  int g = (hex >> 8) & 0xFF;
  int b = (hex >> 0) & 0xFF;

  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255.0f];
}

+ (UIColor*)intToColor:(NSInteger)intToConvert {
  float alpha = ((intToConvert & 0xFF000000) >> 24) / 255.0;
  float red = ((intToConvert & 0xFF0000) >> 16) / 255.0;
  float green = ((intToConvert & 0x00FF00) >> 8) / 255.0;
  float blue = (intToConvert & 0x0000FF) / 255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)alloc {
  [NSException raise:@"Cannot be instantiated!"
              format:@"Static class 'Utils' cannot be instantiated!"];
  return nil;
}

+ (void (^)(void))getImage:(RCTBridge*)bridge
                      json:(NSDictionary*)json
                  callback:(void (^)(NMFOverlayImage*))callback {
  if (!imageCache) {
    imageCache = [NSMutableDictionary new];
  }

  if (!json) {
    callback(NMF_MARKER_IMAGE_GREEN);
    return ^{
    };
  }

  NSString* symbol = json[@"symbol"];
  if (isNotEmptyString(symbol)) {
    if ([symbol isEqualToString:@"blue"]) {
      callback(NMF_MARKER_IMAGE_BLUE);
    } else if ([symbol isEqualToString:@"gray"]) {
      callback(NMF_MARKER_IMAGE_GRAY);
    } else if ([symbol isEqualToString:@"green"]) {
      callback(NMF_MARKER_IMAGE_GREEN);
    } else if ([symbol isEqualToString:@"lightblue"]) {
      callback(NMF_MARKER_IMAGE_LIGHTBLUE);
    } else if ([symbol isEqualToString:@"pink"]) {
      callback(NMF_MARKER_IMAGE_PINK);
    } else if ([symbol isEqualToString:@"red"]) {
      callback(NMF_MARKER_IMAGE_RED);
    } else if ([symbol isEqualToString:@"yellow"]) {
      callback(NMF_MARKER_IMAGE_YELLOW);
    } else if ([symbol isEqualToString:@"black"]) {
      callback(NMF_MARKER_IMAGE_BLACK);
    } else if ([symbol isEqualToString:@"lowDensityCluster"]) {
      callback(NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY);
    } else if ([symbol isEqualToString:@"mediumDensityCluster"]) {
      callback(NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY);
    } else if ([symbol isEqualToString:@"highDensityCluster"]) {
      callback(NMF_MARKER_IMAGE_CLUSTER_HIGH_DENSITY);
    } else {
      callback(NMF_MARKER_IMAGE_GREEN);
    }
    return ^{
    };
  }

  NSString* rnAssetUri = json[@"rnAssetUri"];
  NSString* httpUri = json[@"httpUri"];
  NSString* assetName = json[@"assetName"];
  NSString* reuseIdentifier = json[@"reuseIdentifier"];

  if (isNotEmptyString(rnAssetUri) || isNotEmptyString(httpUri)) {
    NSString* uri = isNotEmptyString(rnAssetUri) ? rnAssetUri : httpUri;
    NSString* key = isNotEmptyString(reuseIdentifier) ? reuseIdentifier : uri;
    NMFOverlayImage* cache = [imageCache valueForKey:key];
    if (cache != nil) {
      callback(cache);
      return ^{
      };
    } else {
      return [self loadImageWith:bridge
                             uri:key
                        cacheKey:uri
                        callback:^(NMFOverlayImage* image) {
                          callback(image);
                        }];
    }
  }

  if (assetName) {
    NSString* key = isNotEmptyString(reuseIdentifier) ? reuseIdentifier : assetName;
    NMFOverlayImage* image = [NMFOverlayImage overlayImageWithName:assetName reuseIdentifier:key];
    callback(image);
    return ^{
    };
  }

  callback(NMF_MARKER_IMAGE_GREEN);
  return ^{
  };
}

+ (RCTImageLoaderCancellationBlock)loadImageWith:(nonnull RCTBridge*)bridge
                                             uri:(nonnull NSString*)uri
                                        cacheKey:(nonnull NSString*)cacheKey
                                        callback:(void (^)(NMFOverlayImage*))callback {
  RCTImageLoader* _Nonnull imageLoader = [bridge moduleForClass:[RCTImageLoader class]];

  return [imageLoader
      loadImageWithURLRequest:[RCTConvert NSURLRequest:uri]
                         size:CGSizeZero
                        scale:RCTScreenScale()
                      clipped:YES
                   resizeMode:RCTResizeModeCenter
                progressBlock:nil
             partialLoadBlock:nil
              completionBlock:^(NSError* _Nullable error, UIImage* _Nullable image) {
                if (error) {
                  NSLog(@"ERROR: %@", error);
                  // on error, set default
                  callback(NMF_MARKER_IMAGE_GREEN);
                } else {
                  NMFOverlayImage* overlayImage = [NMFOverlayImage overlayImageWithImage:image
                                                                         reuseIdentifier:cacheKey];
                  callback(overlayImage);
                  [imageCache setObject:overlayImage forKey:cacheKey];
                }
              }];
}

@end
