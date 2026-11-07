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

#ifdef RCT_NEW_ARCH_ENABLED
@interface RNCNaverMapUtil ()

- (void)emitAuthFailure:(NSError*)error;

@end

@interface RNCNaverMapAuthCoordinator : NSObject <NMFAuthManagerDelegate>

@property(atomic, weak, nullable) id<NMFAuthManagerDelegate> previousDelegate;
@property(nonatomic, strong) NSHashTable<RNCNaverMapUtil*>* subscribers;

- (void)uninstallIfUnused;

@end

static RNCNaverMapAuthCoordinator* activeAuthCoordinator;

@implementation RNCNaverMapAuthCoordinator

- (instancetype)init {
  if (self = [super init]) {
    _subscribers = [NSHashTable weakObjectsHashTable];
  }
  return self;
}

- (void)uninstallIfUnused {
  // Weak slots can remain after release; allObjects counts only live modules.
  if (activeAuthCoordinator != self || self.subscribers.allObjects.count > 0)
    return;

  NMFAuthManager* authManager = [NMFAuthManager shared];
  if (authManager.delegate == self)
    authManager.delegate = self.previousDelegate;
  activeAuthCoordinator = nil;
}

- (void)authorized:(NMFAuthState)state error:(NSError*)error {
  id<NMFAuthManagerDelegate> previousDelegate = self.previousDelegate;
  [previousDelegate authorized:state error:error];

  if (state != NMFAuthStateUnauthorized || !error)
    return;

  runOnMainSync(^{
    [self uninstallIfUnused];
    if (activeAuthCoordinator != self)
      return;

    for (RNCNaverMapUtil* subscriber in self.subscribers)
      [subscriber emitAuthFailure:error];
  });
}

@end
#endif

@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (NSNumber*)startObservingAuthFailures {
  runOnMainSync(^{
    [activeAuthCoordinator uninstallIfUnused];
    NMFAuthManager* authManager = [NMFAuthManager shared];
    if (!activeAuthCoordinator) {
      activeAuthCoordinator = [RNCNaverMapAuthCoordinator new];
      activeAuthCoordinator.previousDelegate = authManager.delegate;
      authManager.delegate = activeAuthCoordinator;
    }

    [activeAuthCoordinator.subscribers addObject:self];
  });
  return @YES;
}

- (NSNumber*)stopObservingAuthFailures {
  runOnMainSync(^{
    RNCNaverMapAuthCoordinator* coordinator = activeAuthCoordinator;
    [coordinator.subscribers removeObject:self];
    [coordinator uninstallIfUnused];
  });
  return @YES;
}

- (void)emitAuthFailure:(NSError*)error {
  [self emitOnAuthFailed:@{
    @"code" : [NSString stringWithFormat:@"%ld", (long)error.code],
    @"message" : error.localizedDescription ?: @"",
  }];
}
#endif

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
#ifdef RCT_NEW_ARCH_ENABLED
  [self stopObservingAuthFailures];
#endif
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

+ (void)registerInfoWindow:(NMFInfoWindow*)infoWindow withIdentifier:(NSString*)infoWindowId {
  runOnMainSync(^{
    NMFInfoWindow* registeredInfoWindow = RNCNaverMapInfoWindows()[infoWindowId];
    if (registeredInfoWindow == infoWindow)
      return;

    [registeredInfoWindow close];
    RNCNaverMapInfoWindows()[infoWindowId] = infoWindow;
    [RNCNaverMapInfoWindowContents() removeObjectForKey:infoWindowId];
  });
}

+ (void)unregisterInfoWindow:(NMFInfoWindow*)infoWindow withIdentifier:(NSString*)infoWindowId {
  runOnMainSync(^{
    if (RNCNaverMapInfoWindows()[infoWindowId] != infoWindow)
      return;

    [infoWindow close];
    [RNCNaverMapInfoWindows() removeObjectForKey:infoWindowId];
    [RNCNaverMapInfoWindowContents() removeObjectForKey:infoWindowId];
  });
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
