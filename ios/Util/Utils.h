#ifndef Utils_h
#define Utils_h

#import "FnUtil.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMFMarker.h>
#import <NMapsMap/NMFOverlayImage.h>
#import <React/RCTBridge.h>
#import <React/RCTImageLoader.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+ (UIColor*)hexToColor:(NSString*)stringToConvert;
+ (UIColor*)intToColor:(NSInteger)intToConvert;
+ (void (^)(void))getImage:(RCTBridge*)bridge
                      json:(NSDictionary*)json
                  callback:(void (^)(NMFOverlayImage*))callback;
@end

#endif /* Utils_h */
