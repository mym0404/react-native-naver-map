#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "Utils.h"

@interface RNCNaverMapViewManager : RCTViewManager
@end

@implementation RNCNaverMapViewManager

RCT_EXPORT_MODULE(RNCNaverMapView)

- (UIView *)view
{
  return [[UIView alloc] init];
}


@end
