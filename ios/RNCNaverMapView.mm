#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapView.h"

#import <react/renderer/components/RNCNaverMapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapViewSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapViewSpec/Props.h>
#import <react/renderer/components/RNCNaverMapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTRNCNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<RNCNaverMapViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);
  
//    if (oldViewProps.color != newViewProps.color) {
//        NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
//        [_view setBackgroundColor: [Utils hexStringToColor:colorToConvert]];
//    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapViewCls(void)
{
    return RNCNaverMapView.class;
}

@end
#endif
