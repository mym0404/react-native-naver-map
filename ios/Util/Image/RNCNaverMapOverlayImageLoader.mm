#import "RNCNaverMapOverlayImageLoader.h"
#import "FnUtil.h"

static NSString* const RNCNaverMapOverlayImageLoaderErrorDomain =
    @"RNCNaverMapOverlayImageLoaderErrorDomain";

typedef NS_ENUM(NSInteger, RNCNaverMapOverlayImageLoaderErrorCode) {
  RNCNaverMapOverlayImageLoaderErrorCodeDecodeFailed = 1,
};

static RNCNaverMapImageCanceller RNCNaverMapNoopCanceller(void) {
  return ^{
  };
}

static NSError* RNCNaverMapOverlayImageLoaderError(NSString* description) {
  return [NSError errorWithDomain:RNCNaverMapOverlayImageLoaderErrorDomain
                             code:RNCNaverMapOverlayImageLoaderErrorCodeDecodeFailed
                         userInfo:@{NSLocalizedDescriptionKey : description}];
}

RNCNaverMapImageCanceller RNCNaverMapLoadUIImageWithUri(NSString* uriString,
                                                        RNCNaverMapUIImageHandler completion) {
  NSURL* url = [NSURL URLWithString:uriString];
  if (!url || url.scheme.length == 0) {
    UIImage* image = [UIImage imageNamed:uriString];
    runOnMain(^{
      completion(image, nil);
    });
    return RNCNaverMapNoopCanceller();
  }

  if (url.fileURL) {
    __block BOOL isCancelled = NO;
    runOnBackground(^{
      if (isCancelled) {
        return;
      }

      NSError* error = nil;
      NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
      if (isCancelled) {
        return;
      }

      UIImage* image =
          data.length ? [UIImage imageWithData:data scale:UIScreen.mainScreen.scale] : nil;
      if (!image && !error) {
        error = RNCNaverMapOverlayImageLoaderError(@"Failed to decode image");
      }

      if (isCancelled) {
        return;
      }

      runOnMain(^{
        completion(image, error);
      });
    });

    return ^{
      isCancelled = YES;
    };
  }

  NSURLRequest* request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:30];
  NSURLSessionDataTask* task = [[NSURLSession sharedSession]
      dataTaskWithRequest:request
        completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response,
                            NSError* _Nullable error) {
          if (error) {
            if (error.code == NSURLErrorCancelled) {
              return;
            }
            runOnMain(^{
              completion(nil, error);
            });
            return;
          }

          UIImage* image =
              data.length ? [UIImage imageWithData:data scale:UIScreen.mainScreen.scale] : nil;
          NSError* imageError = nil;
          if (!image) {
            imageError = RNCNaverMapOverlayImageLoaderError(@"Failed to decode image");
          }

          runOnMain(^{
            completion(image, imageError);
          });
        }];
  [task resume];

  return ^{
    [task cancel];
  };
}
