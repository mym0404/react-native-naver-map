# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-17 17:22 KST
**Commit:** 99f3c53
**Branch:** main

## OVERVIEW
React Native Naver Map library with Fabric-only architecture. Single repo owns TypeScript API, iOS/Android native layers, example app, docs site, and Expo config plugin.

## STRUCTURE
```text
.
├── src/                 # Public TS API, Fabric specs, shared types
├── ios/                 # Objective-C++ Fabric implementation
├── android/             # Kotlin implementation + codegen interfaces
├── example/             # RN example app for runtime verification
├── docs/                # Next.js + Fumadocs documentation site
├── expo-config-plugin/  # Expo plugin source built to ./build
├── script/              # Repo automation (codegen, lint, release)
└── CLAUDE.md            # Project-wide detailed engineering rules
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Public API export surface | `src/index.tsx` | First file to update for new public symbols |
| Add native prop/command | `src/spec/` | Spec change requires `pnpm codegen` |
| JS component behavior | `src/component/` | Wrapper logic and prop shaping |
| iOS implementation | `ios/` | `RNCNaverMapView*.mm`, `Overlay/*` |
| Android implementation | `android/src/main/java/...` | ViewManager, wrapper, overlay managers |
| Example runtime validation | `example/src/` | Validate map behavior after changes |
| Docs content and app | `docs/content/`, `docs/src/` | Do not edit generated docs outputs |
| Expo plugin behavior | `expo-config-plugin/src/index.ts` | Build output consumed via `app.plugin.js` |
| Release and automation | `script/` | codegen, native lint/format, release flow |

## CODE MAP
LSP symbol indexing was unavailable during generation. Use directory AGENTS files for local maps.

## CONVENTIONS
- New Architecture only: Fabric is mandatory in v2.x; no Bridge fallback.
- `src/spec` is the source of truth for native interfaces; keep TS/iOS/Android in sync.
- Any native feature change must be implemented on both iOS and Android unless explicitly platform-scoped.
- Run `pnpm codegen` after spec changes.
- Run `pnpm run t` as the default pre-PR validation command.
- Root Biome config intentionally excludes `docs/**`; docs has its own config.
- Workspace packages are `example` and `docs`; Expo plugin is built from root script.

## ANTI-PATTERNS (THIS PROJECT)
- Adding or modifying Bridge-era patterns.
- Editing generated artifacts as source (`lib/**`, `docs/.next/**`, `docs/.source/**`, `expo-config-plugin/build/**`).
- Spec changes without regenerated codegen outputs and native parity updates.
- Native-only behavior changes without matching JS/spec contract updates.
- Committing API keys or secrets from example app configuration files.

## UNIQUE STYLES
- Color props flow through React Native color processing and native `Int32` props.
- iOS Fabric views use emitter casting + null guard before event emission.
- Android managers follow codegen delegate patterns and centralized event utility helpers.
- Public docs and examples are bilingual-oriented; metadata files often have `meta` and `meta.ko` pairs.

## COMMANDS
```bash
pnpm run t
pnpm typecheck
pnpm format

pnpm codegen
pnpm codegen:ios
pnpm codegen:android

pnpm build
pnpm build:docs
pnpm build:expo-config-plugin
pnpm prepack

pnpm ci:ios
pnpm ci:android
pnpm turbo:ios
pnpm turbo:android
```

## NOTES
- Example app requires Naver key setup before realistic runtime checks.
- CI injects dummy secret files for build jobs; local workflows should not rely on those.
- When unsure, read `CLAUDE.md` first, then nearest subdirectory `AGENTS.md`.
