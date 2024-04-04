//
//  RNCNaverMapRect.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/5/24.
//

#import "RNCNaverMapRect.h"

@implementation  RNCNaverMapRect

- (nonnull instancetype)init:(double)top right:(double)right bottom:(double)bottom left:(double)left {
    self = [super init];

    if (self) {
        _top = top;
        _right = right;
        _bottom = bottom;
        _left = left;
    }

    return self;
}

- (UIEdgeInsets)convertToUIEdgeInsets {
    return UIEdgeInsetsMake(_top, _left, _bottom, _right);
}

@end
