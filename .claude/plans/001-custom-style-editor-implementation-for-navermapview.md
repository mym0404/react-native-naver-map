# Custom Style Editor Implementation for NaverMapView

## Overview
Implement support for Naver Map's custom styling feature using Style Editor in the React Native NaverMapView component. This will allow developers to apply custom styles created with Naver Style Editor to their maps through declarative props.

## Implementation

### Technical Stack & Dependencies
- Framework: React Native with New Architecture (Fabric)
- Language & Version: TypeScript 5.x, Objective-C++ (iOS), Kotlin (Android)
- Package Manager: pnpm
- No new dependencies required - using existing React Native codegen infrastructure
- Build system: React Native Builder Bob with codegen

### Architecture & File Structure
**Modified Files:**
- `src/component/NaverMapView.tsx` - Add new props to interface and component
- `src/spec/RNCNaverMapViewNativeComponent.ts` - Add codegen props and events
- `ios/RNCNaverMapView/RNCNaverMapView.mm` - iOS native implementation
- `android/src/main/java/com/reactnativerncnavermap/` - Android native implementation

**New Props Design:**
```typescript
interface NaverMapViewProps {
  // ... existing props
  
  /**
   * Custom style ID from Naver Style Editor
   * @see https://style-editor.map.naver.com
   */
  customStyleId?: string;
  
  /**
   * Called when custom style is successfully loaded
   */
  onCustomStyleLoaded?: () => void;
  
  /**
   * Called when custom style loading fails
   * @param params Error information with message
   */
  onCustomStyleLoadFailed?: (params: {message: string}) => void;
}
```

### Implementation Steps

1. **TypeScript Interface Updates**
   - Add customStyleId, onCustomStyleLoaded, onCustomStyleLoadFailed to NaverMapViewProps
   - Update component prop handling in NaverMapView.tsx

2. **Native Component Spec Updates** 
   - Add customStyleId as optional string prop in RNCNaverMapViewNativeComponent.ts
   - Add onCustomStyleLoaded and onCustomStyleLoadFailed as DirectEventHandler events
   - Use Pattern #001 (Fabric Native Component Definition)

3. **iOS Native Implementation**
   - Extend RNCNaverMapView.mm to handle customStyleId prop changes
   - Implement setCustomStyleId with load/fail handlers using NMFMapView native SDK
   - Use Pattern #004 (iOS Fabric Component Implementation) for props handling
   - Use Pattern #006 (iOS Event Emission) for callback events

4. **Android Native Implementation**
   - Extend Android ViewManager to handle customStyleId prop
   - Implement setCustomStyleId with OnCustomStyleLoadCallback
   - Use Pattern #008 (Android ViewManager with Codegen) for props handling  
   - Use Pattern #010 (Android Event Emission) for callback events

5. **Component Integration**
   - Update NaverMapView component to pass customStyleId to native component
   - Handle onCustomStyleLoaded and onCustomStyleLoadFailed events with useStableCallback
   - Follow existing event handling patterns (similar to onCameraChanged, onInitialized)

### Configuration Details

**iOS Native SDK Integration:**
```objective-c
// Set custom style with callbacks
[self.mapView setCustomStyleId:customStyleId 
                   loadHandler:^{
                       // Emit onCustomStyleLoaded event
                   }
                   failHandler:^(NSError *error) {
                       // Emit onCustomStyleLoadFailed event with error.localizedDescription
                   }];
```

**Android Native SDK Integration:**
```kotlin
// Set custom style with callback
naverMap.setCustomStyleId(customStyleId, object : NaverMap.OnCustomStyleLoadCallback {
    override fun onCustomStyleLoaded() {
        // Emit onCustomStyleLoaded event
    }
    
    override fun onCustomStyleLoadFailed(exception: Exception) {
        // Emit onCustomStyleLoadFailed event with exception.message
    }
})
```

**Error Handling & Edge Cases**
- Handle null/empty customStyleId by clearing custom style
- Handle network failures during style loading
- Parse error messages appropriately for each platform
- iOS: Use NSError.localizedDescription
- Android: Use Exception.message or fallback to generic message

**Performance Considerations**
- Style loading is asynchronous - no blocking operations
- Custom styles may lock certain map options (layers, night mode, etc.)
- Style changes trigger re-rendering but are optimized by native SDK

## Todo List
- [x] Find and analyze native component spec files
- [ ] Add customStyleId props to NaverMapView TypeScript interface  
- [ ] Update native component spec with custom style properties
- [ ] Implement iOS native custom style functionality
- [ ] Implement Android native custom style functionality
- [ ] Update NaverMapView component to handle custom style props
- [ ] Test with provided style ID bf462d9f-fa82-413d-ab7c-df9c5e3c9f7f

## Success Criteria
- [ ] NaverMapView accepts customStyleId prop and applies style successfully
- [ ] onCustomStyleLoaded callback fires when style loads successfully  
- [ ] onCustomStyleLoadFailed callback fires with error message on failures
- [ ] iOS and Android implementations work consistently
- [ ] Test style ID bf462d9f-fa82-413d-ab7c-df9c5e3c9f7f loads properly in example app
- [ ] TypeScript types are properly generated and no compile errors
- [ ] Example app demonstrates custom styling functionality

## References
- Pattern #001: Fabric Native Component Definition
- Pattern #004: iOS Fabric Component Implementation  
- Pattern #006: iOS Event Emission
- Pattern #008: Android ViewManager with Codegen
- Pattern #010: Android Event Emission
- iOS SDK: https://navermaps.github.io/ios-map-sdk/guide-ko/2-4.html
- Android SDK: https://navermaps.github.io/android-map-sdk/guide-ko/2-4.html
- Style Editor: https://style-editor.map.naver.com
- Test Style ID: bf462d9f-fa82-413d-ab7c-df9c5e3c9f7f