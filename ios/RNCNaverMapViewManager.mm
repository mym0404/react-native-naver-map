#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "Utils.h"
#import "RNCNaverMapView.h"
#import "RNCNaverMapViewImpl.h"

@interface RNCNaverMapViewManager : RCTViewManager
@end

@implementation RNCNaverMapViewManager

RCT_EXPORT_MODULE(RNCNaverMapView)

- (UIView *)view
{
  return [[RNCNaverMapViewImpl alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(isIndoorEnabled, BOOL)

@end
