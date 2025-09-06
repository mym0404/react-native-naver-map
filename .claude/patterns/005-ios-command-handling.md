# ios-command-handling

# iOS Command Handling

[EXPLANATION] iOS command handling implementation for processing imperative native commands

## Usage

```objc
- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args {
  RCTRNCNaverMapViewHandleCommand(self, commandName, args);
}

void RCTRNCNaverMapViewHandleCommand(RNCNaverMapView *componentView, NSString const *commandName, NSArray const *args) {
  if ([commandName isEqualToString:@"screenToCoordinate"]) {
    double x = [args[0] doubleValue];
    double y = [args[1] doubleValue];
    // Convert screen coordinates to lat/lng and resolve promise
  }
}
```