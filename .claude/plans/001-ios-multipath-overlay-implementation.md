# iOS MultiPath Overlay Implementation

## Overview
네이버 지도 iOS SDK의 NMFMultipartPath를 사용하여 React Native Fabric 아키텍처 기반의 MultiPath overlay 컴포넌트를 구현합니다. 이미 완성된 TypeScript 스펙과 Android 구현에 맞춰 iOS 네이티브 부분만 추가하면 됩니다.

## Implementation

**iOS 네이티브 구현 (NMapsMap SDK 3.22.1 사용)**

### 1. MultiPath 디렉토리 및 헤더 파일 생성
```objc
// ios/Overlay/MultiPath/RNCNaverMapMultiPath.h
#import "ColorUtil.h"
#import "FnUtil.h"
#import "ImageUtil.h"
#import "MacroUtil.h"
#import <Foundation/Foundation.h>
#import <NMapsMap/NMapsMap.h>
#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNCNaverMapSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCNaverMapSpec/EventEmitters.h>
#import <react/renderer/components/RNCNaverMapSpec/Props.h>

@interface RNCNaverMapMultiPath : RCTViewComponentView
@property(nonatomic, strong) NMFMultipartPath* inner;
@end
```

### 2. 구현 파일에서 NMFMultipartPath 사용
```objc
// ios/Overlay/MultiPath/RNCNaverMapMultiPath.mm
- (instancetype)init {
  if ((self = [super init])) {
    _inner = [NMFMultipartPath new];
    _inner.touchHandler = [self](NMFOverlay* overlay) -> BOOL {
      if (self.emitter) {
        self.emitter->onTapOverlay({});
        return YES;
      }
      return NO;
    };
  }
  return self;
}
```

### 3. PathParts 처리 로직
```objc
// pathParts 배열을 NMFMultipartPath의 lineParts와 colorParts로 변환
- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& prev = *std::static_pointer_cast<RNCNaverMapMultiPathProps const>(_props);
  const auto& next = *std::static_pointer_cast<RNCNaverMapMultiPathProps const>(props);
  
  // pathParts 처리
  if (prev.pathParts.size() != next.pathParts.size() || pathPartsChanged) {
    NSMutableArray* lineParts = [NSMutableArray new];
    NSMutableArray* colorParts = [NSMutableArray new];
    
    for (const auto& pathPart : next.pathParts) {
      // coords -> NMGLineString 변환
      NSMutableArray* coords = [NSMutableArray new];
      for (const auto& coord : pathPart.coords) {
        [coords addObject:nmap::createLatLng(coord)];
      }
      [lineParts addObject:[NMGLineString lineStringWithPoints:coords]];
      
      // colors -> NMFPathColor 변환
      NMFPathColor* pathColor = [NMFPathColor colorWithColor:nmap::intToColor(pathPart.color)
                                                outlineColor:nmap::intToColor(pathPart.outlineColor)
                                                 passedColor:nmap::intToColor(pathPart.passedColor)
                                          passedOutlineColor:nmap::intToColor(pathPart.passedOutlineColor)];
      [colorParts addObject:pathColor];
    }
    
    _inner.lineParts = lineParts;
    _inner.colorParts = colorParts;
  }
}
```

### 4. 기본 overlay 속성들 처리
- width, outlineWidth, patternImage, patternInterval
- zIndex, globalZIndex, hidden, minZoom, maxZoom
- isHideCollidedSymbols, isHideCollidedMarkers, isHideCollidedCaptions
- 기존 Path overlay와 동일한 패턴으로 구현

### 5. Fabric 컴포넌트 등록
```objc
Class<RCTComponentViewProtocol> RNCNaverMapMultiPathCls(void) {
  return RNCNaverMapMultiPath.class;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNCNaverMapMultiPathComponentDescriptor>();
}
```

## Todo List
- [ ] iOS MultiPath 디렉토리 생성 (`ios/Overlay/MultiPath/`)
- [ ] 헤더 파일 생성 (`RNCNaverMapMultiPath.h`)
- [ ] 구현 파일 생성 (`RNCNaverMapMultiPath.mm`)
- [ ] Fabric 컴포넌트 등록 코드 추가
- [ ] 빌드 파일 업데이트 (iOS 프로젝트에 새 파일들 추가)

## Success Criteria
- [ ] iOS에서 MultiPath overlay가 정상적으로 렌더링됨
- [ ] pathParts 프롭 변경 시 올바르게 업데이트됨
- [ ] 터치 이벤트가 정상적으로 발생함
- [ ] 다른 overlay 속성들이 정상 작동함 (width, colors, collision 설정 등)
- [ ] Example 앱에서 Android와 동일한 결과 표시

## References
- Pattern #4: iOS Fabric Component 구현 패턴
- Pattern #13: Color Prop Parsing 패턴  
- 네이버 지도 iOS SDK 문서: NMFMultipartPath API
- 기존 Path overlay 구현: `ios/Overlay/Path/RNCNaverMapPath.mm`