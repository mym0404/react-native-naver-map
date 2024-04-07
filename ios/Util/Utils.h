#ifndef Utils_h
#define Utils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+ (UIColor *)hexToColor:(NSString*)stringToConvert;
+ (UIColor *)intToColor:(uint32_t)intToConvert;
@end

#endif /* Utils_h */
