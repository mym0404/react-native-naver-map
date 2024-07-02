#ifndef NaverMapViewNativeComponent_h
#define NaverMapViewNativeComponent_h

#import <React/RCTViewComponentView.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <UIKit/UIKit.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>

#import "EasingAnimationUtil.h"
#import "FnUtil.h"
#import "RCTFabricComponentsPlugins.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

@interface RNCNaverMapView : RCTViewComponentView

- (std::shared_ptr<facebook::react::RNCNaverMapViewEventEmitter const>)emitter;

@end

#endif /* NaverMapViewNativeComponent_h */
