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

static NSMutableSet<NSString*>* RNCNaverMapOpenInfoWindows(void) {
  static NSMutableSet<NSString*>* openInfoWindows;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    openInfoWindows = [NSMutableSet new];
  });
  return openInfoWindows;
}

static BOOL RNCNaverMapInfoWindowIsOpen(NMFInfoWindow* infoWindow) {
  return infoWindow.marker != nil || infoWindow.mapView != nil;
}

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setGlobalZIndex : (NSString*)type zIndex : (double)zIndex) {
  // TODO: Implement global z-index setting
}

RCT_EXPORT_METHOD(createInfoWindow : (NSString*)infoWindowId) {
  if (RNCNaverMapInfoWindows()[infoWindowId])
    return;

  NMFInfoWindow* infoWindow = [NMFInfoWindow new];
  NMFInfoWindowDefaultTextSource* dataSource = [NMFInfoWindowDefaultTextSource new];

  // Initialize with empty content
  dataSource.title = @"";
  infoWindow.dataSource = dataSource;

  RNCNaverMapInfoWindows()[infoWindowId] = infoWindow;
}

RCT_EXPORT_METHOD(destroyInfoWindow : (NSString*)infoWindowId) {
  NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
  if (infoWindow) {
    [infoWindow close];
    [RNCNaverMapInfoWindows() removeObjectForKey:infoWindowId];
    [RNCNaverMapInfoWindowContents() removeObjectForKey:infoWindowId];
    [RNCNaverMapOpenInfoWindows() removeObject:infoWindowId];
  }
}

RCT_EXPORT_METHOD(closeInfoWindow : (NSString*)infoWindowId) {
  NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
  if (infoWindow) {
    [infoWindow close];
    [RNCNaverMapOpenInfoWindows() removeObject:infoWindowId];
  }
}

RCT_EXPORT_METHOD(setInfoWindowContent : (NSString*)infoWindowId title : (NSString*)
                      title subtitle : (NSString*)subtitle) {
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

    // Update if already open
    if (RNCNaverMapInfoWindowIsOpen(infoWindow)) {
      [infoWindow invalidate];
    }
  }
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isInfoWindowOpen : (NSString*)infoWindowId) {
  NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
  return @(RNCNaverMapInfoWindowIsOpen(infoWindow));
}

// Helper methods for ViewManagers
+ (NMFInfoWindow*)getInfoWindow:(NSString*)infoWindowId {
  return RNCNaverMapInfoWindows()[infoWindowId];
}

+ (void)markAsOpen:(NSString*)infoWindowId {
  [RNCNaverMapOpenInfoWindows() addObject:infoWindowId];
}

+ (void)markAsClosed:(NSString*)infoWindowId {
  [RNCNaverMapOpenInfoWindows() removeObject:infoWindowId];
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
