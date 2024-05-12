//
//  RNCNaverMapLeafMarkerUpdater.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//

#import "FnUtil.h"
#import "ImageUtil.h"
#import "RNCNaverMapClusterKey.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapLeafMarkerUpdater : NMCDefaultLeafMarkerUpdater
@property(nonatomic, weak, nullable) NMCClusterer* clusterer;

- init:(std::unordered_map<std::string, RNCNaverMapImageCanceller>*)markerImageRequestCanceler;
@end

NS_ASSUME_NONNULL_END
