//
//  RNCNaverMapMarker.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "ColorUtil.h"
#import "FnUtil.h"
#import "ImageUtil.h"
#import "MacroUtil.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTImageLoader.h>
#import <React/RCTImageLoaderProtocol.h>
#import <React/RCTUtils.h>
#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <UIKit/UIKit.h>

#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <React/UIView+ComponentViewProtocol.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>
#import <react/renderer/components/RNCNaverMapSpec/RCTComponentViewHelpers.h>
@interface RNCNaverMapMarker : RCTViewComponentView
@property(nonatomic, strong) NMFMarker* inner;
@property(nonatomic, assign) facebook::react::RNCNaverMapMarkerImageStruct image;
@end
