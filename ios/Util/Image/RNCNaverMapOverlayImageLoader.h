#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RNCNaverMapImageCanceller)(void);
typedef void (^RNCNaverMapUIImageHandler)(UIImage* _Nullable image, NSError* _Nullable error);

FOUNDATION_EXPORT RNCNaverMapImageCanceller
RNCNaverMapLoadUIImageWithUri(NSString* uriString, RNCNaverMapUIImageHandler completion);

NS_ASSUME_NONNULL_END
