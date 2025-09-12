---
keywords: fumadocs, i18n, file-structure, meta, mdx, korean
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