//
//  RNCNaverMapInfoWindow.mm
//  mj-studio-react-native-naver-map
//
//  Created by AI Assistant
//

#import "RNCNaverMapInfoWindow.h"
#import <React/RCTBridge+Private.h>

using namespace facebook::react;

@interface RNCNaverMapInfoWindow () <RCTRNCNaverMapInfoWindowViewProtocol>

@end

@implementation RNCNaverMapInfoWindow

- (RCTBridge*)bridge {
  return [RCTBridge currentBridge];
}

- (std::shared_ptr<RNCNaverMapInfoWindowEventEmitter const>)emitter {
  if (!_eventEmitter)
    return nullptr;
  return std::static_pointer_cast<RNCNaverMapInfoWindowEventEmitter const>(_eventEmitter);
}

- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFInfoWindow new];
  }

  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapInfoWindowProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(props);

  if (!nmap::isCoordEqual(prev.coord, next.coord))
    _inner.position = nmap::createLatLng(next.coord);

  if (prev.zIndexValue != next.zIndexValue)
    _inner.zIndex = next.zIndexValue;
  if (prev.globalZIndexValue != next.globalZIndexValue && isValidNumber(next.globalZIndexValue))
    _inner.globalZIndex = next.globalZIndexValue;
  if (prev.isHidden != next.isHidden)
    _inner.hidden = next.isHidden;
  if (prev.minZoom != next.minZoom)
    _inner.minZoom = next.minZoom;
  if (prev.maxZoom != next.maxZoom)
    _inner.maxZoom = next.maxZoom;
  if (prev.isMinZoomInclusive != next.isMinZoomInclusive)
    _inner.isMinZoomInclusive = next.isMinZoomInclusive;
  if (prev.isMaxZoomInclusive != next.isMaxZoomInclusive)
    _inner.isMaxZoomInclusive = next.isMaxZoomInclusive;

  if (!nmap::isAnchorEqual(prev.anchor, next.anchor))
    _inner.anchor = nmap::createAnchorCGPoint(next.anchor);

  if (prev.offsetX != next.offsetX)
    _inner.offsetX = next.offsetX;
  if (prev.offsetY != next.offsetY)
    _inner.offsetY = next.offsetY;

  if (prev.alpha != next.alpha)
    _inner.alpha = next.alpha;

  // Text content and styling
  if (prev.text != next.text) {
    NSString* text = getNsStr(next.text);
    
    // Create a simple attributed string with styling
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIColor* textColor = nmap::intToColor(next.textColor);
    UIColor* bgColor = nmap::intToColor(next.infoWindowBackgroundColor);
    CGFloat textSize = next.textSize;
    
    NSDictionary* attributes = @{
      NSFontAttributeName : [UIFont systemFontOfSize:textSize],
      NSForegroundColorAttributeName : textColor,
      NSBackgroundColorAttributeName : bgColor,
      NSParagraphStyleAttributeName : paragraphStyle
    };
    
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    // Create a label to display the text
    UILabel* label = [[UILabel alloc] init];
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    // Add padding
    CGSize textSize_size = [attributedText size];
    CGFloat padding = 10.0;
    label.frame = CGRectMake(0, 0, textSize_size.width + padding * 2, textSize_size.height + padding * 2);
    
    // Set rounded corners and border
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1.0;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Create a custom view adapter
    _inner.dataSource = ^UIView* _Nullable(NMFInfoWindow* infoWindow) {
      return label;
    };
  }

  // Update colors and sizes even if text didn't change
  if (prev.textColor != next.textColor || prev.infoWindowBackgroundColor != next.infoWindowBackgroundColor ||
      prev.textSize != next.textSize) {
    // Trigger update by re-setting the text
    if (next.text.length() > 0) {
      NSString* text = getNsStr(next.text);
      
      NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.alignment = NSTextAlignmentCenter;
      
      UIColor* textColor = nmap::intToColor(next.textColor);
      UIColor* bgColor = nmap::intToColor(next.infoWindowBackgroundColor);
      CGFloat textSize = next.textSize;
      
      NSDictionary* attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:textSize],
        NSForegroundColorAttributeName : textColor,
        NSBackgroundColorAttributeName : bgColor,
        NSParagraphStyleAttributeName : paragraphStyle
      };
      
      NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
      
      UILabel* label = [[UILabel alloc] init];
      label.attributedText = attributedText;
      label.numberOfLines = 0;
      label.textAlignment = NSTextAlignmentCenter;
      
      CGSize textSize_size = [attributedText size];
      CGFloat padding = 10.0;
      label.frame = CGRectMake(0, 0, textSize_size.width + padding * 2, textSize_size.height + padding * 2);
      
      label.layer.cornerRadius = 5.0;
      label.layer.masksToBounds = YES;
      label.layer.borderWidth = 1.0;
      label.layer.borderColor = [UIColor lightGrayColor].CGColor;
      
      _inner.dataSource = ^UIView* _Nullable(NMFInfoWindow* infoWindow) {
        return label;
      };
    }
  }

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapInfoWindowCls(void) {
  return RNCNaverMapInfoWindow.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapInfoWindowComponentDescriptor>();
}

@end

