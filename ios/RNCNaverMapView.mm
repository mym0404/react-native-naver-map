#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapView.h"

#import <react/renderer/components/RNNaverMapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNNaverMapViewSpec/EventEmitters.h>
#import <react/renderer/components/RNNaverMapViewSpec/Props.h>
#import <react/renderer/components/RNNaverMapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<NaverMapViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const NaverMapViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<NaverMapViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<NaverMapViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
        NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
        [_view setBackgroundColor: [Utils hexStringToColor:colorToConvert]];
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> NaverMapViewCls(void)
{
    return RNCNaverMapView.class;
}

@end
#endif
