# Nextra Meta Configuration

Nextra 문서 사이트의 네비게이션 메타 설정 파일 패턴

## Usage

### Root _meta.ts Configuration
```typescript
import type { MetaRecord } from 'nextra';

export default {
  index: {
    title: '소개',
  },
  'getting-started': {
    title: '시작하기',
  },
  components: {
    title: '컴포넌트',
  },
  api: {
    title: 'API 레퍼런스',
  },
  guides: {
    title: '가이드',
  },
} satisfies MetaRecord;
```

### Subdirectory _meta.ts Configuration
```typescript
import type { MetaRecord } from 'nextra';

export default {
  'map-view': {
    title: 'NaverMapView',
  },
  marker: {
    title: '마커',
  },
  overlays: {
    title: '오버레이',
  },
} satisfies MetaRecord;
```

### With Display Options
```typescript
import type { MetaRecord } from 'nextra';

export default {
  index: {
    title: '시작하기',
    display: 'hidden', // 네비게이션에서 숨김
  },
  advanced: {
    title: '고급 설정',
    theme: {
      layout: 'raw', // 레이아웃 설정
    },
  },
  '-- separator': {
    type: 'separator', // 구분선
  },
  external: {
    title: '외부 링크',
    href: 'https://example.com', // 외부 링크
    newWindow: true,
  },
} satisfies MetaRecord;
```