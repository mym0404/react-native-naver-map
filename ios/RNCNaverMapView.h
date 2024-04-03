// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef NaverMapViewNativeComponent_h
#define NaverMapViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

/**
   Extern Module only for New Architecture inherit `RCTViewComponentView`
 */
@interface RNCNaverMapView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* NaverMapViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
