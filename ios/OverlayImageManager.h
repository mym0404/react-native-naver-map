
#import <Foundation/Foundation.h>
#import <NMapsMap/NMFOverlayImage.h>

@interface OverlayImageManager : NSObject

@property (nonatomic, strong, readonly) NMFOverlayImage *transparentOverlayImage;

+ (instancetype)sharedManager;

@end
