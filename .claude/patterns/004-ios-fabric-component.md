---
keywords: RCTViewComponentView,updateProps,initWithFrame,contentView,emitter
language: objc
explanation: iOS Fabric component implementation extending RCTViewComponentView with props handling
---

# iOS Fabric Component Implementation

## Usage

### Header File
```objc
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>

@interface RNCNaverMapView : RCTViewComponentView
- (std::shared_ptr<facebook::react::RNCNaverMapViewEventEmitter const>)emitter;
@end
```

### Implementation
```objc
@implementation RNCNaverMapView {
  RNCNaverMapViewImpl* _view;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapViewProps>();
    _props = defaultProps;
    _view = [[RNCNaverMapViewImpl alloc] init];
    self.contentView = _view;
  }
  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
  const auto &oldViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<RNCNaverMapViewProps const>(props);
  
  if (oldViewProps.mapType != newViewProps.mapType) {
    // Update native map type
  }
  
  [super updateProps:props oldProps:oldProps];
}
```