# Architecture

## Overview

This repository publishes `@mj-studio/react-native-naver-map`, a Fabric-only React Native Naver Map library. One repo owns the public TypeScript surface, native iOS and Android layers, the example app used for runtime checks, the docs site, and the Expo config plugin.

## Repository Shape

- `src/`: public TypeScript API, wrapper components, codegen specs, shared types, utilities
- `ios/`: Objective-C++ Fabric implementation, overlays, native module utilities
- `android/`: Kotlin managers and views plus generated New Architecture interfaces
- `example/`: manual runtime verification app
- `docs/`: Next.js + Fumadocs site
- `expo-config-plugin/`: Expo config plugin source compiled into `build/`
- `script/`: codegen, formatting, lint, and release helpers

## Component Model

- `NaverMapView` is the main map component.
- Overlay components cover marker, circle, polygon, polyline, path, multi-path, arrowhead path, and ground overlays.
- Components render through Fabric-native views rather than a Bridge-era wrapper layer.

## SDK And Tooling Baseline

- The workspace catalog currently pins React Native `0.80.0`.
- iOS uses the Naver Maps iOS SDK via `NMapsMap`; the example app lockfile currently resolves `3.23.0`.
- Android uses `com.naver.maps:map-sdk` through the Gradle `sdkVersion` extension; the public README currently advertises `3.23.0`.
- Core tooling is TypeScript, React Native Builder Bob, Biome, Lefthook, Clang lint/format scripts, Ktlint scripts, Turbo, and Fumadocs.
- The root TypeScript config is strict and uses path mappings; docs also carries its own strict TypeScript config.

## Core Invariants

- New Architecture is mandatory in v2.x. Do not introduce Bridge-era fallback paths.
- `src/spec/` is the source of truth for native props, events, commands, and module contracts.
- Native-facing feature changes should stay in sync across TypeScript, iOS, and Android unless the scope is explicitly platform-specific.
- `src/component/` should stay thin. Normalize props there, but keep platform behavior in the spec and native layers when possible.
- Public API edits should stay intentional and visible from `src/index.tsx`.

## Generated Output Boundaries

Treat generated or build output as disposable artifacts. Edit source, then rebuild.

- `lib/**`: builder-bob output
- `expo-config-plugin/build/**`: compiled Expo plugin output
- `docs/.next/**`: Next.js build output when present
- `docs/.source/**`: generated docs source artifacts when present
- Native codegen output produced by `pnpm codegen`

## Repo-Specific Constraints

- Root Biome checks exclude `docs/**`; the docs site uses its own package and config.
- The workspace packages are `example/` and `docs/`.
- `app.plugin.js` loads the compiled Expo plugin from `expo-config-plugin/build`.
- Example secrets stay local and should not be committed.
- CI may create dummy secret files for build jobs. Local workflows should not rely on that behavior.

## Related Documents

- Validation, build, and release flow: `workflows.md`
- Source surface guidance: `areas/source-surface.md`
- Native implementation guidance: `areas/native-platforms.md`
- Supporting packages and docs site details: `areas/supporting-packages.md`
