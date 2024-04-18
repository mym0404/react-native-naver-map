//
//  RNCNaverMapLeafMarkerUpdater.h
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/18/24.
//

#import "RNCNaverMapClusterKey.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMCClusterer.h>
#import <NMapsMap/NMCDefaultLeafMarkerUpdater.h>
#import <NMapsMap/NMCLeafMarkerInfo.h>
#import <NMapsMap/NMFMarker.h>
#import <NMapsMap/NMFOverlayImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCNaverMapLeafMarkerUpdater : NMCDefaultLeafMarkerUpdater
@property(nonatomic, weak, nullable) NMCClusterer* clusterer;
@end

NS_ASSUME_NONNULL_END
