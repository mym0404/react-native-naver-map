# Nextra MDX Document Structure

패키지 문서를 위한 Nextra MDX 파일 구조와 컴포넌트 사용 패턴

## Usage

### Basic MDX Document with Imports
```mdx
import { Tabs, Callout, Steps, FileTree } from 'nextra/components'

# 페이지 제목

<Callout type="info" emoji="🚀">
  중요한 정보나 알림 내용
</Callout>

## 섹션 제목

일반 마크다운 내용...
```

### Tabs Component for Platform-specific Content
```mdx
<Tabs items={['Android', 'iOS', 'Expo CNG']}>
  <Tabs.Tab>
    ### Android 설정
    안드로이드 관련 내용...
  </Tabs.Tab>
  <Tabs.Tab>
    ### iOS 설정
    iOS 관련 내용...
  </Tabs.Tab>
  <Tabs.Tab>
    ### Expo 설정
    Expo 관련 내용...
  </Tabs.Tab>
</Tabs>
```

### Steps Component for Sequential Instructions
```mdx
<Steps>
### 네이버 클라우드 플랫폼 접속
[네이버 클라우드 플랫폼 콘솔](https://console.ncloud.com)에 로그인합니다.

### Maps 상품 신청
- AI·Application Service > Maps 메뉴로 이동
- "이용 신청하기" 클릭

### Client ID 발급
- Application 이름 입력
- 서비스 환경 선택
</Steps>
```

### Code Blocks with Filename
```mdx
\`\`\`tsx filename="App.tsx"
import React from 'react';
import { NaverMapView } from '@mj-studio/react-native-naver-map';

export default function App() {
  return <NaverMapView style={{ flex: 1 }} />;
}
\`\`\`
```

### Installation Commands with Multiple Package Managers
```mdx
<Tabs items={['npm', 'yarn', 'pnpm', 'expo']}>
  <Tabs.Tab>
    \`\`\`bash
    npm install @mj-studio/react-native-naver-map
    \`\`\`
  </Tabs.Tab>
  <Tabs.Tab>
    \`\`\`bash
    yarn add @mj-studio/react-native-naver-map
    \`\`\`
  </Tabs.Tab>
  <Tabs.Tab>
    \`\`\`bash
    pnpm add @mj-studio/react-native-naver-map
    \`\`\`
  </Tabs.Tab>
  <Tabs.Tab>
    \`\`\`bash
    npx expo install @mj-studio/react-native-naver-map
    \`\`\`
  </Tabs.Tab>
</Tabs>
```

### Callout Types
```mdx
<Callout type="success">
  성공 메시지
</Callout>

<Callout type="warning">
  경고 메시지
</Callout>

<Callout type="info" emoji="💡">
  정보 메시지 (커스텀 이모지)
</Callout>

<Callout type="error">
  에러 메시지
</Callout>
```