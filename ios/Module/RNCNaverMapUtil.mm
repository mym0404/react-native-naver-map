//
//  RNCNaverMapUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import "RNCNaverMapUtil.h"
#import <Foundation/Foundation.h>

static NSMutableDictionary<NSString*, NMFInfoWindow*>* RNCNaverMapInfoWindows(void) {
  static NSMutableDictionary<NSString*, NMFInfoWindow*>* infoWindows;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    infoWindows = [NSMutableDictionary new];
  });
  return infoWindows;
}

static NSMutableDictionary<NSString*, NSDictionary*>* RNCNaverMapInfoWindowContents(void) {
  static NSMutableDictionary<NSString*, NSDictionary*>* infoWindowContents;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    infoWindowContents = [NSMutableDictionary new];
  });
  return infoWindowContents;
}

static BOOL RNCNaverMapInfoWindowIsOpen(NMFInfoWindow* infoWindow) {
  return infoWindow.marker != nil || infoWindow.mapView != nil;
}

static void RNCNaverMapRunOnMainSync(dispatch_block_t block) {
  if (NSThread.isMainThread) {
    block();
    return;
  }

  dispatch_sync(dispatch_get_main_queue(), block);
}

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

- (void)createInfoWindow:(NSString*)infoWindowId {
  RNCNaverMapRunOnMainSync(^{
    if (RNCNaverMapInfoWindows()[infoWindowId])
      return;

    NMFInfoWindow* infoWindow = [NMFInfoWindow new];
    NMFInfoWindowDefaultTextSource* dataSource = [NMFInfoWindowDefaultTextSource dataSource];

    dataSource.title = @"";
    infoWindow.dataSource = dataSource;

    RNCNaverMapInfoWindows()[infoWindowId] = infoWindow;
  });
}

- (void)destroyInfoWindow:(NSString*)infoWindowId {
  RNCNaverMapRunOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow) {
      [infoWindow close];
      [RNCNaverMapInfoWindows() removeObjectForKey:infoWindowId];
      [RNCNaverMapInfoWindowContents() removeObjectForKey:infoWindowId];
    }
  });
}

- (void)closeInfoWindow:(NSString*)infoWindowId {
  RNCNaverMapRunOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow) {
      [infoWindow close];
    }
  });
}

- (void)setInfoWindowContent:(NSString*)infoWindowId
                       title:(NSString*)title
                    subtitle:(NSString*)subtitle {
  RNCNaverMapRunOnMainSync(^{
    RNCNaverMapInfoWindowContents()[infoWindowId] =
        @{@"title" : title ?: @"", @"subtitle" : subtitle ?: @""};

    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow && infoWindow.dataSource) {
      NMFInfoWindowDefaultTextSource* dataSource =
          (NMFInfoWindowDefaultTextSource*)infoWindow.dataSource;

      if (subtitle && subtitle.length > 0) {
        dataSource.title = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
      } else {
        dataSource.title = title;
      }

      if (RNCNaverMapInfoWindowIsOpen(infoWindow)) {
        [infoWindow invalidate];
      }
    }
  });
}

- (NSNumber*)isInfoWindowOpen:(NSString*)infoWindowId {
  __block BOOL isOpen = NO;
  RNCNaverMapRunOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    isOpen = RNCNaverMapInfoWindowIsOpen(infoWindow);
  });
  return @(isOpen);
}

- (void)invalidate {
  RNCNaverMapRunOnMainSync(^{
    for (NMFInfoWindow* infoWindow in RNCNaverMapInfoWindows().allValues) {
      [infoWindow close];
    }
    [RNCNaverMapInfoWindows() removeAllObjects];
    [RNCNaverMapInfoWindowContents() removeAllObjects];
  });
}

+ (NMFInfoWindow*)getInfoWindow:(NSString*)infoWindowId {
  return RNCNaverMapInfoWindows()[infoWindowId];
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
