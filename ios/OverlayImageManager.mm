
#import "OverlayImageManager.h"

@implementation OverlayImageManager

+ (instancetype)sharedManager {
  static OverlayImageManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[OverlayImageManager alloc] init];
  });
  return sharedManager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    CGSize size = CGSizeMake(1, 1); // 최소 크기 이미지
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] setFill]; // 투명 색상 설정
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _transparentOverlayImage = [NMFOverlayImage overlayImageWithImage:transparentImage];
  }
  return self;
}

@end
