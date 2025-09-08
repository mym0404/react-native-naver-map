# Nextra v4를 활용한 React Native Naver Map 문서 시스템 구축

## Overview
React Native Naver Map 라이브러리를 위한 종합적인 문서 시스템을 Nextra v4와 Next.js App Router를 사용하여 구축합니다. content 폴더 기반의 MDX 파일 관리 방식을 도입하여 효율적이고 확장 가능한 문서 구조를 만듭니다.

## Implementation

### Prerequisites and Setup
- Nextra 및 nextra-theme-docs 패키지 설치
- Next.js App Router 기반 프로젝트 구조 설정
- TypeScript 설정 및 타입 정의
- Tailwind CSS 통합
- pnpm workspace 설정으로 docs 폴더 관리

### Core Implementation

#### 1. 패키지 설치 및 설정
- `docs/package.json` 업데이트:
  - nextra, nextra-theme-docs 추가
  - 필요한 빌드 스크립트 설정
  - workspace catalog 참조 유지

#### 2. Next.js 설정 (`docs/next.config.ts`)
- Nextra 플러그인 통합
- contentDirBasePath 설정
- MDX 옵션 구성
- 정적 이미지 최적화 설정
- 코드 하이라이팅 테마 구성

#### 3. 라우트 구조 (`docs/src/app/`)
- `layout.tsx`: Nextra Layout 컴포넌트 통합
  - Navbar 설정 (로고, 프로젝트 링크)
  - Footer 구성
  - PageMap 통합
  - 테마 스타일 임포트
- `[[...mdxPath]]/page.tsx`: 동적 MDX 라우팅
  - generateStaticParams 구현
  - importPage 함수 활용

#### 4. MDX 컴포넌트 설정 (`docs/src/mdx-components.tsx`)
- Nextra 기본 컴포넌트 통합
- 커스텀 컴포넌트 정의 (예제 뷰어, API 레퍼런스)
- 이미지 최적화 컴포넌트

#### 5. Content 디렉토리 구조 (`docs/content/`)
```
content/
├── index.mdx                 # 홈페이지
├── _meta.js                   # 네비게이션 구조
├── getting-started/
│   ├── _meta.js
│   ├── installation.mdx      # 설치 가이드
│   ├── basic-usage.mdx       # 기본 사용법
│   └── expo-setup.mdx        # Expo 설정
├── components/
│   ├── _meta.js
│   ├── map-view.mdx          # NaverMapView
│   ├── markers.mdx           # 마커 컴포넌트
│   ├── overlays.mdx          # 오버레이 컴포넌트
│   └── controls.mdx          # 컨트롤 컴포넌트
├── api-reference/
│   ├── _meta.js
│   ├── props.mdx             # Props 레퍼런스
│   ├── methods.mdx           # 메서드 레퍼런스
│   └── types.mdx             # TypeScript 타입
├── examples/
│   ├── _meta.js
│   ├── basic-map.mdx         # 기본 지도
│   ├── marker-clustering.mdx # 마커 클러스터링
│   └── interactive-map.mdx   # 인터랙티브 맵
└── migration/
    ├── _meta.js
    └── v1-to-v2.mdx          # 마이그레이션 가이드
```

#### 6. _meta.js 파일 구성
- 네비게이션 구조 정의
- 페이지 제목 및 순서 설정
- 외부 링크 (GitHub, NPM) 추가
- 섹션 구분자 설정

#### 7. 컴포넌트 활용
- `<Callout>`: 중요 정보 강조
- `<Cards>`: 기능 카드 레이아웃
- `<Tabs>`: 플랫폼별 코드 (iOS/Android)
- `<FileTree>`: 프로젝트 구조 표시
- `<Steps>`: 설치 단계 가이드

#### 8. 코드 예제 통합
- Syntax highlighting 설정
- 라인 하이라이팅
- 복사 버튼 추가
- 파일명 표시
- npm2yarn 통합

### Integration and Testing
- MDX 파일 hot reloading 테스트
- 네비게이션 구조 검증
- 검색 기능 구현 및 테스트
- 다크 모드 지원
- 모바일 반응형 디자인 확인
- 빌드 최적화 및 성능 테스트

### Deployment and Finalization
- 정적 사이트 생성 설정
- Vercel/GitHub Pages 배포 구성
- 도메인 설정
- SEO 메타데이터 최적화
- Open Graph 이미지 생성
- Analytics 통합

## Todo List
- [ ] docs/package.json에 nextra 및 nextra-theme-docs 의존성 추가
- [ ] docs/next.config.ts를 Nextra 플러그인으로 업데이트
- [ ] docs/src/app/layout.tsx를 Nextra Layout 컴포넌트로 재구성
- [ ] docs/src/app/[[...mdxPath]]/page.tsx 동적 라우트 생성
- [ ] docs/src/mdx-components.tsx 파일 생성 및 설정
- [ ] docs/content 디렉토리 구조 생성
- [ ] 각 섹션별 _meta.tsx 파일 작성
- [ ] 홈페이지 (index.mdx) 작성
- [ ] Getting Started 섹션 문서 작성
- [ ] Components 섹션 문서 작성
- [ ] API Reference 문서 작성
- [ ] 예제 코드 및 데모 작성
- [ ] 마이그레이션 가이드 작성
- [ ] 빌드 및 배포 스크립트 설정
- [ ] 검색 기능 구성
- [ ] 다크 모드 테마 설정

## Success Criteria
- [ ] MDX 파일 기반 문서 작성 및 렌더링 정상 작동
- [ ] 네비게이션 및 사이드바 구조 완성
- [ ] 코드 예제 syntax highlighting 및 복사 기능 작동
- [ ] 검색 기능 정상 작동
- [ ] 모바일 반응형 디자인 구현
- [ ] 빌드 및 배포 성공
- [ ] 페이지 로딩 속도 최적화

## References
- Nextra v4 공식 문서: https://nextra.site
- Next.js App Router 문서
- React Native Naver Map 기존 README
- Pattern: MDX 컴포넌트 통합 패턴
- Spec: 문서 구조 및 네비게이션 스펙
