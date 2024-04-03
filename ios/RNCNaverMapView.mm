#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCNaverMapView.h"

#import <react/renderer/components/RNCNaverMapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapViewSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapViewSpec/Props.h>
#import <react/renderer/components/RNCNaverMapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "RNCNaverMapViewImpl.h"
#import "Utils.h"

using namespace facebook::react;

@interface RNCNaverMapView () <RCTRNCNaverMapViewViewProtocol>

@end

@implementation RNCNaverMapView {
    RNCNaverMapViewImpl *_view;
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

        _view.onInitialized =  [self](NSDictionary * dict) {
            if (_eventEmitter == nil) {
                return;
            }

            auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
            emitter->onInitialized({});
        };

        _view.onOptionChanged =  [self](NSDictionary * dict) {
            if (_eventEmitter == nil) {
                return;
            }

            auto emitter = std::static_pointer_cast<RNCNaverMapViewEventEmitter const>(_eventEmitter);
            emitter->onOptionChanged({});
        };

        self.contentView = _view;
    }

    return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);

#define REMAP_PROP(name)                          \
    if (oldViewProps.name != newViewProps.name) { \
        _view.name = newViewProps.name;           \
    }

#define REMAP_STRING(name)                                     \
    if (oldViewProps.name != newViewProps.name) {              \
        _view.name = RCTNSStringFromString(newViewProps.name); \
    }

#define REMAP_DOUBLE(name)                                          \
    if (oldViewProps.name != newViewProps.name) {                   \
        _view.name = [NSNumber numberWithDouble:newViewProps.name]; \
    }

    if (oldViewProps.mapType != newViewProps.mapType) {
        if (newViewProps.mapType == RNCNaverMapViewMapType::Basic) {
            _view.mapType = NMFMapTypeBasic;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Navi) {
            _view.mapType = NMFMapTypeNavi;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Satellite) {
            _view.mapType = NMFMapTypeSatellite;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Hybrid) {
            _view.mapType = NMFMapTypeHybrid;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::Terrain) {
            _view.mapType = NMFMapTypeTerrain;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::NaviHybrid) {
            _view.mapType = NMFMapTypeNaviHybrid;
        } else if (newViewProps.mapType == RNCNaverMapViewMapType::None) {
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

    auto c1 = oldViewProps.camera, c2 = newViewProps.camera;

    if (c1.latitude != c2.latitude || c1.longitude != c2.longitude ||
        c1.tilt != c2.tilt || c1.bearing != c2.bearing || c1.zoom != c2.zoom) {
        _view.camera = @{
                @"latitude": @(c2.latitude),
                @"longitude": @(c2.longitude),
                @"zoom": @(c2.zoom),
                @"tilt": @(c2.tilt),
                @"bearing": @(c2.bearing),
        };
    }

    auto r1 = oldViewProps.region, r2 = newViewProps.region;

    if (r1.latitude != r2.latitude || r1.longitude != r2.longitude
        || r1.latitudeDelta != r2.latitudeDelta ||
        r1.longitudeDelta != r2.longitudeDelta) {
        _view.region = @{
                @"latitude": @(r1.latitude),
                @"longitude": @(r1.longitude),
                @"latitudeDelta": @(r1.latitudeDelta),
                @"longitudeDelta": @(r1.longitudeDelta),
        };
    }

    auto p1 = oldViewProps.mapPadding, p2 = newViewProps.mapPadding;

    if (p1.top != p2.top || p1.right != p2.right || p1.bottom != p2.bottom || p1.left != p2.left) {
        _view.mapPadding = @{
                @"top": @(p2.top),
                @"right": @(p2.right),
                @"bottom": @(p2.bottom),
                @"left": @(p2.left),
        };
    }

    [super updateProps:props oldProps:oldProps];
}

- (void)animateCameraTo:(double)latitude
              longitude:(double)longitude
               duration:(NSInteger)duration
                 easing:(NSInteger)easing
                 pivotX:(double)pivotX
                 pivotY:(double)pivotY
{
    [_view animateCameraTo:latitude
                 longitude:longitude
                  duration:duration
                    easing:easing
                    pivotX:pivotX
                    pivotY:pivotY];
}

- (void)animateCameraBy:(double)x y:(double)y duration:(NSInteger)duration easing:(NSInteger)easing pivotX:(double)pivotX pivotY:(double)pivotY
{
    [_view animateCameraBy:x
                         y:y
                  duration:duration
                    easing:easing
                    pivotX:pivotX
                    pivotY:pivotY];
}

- (void)animateRegionTo:(double)latitude longitude:(double)longitude latitudeDelta:(double)latitudeDelta longitudeDelta:(double)longitudeDelta duration:(NSInteger)duration easing:(NSInteger)easing pivotX:(double)pivotX pivotY:(double)pivotY
{
    [_view animateRegionTo:latitude
                 longitude:longitude
             latitudeDelta:latitudeDelta
            longitudeDelta:longitudeDelta
                  duration:duration
                    easing:easing
                    pivotX:pivotX
                    pivotY:pivotY];
}

- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
    RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}

Class<RCTComponentViewProtocol> RNCNaverMapViewCls(void) {
    return RNCNaverMapView.class;
}

@end
#endif /* ifdef RCT_NEW_ARCH_ENABLED */
