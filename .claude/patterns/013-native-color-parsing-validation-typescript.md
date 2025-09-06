# native-color-parsing-validation-typescript

# Native Color Parsing and Validation Pattern with TypeScript

[EXPLANATION] TypeScript color prop handling with processColor and native color utilities

## Usage

### TypeScript Component with Color Validation
```typescript
import { type ColorValue, processColor } from 'react-native';

interface ComponentProps {
  color?: ColorValue;
  outlineColor?: ColorValue;
}

const Component = ({
  color = 'black',
  outlineColor = 'black',
}: ComponentProps) => {
  return (
    <NativeComponent
      color={processColor(color) as number}
      outlineColor={processColor(outlineColor) as number}
    />
  );
};
```

### Color Props in Native Component Specs
```typescript
import type { ColorValue } from 'react-native';
import type { WithDefault } from 'react-native/Libraries/Types/CodegenTypes';

interface NativeProps {
  color?: WithDefault<Int32, 0>;
  outlineColor?: WithDefault<Int32, 0>;
}
```

### TypeScript Color Type Definitions
```typescript
import type { ColorValue } from 'react-native';

interface ColorProps {
  /** 
   * 색상입니다.
   * @default 'black'
   */
  color?: ColorValue;
  
  /**
   * 외곽선 색상입니다.
   * @default 'black'
   */
  outlineColor?: ColorValue;
}
```

### iOS Native Color Utility Usage
```objc
// ColorUtil.h usage
#import "ColorUtil.h"

// Parse hex color string to UIColor
UIColor* color = nmap::hexToColor(@"#FF0000");

// Convert integer to UIColor
UIColor* color = nmap::intToColor(0xFF0000FF);
```

### Android Native Color Prop Handling
```kotlin
@ReactProp(name = "color")
override fun setColor(
  view: ComponentView?,
  value: Int,
) {
  view?.let { it.color = value }
}

@ReactProp(name = "outlineColor")  
override fun setOutlineColor(
  view: ComponentView?,
  value: Int,
) {
  view?.let { it.outlineColor = value }
}
```

### Multi-Color Props Interface
```typescript
interface MultiColorProps {
  color?: ColorValue;
  passedColor?: ColorValue;
  outlineColor?: ColorValue; 
  passedOutlineColor?: ColorValue;
}

const MultiColorComponent = ({
  color = 'black',
  passedColor = 'black',
  outlineColor = 'black',
  passedOutlineColor = 'black',
}: MultiColorProps) => {
  return (
    <NativeComponent
      color={processColor(color) as number}
      passedColor={processColor(passedColor) as number}
      outlineColor={processColor(outlineColor) as number}
      passedOutlineColor={processColor(passedOutlineColor) as number}
    />
  );
};
```