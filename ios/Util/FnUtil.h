//
//  FnUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/3/24.
//
#ifndef FnUtil_h
#define FnUtil_h
#import "string"

static inline BOOL isValidNumber(NSNumber* value) {
  if (!value || [value isKindOfClass:[NSNull class]]) {
    return false;
  }

  double INVALID = -123123123.0;

  if ([value doubleValue]<INVALID + 1 && [value doubleValue]> INVALID - 1) {
    return false;
  }

  return true;
}

static inline BOOL isValidNumber(double value) {
  return isValidNumber([NSNumber numberWithDouble:value]);
}

static inline NSNumber* getNumberOrNil(NSNumber* value) {
  if (!isValidNumber(value)) {
    return nil;
  }

  return value;
}

static inline double getDoubleOrDefault(NSNumber* value, double def) {
  if (!isValidNumber(value)) {
    return def;
  }

  return [value doubleValue];
}

static inline double getDoubleOrDefault(double value, double def) {
  if (!isValidNumber(value)) {
    return def;
  }

  return value;
}

static inline NSString* getNsStr(std::string str) {
  return [NSString stringWithUTF8String:str.c_str()];
}

#endif /* ifndef FnUtil_h */
