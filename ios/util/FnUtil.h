//
//  FnUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//

#import <Foundation/Foundation.h>



BOOL isValidNumber(NSNumber *value) {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return false;
    }
    double INVALID = -123123123.0;

    if ([value doubleValue] < INVALID + 1 &&
        [value doubleValue] > INVALID - 1) {
        return false;
    }

    return true;
}


NSNumber * getNumberOrNil(NSNumber *value) {
    if (!isValidNumber(value)) {
        return nil;
    }

    return value;
}

double getDoubleOrZero(NSNumber *value) {
    if (!isValidNumber(value)) {
        return 0.0;
    }
    
    return [value doubleValue];
}
