#import "Utils.h"

@implementation Utils

+ (UIColor*)hexToColor:(NSString*)stringToConvert {
  NSString* noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#"
                                                                      withString:@""];
  NSScanner* stringScanner = [NSScanner scannerWithString:noHashString];

  unsigned hex;

  if (![stringScanner scanHexInt:&hex]) {
    [UIColor blackColor];
  }

  int r = (hex >> 16) & 0xFF;
  int g = (hex >> 8) & 0xFF;
  int b = (hex)&0xFF;

  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (UIColor*)intToColor:(uint32_t)intToConvert {
  float red = ((intToConvert & 0xFF0000) >> 16) / 255.0;
  float green = ((intToConvert & 0x00FF00) >> 8) / 255.0;
  float blue = (intToConvert & 0x0000FF) / 255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (id)alloc {
  [NSException raise:@"Cannot be instantiated!"
              format:@"Static class 'Utils' cannot be instantiated!"];
  return nil;
}

@end
