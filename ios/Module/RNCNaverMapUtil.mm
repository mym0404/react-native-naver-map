//
//  RNCNaverMapUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/10/24.
//

#import "RNCNaverMapUtil.h"
#import "FnUtil.h"
#import <Foundation/Foundation.h>

static NSMutableDictionary<NSString*, NMFInfoWindow*>* RNCNaverMapInfoWindows(void) {
  static NSMutableDictionary<NSString*, NMFInfoWindow*>* infoWindows;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    infoWindows = [NSMutableDictionary new];
  });
  return infoWindows;
}

static NSMutableDictionary<NSString*, NSString*>* RNCNaverMapInfoWindowContents(void) {
  static NSMutableDictionary<NSString*, NSString*>* infoWindowContents;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    infoWindowContents = [NSMutableDictionary new];
  });
  return infoWindowContents;
}

static BOOL RNCNaverMapInfoWindowIsOpen(NMFInfoWindow* infoWindow) {
  return infoWindow.marker != nil || infoWindow.mapView != nil;
}

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

- (void)createInfoWindow:(NSString*)infoWindowId {
  runOnMainSync(^{
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
  runOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow) {
      [infoWindow close];
      [RNCNaverMapInfoWindows() removeObjectForKey:infoWindowId];
      [RNCNaverMapInfoWindowContents() removeObjectForKey:infoWindowId];
    }
  });
}

- (void)closeInfoWindow:(NSString*)infoWindowId {
  runOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow) {
      [infoWindow close];
    }
  });
}

- (void)setInfoWindowContent:(NSString*)infoWindowId text:(NSString*)text {
  runOnMainSync(^{
    RNCNaverMapInfoWindowContents()[infoWindowId] = text ?: @"";

    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow && infoWindow.dataSource) {
      NMFInfoWindowDefaultTextSource* dataSource =
          (NMFInfoWindowDefaultTextSource*)infoWindow.dataSource;

      dataSource.title = text ?: @"";

      if (RNCNaverMapInfoWindowIsOpen(infoWindow)) {
        [infoWindow invalidate];
      }
    }
  });
}

- (void)setInfoWindowOptions:(NSString*)infoWindowId
                     anchorX:(double)anchorX
                     anchorY:(double)anchorY
                     offsetX:(double)offsetX
                     offsetY:(double)offsetY
                       alpha:(double)alpha {
  runOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (infoWindow) {
      infoWindow.anchor = CGPointMake(anchorX, anchorY);
      infoWindow.offsetX = offsetX;
      infoWindow.offsetY = offsetY;
      infoWindow.alpha = alpha;
    }
  });
}

- (NSNumber*)isInfoWindowOpen:(NSString*)infoWindowId {
  __block BOOL isOpen = NO;
  runOnMainSync(^{
    NMFInfoWindow* infoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    isOpen = RNCNaverMapInfoWindowIsOpen(infoWindow);
  });
  return @(isOpen);
}

- (void)invalidate {
  runOnMainSync(^{
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

+ (void)closeInfoWindowsForMapView:(NMFMapView*)mapView {
  if (!mapView) {
    return;
  }

  runOnMainSync(^{
    for (NMFInfoWindow* infoWindow in RNCNaverMapInfoWindows().allValues) {
      if (infoWindow.mapView == mapView || infoWindow.marker.mapView == mapView) {
        [infoWindow close];
      }
    }
  });
}

+ (void)closeInfoWindowsForMarker:(NMFMarker*)marker {
  if (!marker) {
    return;
  }

  runOnMainSync(^{
    for (NMFInfoWindow* infoWindow in RNCNaverMapInfoWindows().allValues) {
      if (infoWindow.marker == marker) {
        [infoWindow close];
      }
    }
  });
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

@end
