//
//  RNCNaverMapRect.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/5/24.
//

#ifndef RNCNaverMapRect_h
#define RNCNaverMapRect_h

#import <Foundation/Foundation.h>
#import <NMapsGeometry/NMGLatLngBounds.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapRect : NSObject

@property(nonatomic, assign) double top;
@property(nonatomic, assign) double right;
@property(nonatomic, assign) double bottom;
@property(nonatomic, assign) double left;

- (instancetype)init:(double)top right:(double)right bottom:(double)bottom left:(double)left;

- (UIEdgeInsets)convertToUIEdgeInsets;

@end

static inline RNCNaverMapRect* _Nonnull RNCNaverMapRectMake(double top, double right, double bottom,
                                                            double left) {
  return [[RNCNaverMapRect alloc] init:top right:right bottom:bottom left:left];
}

NS_ASSUME_NONNULL_END

#endif /* ifndef RNCNaverMapRect_h */
