# AGENTS.md

## Project Overview
React Native Naver Map monorepo for a Fabric-only React Native library. The repository owns the public TypeScript API, iOS and Android native implementations, the example app used for runtime checks, the docs site, and the Expo config plugin.

## Tech Stacks
- `pnpm` workspace monorepo with the publishable library at the repository root and `example/`, `docs/` as workspace packages.
- React Native New Architecture only in v2.x.
- TypeScript + React Native Builder Bob for the library, Next.js + Fumadocs for the docs site, Kotlin and Objective-C++ for native implementations.

## Verification Commands
- `pnpm run t`: after library, native, example, or Expo plugin changes, and before handoff.
- `pnpm codegen && pnpm run t`: after `src/spec/` or any JS/native contract change.
- `pnpm build:docs`: after docs site or MDX changes, because the default root check skips `docs/**`.

## Non-Negotiables
- v2.x is New Architecture only. Do not reintroduce Bridge-era fallback paths.
- `src/spec/` is the canonical JS/native contract. Spec changes require matching iOS and Android updates.
- Keep cross-platform behavior aligned unless the change is explicitly platform-scoped.
- Treat `lib/**`, `docs/.next/**`, `docs/.source/**`, and `expo-config-plugin/build/**` as build artifacts, not source.

## Knowledge Router
- Start with [.agents/knowledge/README.md](.agents/knowledge/README.md).
- Repo shape and invariants: [.agents/knowledge/architecture.md](.agents/knowledge/architecture.md)
- Validation, codegen, build, and release flow: [.agents/knowledge/workflows.md](.agents/knowledge/workflows.md)
- TypeScript surface and spec guidance: [.agents/knowledge/areas/source-surface.md](.agents/knowledge/areas/source-surface.md)
- iOS and Android implementation guidance: [.agents/knowledge/areas/native-platforms.md](.agents/knowledge/areas/native-platforms.md)
- Example app, docs, Expo plugin, and scripts: [.agents/knowledge/areas/supporting-packages.md](.agents/knowledge/areas/supporting-packages.md)
- Repo-specific implementation patterns: [.agents/knowledge/patterns.md](.agents/knowledge/patterns.md)
