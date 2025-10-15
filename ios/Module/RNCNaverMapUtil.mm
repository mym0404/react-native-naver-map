//
//  RNCNaverMapUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import "RNCNaverMapUtil.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge+Private.h>

@interface RNCNaverMapUtil ()
@property(nonatomic, strong) NSMutableDictionary<NSString*, NMFInfoWindow*>* infoWindows;
@property(nonatomic, strong) NSMutableDictionary<NSString*, NSDictionary*>* infoWindowContents;
@property(nonatomic, strong) NSMutableSet<NSString*>* openInfoWindows;
@end

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

- (instancetype)init {
  if (self = [super init]) {
    _infoWindows = [NSMutableDictionary new];
    _infoWindowContents = [NSMutableDictionary new];
    _openInfoWindows = [NSMutableSet new];
  }
  return self;
}

RCT_EXPORT_METHOD(setGlobalZIndex : (NSString*)type zIndex : (double)zIndex) {
  // TODO: Implement global z-index setting
}

RCT_EXPORT_METHOD(createInfoWindow : (NSString*)infoWindowId) {
  if (_infoWindows[infoWindowId])
    return;

  NMFInfoWindow* infoWindow = [NMFInfoWindow new];
  NMFInfoWindowDefaultTextSource* dataSource = [NMFInfoWindowDefaultTextSource new];

  // Initialize with empty content
  dataSource.title = @"";
  infoWindow.dataSource = dataSource;

  _infoWindows[infoWindowId] = infoWindow;
}

RCT_EXPORT_METHOD(destroyInfoWindow : (NSString*)infoWindowId) {
  NMFInfoWindow* infoWindow = _infoWindows[infoWindowId];
  if (infoWindow) {
    [infoWindow close];
    [_infoWindows removeObjectForKey:infoWindowId];
    [_infoWindowContents removeObjectForKey:infoWindowId];
    [_openInfoWindows removeObject:infoWindowId];
  }
}

RCT_EXPORT_METHOD(closeInfoWindow : (NSString*)infoWindowId) {
  NMFInfoWindow* infoWindow = _infoWindows[infoWindowId];
  if (infoWindow) {
    [infoWindow close];
    [_openInfoWindows removeObject:infoWindowId];
  }
}

RCT_EXPORT_METHOD(setInfoWindowContent : (NSString*)infoWindowId title : (NSString*)
                      title subtitle : (NSString* _Nullable)subtitle) {
  _infoWindowContents[infoWindowId] = @{@"title" : title ?: @"", @"subtitle" : subtitle ?: @""};

  NMFInfoWindow* infoWindow = _infoWindows[infoWindowId];
  if (infoWindow && infoWindow.dataSource) {
    NMFInfoWindowDefaultTextSource* dataSource =
        (NMFInfoWindowDefaultTextSource*)infoWindow.dataSource;

    if (subtitle && subtitle.length > 0) {
      dataSource.title = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
    } else {
      dataSource.title = title;
    }

    // Update if already open
    if ([_openInfoWindows containsObject:infoWindowId]) {
      [infoWindow invalidate];
    }
  }
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isInfoWindowOpen : (NSString*)infoWindowId) {
  return @([_openInfoWindows containsObject:infoWindowId]);
}

// Helper methods for ViewManagers
- (NMFInfoWindow*)getInfoWindow:(NSString*)infoWindowId {
  return _infoWindows[infoWindowId];
}

- (void)markAsOpen:(NSString*)infoWindowId {
  [_openInfoWindows addObject:infoWindowId];
}

- (void)markAsClosed:(NSString*)infoWindowId {
  [_openInfoWindows removeObject:infoWindowId];
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
