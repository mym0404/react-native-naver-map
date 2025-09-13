---
keywords: fumadocs-i18n,file-structure,translation,meta-files,localization
language: markdown
explanation: File structure pattern for Fumadocs i18n with default and Korean translation files using dot-style naming.
---

# Fumadocs I18n File Structure

## Usage

### Basic File Structure
```
content/docs/
├── meta.json           # Default (English)
├── meta.ko.json        # Korean
├── getting-started.mdx # Default (English)
├── getting-started.ko.mdx # Korean
├── api/
│   ├── meta.json
│   ├── meta.ko.json
│   ├── introduction.mdx
│   └── introduction.ko.mdx
└── guides/
    ├── meta.json
    ├── meta.ko.json
    ├── basic-usage.mdx
    └── basic-usage.ko.mdx
```

### Nested Directory Structure
```
content/docs/
├── meta.json
├── meta.ko.json
├── camera-control/
│   ├── meta.json
│   ├── meta.ko.json
│   ├── basic-usage.mdx
│   ├── basic-usage.ko.mdx
│   └── advanced/
│       ├── meta.json
│       ├── meta.ko.json
│       ├── custom-controls.mdx
│       └── custom-controls.ko.mdx
```

## Translation Guidelines

### 1. File Conversion Process
- Current Korean docs → rename to `.ko.mdx` files
- Create new English versions as default files (without locale suffix)
- Maintain exact same file structure and organization

### 2. Translation Rules
- **Structure**: Never change document structure, headings hierarchy, or organization
- **Code blocks**: Keep code exactly the same, only translate comments within code
- **Frontmatter**: Translate all frontmatter fields (title, description, etc.)
- **Content**: Translate all markdown content while preserving formatting

### 3. Code Block Translation Example
```typescript
// Korean version (.ko.mdx)
const map = new NaverMap({
  center: { lat: 37.5665, lng: 126.9780 }, // 서울 중심좌표
  zoom: 15 // 줌 레벨
});

// English version (default .mdx)
const map = new NaverMap({
  center: { lat: 37.5665, lng: 126.9780 }, // Seoul center coordinates
  zoom: 15 // Zoom level
});
```

### 4. Frontmatter Translation Example
```yaml
# Korean (.ko.mdx)
---
title: 카메라 컨트롤
description: 네이버 맵의 카메라 움직임을 제어하는 방법
---

# English (default .mdx)
---
title: Camera Control
description: How to control Naver Map camera movement
---
```

### 5. Meta File Translation
Meta files must also be localized for navigation menus and section titles:

```json
// English (meta.json)
{
  "title": "Documentation",
  "icon": "Book",
  "pages": [
    "---Setup---",
    "index",
    "installation",
    "---Usage---",
    "components",
    "---Guides---",
    "marker-clustering",
    "camera-control"
  ]
}

// Korean (meta.ko.json)
{
  "title": "문서",
  "icon": "Book", 
  "pages": [
    "---설정---",
    "index",
    "installation",
    "---사용법---",
    "components",
    "---가이드---",
    "marker-clustering",
    "camera-control"
  ]
}
```

**Meta Translation Rules:**
- Translate all text values (titles, section dividers)
- Keep JSON structure, keys, and special formatting unchanged
- Preserve external link formats like `[Icon][Text](URL)`
- Don't translate proper nouns (Android, iOS, Expo)