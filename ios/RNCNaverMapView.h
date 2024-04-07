// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#ifndef NaverMapViewNativeComponent_h
#define NaverMapViewNativeComponent_h

#import <React/RCTViewComponentView.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <UIKit/UIKit.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

/**
   Extern Module only for New Architecture inherit `RCTViewComponentView`
 */
@interface RNCNaverMapView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* NaverMapViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
