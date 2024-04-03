#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapView.h"

#import <react/renderer/components/RNCNaverMapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapViewSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapViewSpec/Props.h>
#import <react/renderer/components/RNCNaverMapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"
#import "RNCNaverMapViewImpl.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTRNCNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
    RNCNaverMapViewImpl * _view;
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
        
        _view = [[RNCNaverMapViewImpl alloc] init];
        
        self.contentView = _view;
    }
    
    return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);
    
#define REMAP_PROP(name)                    \
if (oldViewProps.name != newViewProps.name) {   \
_view.name = newViewProps.name;             \
}
    
#define REMAP_STRING(name)                             \
if (oldViewProps.name != newViewProps.name) {                   \
_view.name = RCTNSStringFromString(newViewProps.name);      \
}
    
#define REMAP_DOUBLE(name)                             \
if (oldViewProps.name != newViewProps.name) {                   \
_view.name = [NSNumber numberWithDouble:newViewProps.name];      \
}
    
    if (oldViewProps.mapType != newViewProps.mapType) {
        if (newViewProps.mapType == RNCNaverMapViewMapType::Basic) {
            _view.mapType = NMFMapTypeBasic;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Navi){
            _view.mapType = NMFMapTypeNavi;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Satellite){
            _view.mapType = NMFMapTypeSatellite;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Hybrid){
            _view.mapType = NMFMapTypeHybrid;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Terrain){
            _view.mapType = NMFMapTypeTerrain;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::NaviHybrid){
            _view.mapType = NMFMapTypeNaviHybrid;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::None){
            _view.mapType = NMFMapTypeNone;
        }
    }
    
    REMAP_PROP(isIndoorEnabled)
    REMAP_PROP(isNightModeEnabled)
    REMAP_PROP(isLiteModeEnabled)
    REMAP_DOUBLE(lightness)
    REMAP_DOUBLE(buildingHeight)
    REMAP_DOUBLE(symbolScale)
    REMAP_DOUBLE(symbolPerspectiveRatio)
    
    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> RNCNaverMapViewCls(void)
{
    return RNCNaverMapView.class;
}

@end
#endif
