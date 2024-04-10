//
//  RNCNaverMapMarkerManager.m
//  mj-studio-react-native-naver-map
//
//  Created by mj on 4/6/24.
//

#import "RNCNaverMapMarkerManager.h"

@implementation RNCNaverMapMarkerManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView*)view {
  auto marker = [RNCNaverMapMarker new];
  marker.bridge = self.bridge;
  return marker;
}
#endif

// MARK: - COMMON PROPS
RCT_EXPORT_VIEW_PROPERTY(position, NMGLatLng)
RCT_EXPORT_VIEW_PROPERTY(zIndexValue, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(isHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minZoom, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoom, double)
RCT_EXPORT_VIEW_PROPERTY(isMinZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isMaxZoomInclusive, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onTapOverlay, RCTDirectEventBlock)

// MARK: - MARKER PROPS
RCT_EXPORT_VIEW_PROPERTY(width, double)
RCT_EXPORT_VIEW_PROPERTY(height, double)
RCT_EXPORT_VIEW_PROPERTY(anchor, CGPoint)
RCT_EXPORT_VIEW_PROPERTY(angle, double)
RCT_EXPORT_VIEW_PROPERTY(isFlatEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isIconPerspectiveEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(alpha, double)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedSymbols, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedMarkers, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHideCollidedCaptions, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isForceShowIcon, BOOL)
RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(image, NSString)

// RCT_CUSTOM_VIEW_PROPERTY(caption, NSDictionary, RNCNaverMapMarker) {
//   NSDictionary* dic = [RCTConvert NSDictionary:json];
//   NSString* text = [RCTConvert NSString:dic[@"text"]];
//   CGFloat textSize = [RCTConvert CGFloat:dic[@"textSize"]];
//   UIColor* color = [RCTConvert UIColor:dic[@"color"]];
//   UIColor* haloColor = [RCTConvert UIColor:dic[@"haloColor"]];
//   CGFloat offset = [RCTConvert CGFloat:dic[@"offset"]];
//   CGFloat requestedWidth = [RCTConvert CGFloat:dic[@"requestedWidth"]];
//   double minZoom = dic[@"minZoom"] ? [RCTConvert double:dic[@"minZoom"]] : NMF_MIN_ZOOM;
//   double maxZoom = dic[@"maxZoom"] ? [RCTConvert double:dic[@"maxZoom"]] : NMF_MAX_ZOOM;
//   NMFAlignType* align = [RCTConvert NMFAlignType:dic[@"align"]];
//   NSMutableArray<NMFAlignType*>* alignTypes = [NSMutableArray arrayWithCapacity:1];
//
//   [alignTypes addObject:align];
//   [view setCaptionText:text];
//   [view setCaptionTextSize:textSize];
//   [view setCaptionColor:color];
//   [view setCaptionHaloColor:haloColor];
//   [view setCaptionOffset:offset];
//   [view setCaptionRequestedWidth:requestedWidth];
//   [view setCaptionMinZoom:minZoom];
//   [view setCaptionMaxZoom:maxZoom];
//   [view setCaptionAligns:alignTypes];
// }
//
// RCT_CUSTOM_VIEW_PROPERTY(subCaption, NSDictionary, RNCNaverMapMarker) {
//   NSDictionary* dic = [RCTConvert NSDictionary:json];
//   NSString* text = [RCTConvert NSString:dic[@"text"]];
//   CGFloat textSize = [RCTConvert CGFloat:dic[@"textSize"]];
//   UIColor* color = [RCTConvert UIColor:dic[@"color"]];
//   UIColor* haloColor = [RCTConvert UIColor:dic[@"haloColor"]];
//   CGFloat requestedWidth = [RCTConvert CGFloat:dic[@"requestedWidth"]];
//   double minZoom = dic[@"minZoom"] ? [RCTConvert double:dic[@"minZoom"]] : NMF_MIN_ZOOM;
//   double maxZoom = dic[@"maxZoom"] ? [RCTConvert double:dic[@"maxZoom"]] : NMF_MAX_ZOOM;
//
//   [view setSubCaptionText:text];
//   [view setSubCaptionTextSize:textSize];
//   [view setSubCaptionColor:color];
//   [view setSubCaptionHaloColor:haloColor];
//   [view setSubCaptionRequestedWidth:requestedWidth];
//   [view setSubCaptionMinZoom:minZoom];
//   [view setSubCaptionMaxZoom:maxZoom];
// }

@end
