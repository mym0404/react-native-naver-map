//
//  GetImageUtil.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 5/12/24.
//

#import "FnUtil.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTImageLoader.h>
#import <string>
#import <unordered_map>

typedef void (^RNCNaverMapImageCanceller)();
typedef void (^RNCNaverMapOverlayImageHandler)(NMFOverlayImage* _Nullable);

static std::unordered_map<std::string, NMFOverlayImage*> imageCache;

static RNCNaverMapImageCanceller _Nullable loadImageWith(
    RCTBridge* _Nonnull bridge, std::string uri, std::string cacheKey,
    RNCNaverMapOverlayImageHandler _Nonnull callback) {
  RCTImageLoader* _Nonnull imageLoader = [bridge moduleForClass:[RCTImageLoader class]];

  return
      [imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:getNsStr(uri)]
                                      size:CGSizeZero
                                     scale:RCTScreenScale()
                                   clipped:YES
                                resizeMode:RCTResizeModeCenter
                             progressBlock:nil
                          partialLoadBlock:nil
                           completionBlock:^(NSError* _Nullable error, UIImage* _Nullable image) {
                             if (error) {
                               NSLog(@"ERROR: %@", error);
                               // on error, set default
                               callback(NMF_MARKER_IMAGE_GREEN);
                             } else {
                               NMFOverlayImage* overlayImage =
                                   [NMFOverlayImage overlayImageWithImage:image
                                                          reuseIdentifier:getNsStr(cacheKey)];
                               callback(overlayImage);
                               imageCache[cacheKey] = overlayImage;
                             }
                           }];
}

namespace nmap {

template <IsImageProp T>
static RNCNaverMapImageCanceller _Nullable getImage(
    RCTBridge* _Nonnull bridge, const T& image, RNCNaverMapOverlayImageHandler _Nonnull callback) {

  if (image.symbol.size()) {
    if (image.symbol == "blue") {
      callback(NMF_MARKER_IMAGE_BLUE);
    } else if (image.symbol == "gray") {
      callback(NMF_MARKER_IMAGE_GRAY);
    } else if (image.symbol == "green") {
      callback(NMF_MARKER_IMAGE_GREEN);
    } else if (image.symbol == "lightblue") {
      callback(NMF_MARKER_IMAGE_LIGHTBLUE);
    } else if (image.symbol == "pink") {
      callback(NMF_MARKER_IMAGE_PINK);
    } else if (image.symbol == "red") {
      callback(NMF_MARKER_IMAGE_RED);
    } else if (image.symbol == "yellow") {
      callback(NMF_MARKER_IMAGE_YELLOW);
    } else if (image.symbol == "black") {
      callback(NMF_MARKER_IMAGE_BLACK);
    } else if (image.symbol == "lowDensityCluster") {
      callback(NMF_MARKER_IMAGE_CLUSTER_LOW_DENSITY);
    } else if (image.symbol == "mediumDensityCluster") {
      callback(NMF_MARKER_IMAGE_CLUSTER_MEDIUM_DENSITY);
    } else if (image.symbol == "highDensityCluster") {
      callback(NMF_MARKER_IMAGE_CLUSTER_HIGH_DENSITY);
    } else {
      callback(nil);
    }
    return ^{
    };
  }

  std::string rnAssetUri = image.rnAssetUri;
  std::string httpUri = image.httpUri;
  std::string assetName = image.assetName;
  std::string reuseIdentifier = image.reuseIdentifier;

  if (rnAssetUri.size() || httpUri.size()) {
    std::string uri = rnAssetUri.size() ? rnAssetUri : httpUri;
    std::string key = reuseIdentifier.size() ? reuseIdentifier : uri;
    if (imageCache.find(key) != imageCache.end()) {
      callback(imageCache[key]);
      return ^{
      };
    } else {
      return loadImageWith(bridge, uri, key, callback);
    }
  }

  if (assetName.size()) {
    std::string key = reuseIdentifier.size() ? reuseIdentifier : assetName;
    NMFOverlayImage* image = [NMFOverlayImage overlayImageWithName:getNsStr(assetName)
                                                   reuseIdentifier:getNsStr(key)];
    callback(image);
    return ^{
    };
  }

  callback(nil);
  return ^{
  };
}
} // namespace nmap
