---
keywords: ios, turbo-module, objective-c, bridge, react-native
language: objc
explanation: iOS TurboModule implementation with conditional Bridge/TurboModule support
---

# iOS TurboModule Implementation

## Usage

### Header File
```objc
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapSpec.h"
@interface RNCNaverMapUtil : NSObject <NativeRNCNaverMapUtilSpec>
#else
#import <React/RCTBridgeModule.h>
@interface RNCNaverMapUtil : NSObject <RCTBridgeModule>
#endif
```

### Implementation
```objc
@implementation RNCNaverMapUtil

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams&)params {
  return std::make_shared<facebook::react::NativeRNCNaverMapUtilSpecJSI>(params);
}
#endif

- (void)setGlobalZIndex:(NSString *)type zIndex:(double)zIndex {
  // Implementation
}

@end
```