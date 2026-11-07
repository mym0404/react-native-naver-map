#import "RNCNaverMapInfoWindow.h"
#import "RNCNaverMapUtil.h"

using namespace facebook::react;

@class RNCNaverMapInfoWindow;

@interface RNCNaverMapInfoWindowDataSource : NSObject <NMFOverlayImageDataSource>
@property(nonatomic, weak) RNCNaverMapInfoWindow* owner;
@end

@interface RNCNaverMapInfoWindow () <RCTRNCNaverMapInfoWindowViewProtocol>
- (UIView*)contentViewForInfoWindow;
- (void)scheduleContentUpdate;
- (void)updateContent;
- (void)unregisterInfoWindow;
- (void)tearDownInfoWindow;
@end

@implementation RNCNaverMapInfoWindowDataSource

- (UIView*)viewWithOverlay:(NMFOverlay*)overlay {
  return [self.owner contentViewForInfoWindow];
}

@end

@implementation RNCNaverMapInfoWindow {
  NMFInfoWindow* _infoWindow;
  RNCNaverMapInfoWindowDataSource* _dataSource;
  __weak UIView* _infoWindowContentView;
  NSString* _infoWindowId;
  BOOL _isRegistered;
  BOOL _isContentUpdateScheduled;
  BOOL _isTornDown;
}

+ (bool)shouldBeRecycled {
  return NO;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNCNaverMapInfoWindowProps>();
    _props = defaultProps;

    _infoWindow = [NMFInfoWindow infoWindow];
    _dataSource = [RNCNaverMapInfoWindowDataSource new];
    _dataSource.owner = self;
    _infoWindow.dataSource = _dataSource;
  }

  return self;
}

- (void)dealloc {
  [self tearDownInfoWindow];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                          index:(NSInteger)index {
  [super mountChildComponentView:childComponentView index:index];
  _infoWindowContentView = childComponentView;
  [self scheduleContentUpdate];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol>*)childComponentView
                            index:(NSInteger)index {
  if (_infoWindowContentView == childComponentView) {
    [self unregisterInfoWindow];
    _infoWindowContentView = nil;
  }
  [super unmountChildComponentView:childComponentView index:index];
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapInfoWindowProps const>(props);

  if (prev.infoWindowId != next.infoWindowId) {
    [self unregisterInfoWindow];
    _infoWindowId = [NSString stringWithUTF8String:next.infoWindowId.c_str()];
  }
  if (prev.anchorX != next.anchorX || prev.anchorY != next.anchorY)
    _infoWindow.anchor = CGPointMake(next.anchorX, next.anchorY);
  if (prev.offsetX != next.offsetX)
    _infoWindow.offsetX = next.offsetX;
  if (prev.offsetY != next.offsetY)
    _infoWindow.offsetY = next.offsetY;
  if (prev.alpha != next.alpha)
    _infoWindow.alpha = next.alpha;

  [super updateProps:props oldProps:oldProps];
  [self scheduleContentUpdate];
}

- (void)updateLayoutMetrics:(const LayoutMetrics&)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics&)oldLayoutMetrics {
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];
  [self scheduleContentUpdate];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask {
  [super finalizeUpdates:updateMask];
  [self scheduleContentUpdate];
}

- (void)prepareForRecycle {
  [self tearDownInfoWindow];
  [super prepareForRecycle];
}

- (void)invalidate {
  [self tearDownInfoWindow];
}

- (void)invalidateContent {
  [self scheduleContentUpdate];
}

- (UIView*)contentViewForInfoWindow {
  UIView* contentView = _infoWindowContentView;
  if (!contentView || contentView.bounds.size.width <= 0 || contentView.bounds.size.height <= 0)
    return nil;
  return contentView;
}

- (void)scheduleContentUpdate {
  if (_isTornDown || _isContentUpdateScheduled)
    return;

  _isContentUpdateScheduled = YES;
  __weak RNCNaverMapInfoWindow* weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    RNCNaverMapInfoWindow* strongSelf = weakSelf;
    if (!strongSelf)
      return;
    strongSelf->_isContentUpdateScheduled = NO;
    [strongSelf updateContent];
  });
}

- (void)updateContent {
  if (_isTornDown)
    return;

  if (_infoWindowId.length == 0 || ![self contentViewForInfoWindow]) {
    [self unregisterInfoWindow];
    return;
  }

  if (!_isRegistered) {
    [RNCNaverMapUtil registerInfoWindow:_infoWindow withIdentifier:_infoWindowId];
    _isRegistered = YES;
  }

  if (_infoWindow.mapView || _infoWindow.marker)
    [_infoWindow invalidate];
}

- (void)unregisterInfoWindow {
  if (!_isRegistered)
    return;

  [RNCNaverMapUtil unregisterInfoWindow:_infoWindow withIdentifier:_infoWindowId];
  _isRegistered = NO;
}

- (void)tearDownInfoWindow {
  if (_isTornDown)
    return;

  _isTornDown = YES;
  _isContentUpdateScheduled = NO;
  [self unregisterInfoWindow];
  [_infoWindow close];
  _infoWindow.dataSource = nil;
  _dataSource.owner = nil;
  _infoWindowContentView = nil;
}

Class<RCTComponentViewProtocol> RNCNaverMapInfoWindowCls(void) {
  return RNCNaverMapInfoWindow.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapInfoWindowComponentDescriptor>();
}

- (void)handleCommand:(const NSString*)commandName args:(const NSArray*)args {
  RCTRNCNaverMapInfoWindowHandleCommand(self, commandName, args);
}

@end
