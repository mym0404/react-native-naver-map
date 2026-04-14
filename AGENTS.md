# AGENTS.md

## Project
React Native Naver Map monorepo for a Fabric-only React Native library. The repo owns the public TypeScript API, iOS and Android native implementations, the example app, the docs site, and the Expo config plugin.

## Always-On
- v2.x is New Architecture only. Do not add Bridge-era fallbacks.
- `src/spec/` is the canonical JS/native contract. Spec changes require matching iOS and Android updates plus `pnpm codegen`.
- Keep cross-platform behavior aligned unless a change is explicitly platform-scoped.
- Treat generated outputs as build artifacts, not source: `lib/**`, `docs/.next/**`, `docs/.source/**`, `expo-config-plugin/build/**`.
- Default validation is `pnpm run t`. Add narrower area checks only when the changed surface needs them.

## Routing
- Start with `.agents/knowledge/README.md` for task routing.
- Read `.agents/knowledge/architecture.md` for repo shape, invariants, and generated-output boundaries.
- Read `.agents/knowledge/workflows.md` for validation, codegen, build, runtime checks, and release flow.
- Read `.agents/knowledge/areas/source-surface.md` for `src/`, wrapper, and spec guidance.
- Read `.agents/knowledge/areas/native-platforms.md` for iOS and Android implementation patterns.
- Read `.agents/knowledge/areas/supporting-packages.md` for `example/`, `docs/`, `expo-config-plugin/`, and `script/`.
- Read `.agents/knowledge/patterns.md` for migrated implementation patterns, JSDoc guidance, color handling, and image-loading rules.
