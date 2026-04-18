# Architecture

## Repository Shape

This repository publishes `@mj-studio/react-native-naver-map` as a Fabric-only React Native library.

- Repository root: publishable package, shared tooling, release entrypoints
- [src/](../../src/): public TypeScript API, wrappers, codegen specs, shared types and utilities
- [ios/](../../ios/): Objective-C++ Fabric implementation, overlays, native module utilities
- [android/](../../android/): Kotlin managers, views, events, image helpers, generated New Architecture interfaces
- [example/](../../example/): manual runtime verification app
- [docs/](../../docs/): Next.js + Fumadocs site
- [expo-config-plugin/](../../expo-config-plugin/): Expo config plugin source compiled into `build/`
- [script/](../../script/): codegen, lint/format, and release helpers

## Contracts That Drive Changes

- `src/spec/` is the canonical JS/native contract for props, events, commands, and the utility TurboModule.
- `src/index.tsx` is the public export boundary. Public API changes should stay explicit there.
- `src/component/` wrappers should stay thin. Prop normalization belongs there; platform behavior belongs in the spec or native layers when possible.
- Cross-platform feature changes should stay aligned across TypeScript, iOS, and Android unless the scope is explicitly platform-specific.
- `app.plugin.js` loads the compiled Expo plugin from `expo-config-plugin/build`, not from plugin source directly.

## Repository-Specific Seams

- The repository uses a shared `pnpm` catalog in [pnpm-workspace.yaml](../../pnpm-workspace.yaml). Root and example app React Native baselines are intentionally kept in sync there.
- The root package is the main library package even though workspace packages are only `example/` and `docs/`.
- `pnpm-workspace.yaml` uses `nodeLinker: hoisted` with public hoists for React Native tooling, so native example tooling resolves React Native from the hoisted root install.
- `example/` imports `@mj-studio/react-native-naver-map` directly in source, but does not declare the package in [example/package.json](../../example/package.json). That wiring is intentional through [example/metro.config.js](../../example/metro.config.js) and [example/react-native.config.js](../../example/react-native.config.js).
- Third-party React Native packages used by `example/` should resolve through the hoisted install. Do not hardcode them to `example/node_modules`.
- Native SDK version bumps should keep platform config and public docs aligned. Check [android/build.gradle](../../android/build.gradle), [example/ios/Podfile.lock](../../example/ios/Podfile.lock), and [README.md](../../README.md) together when changing SDK versions.
- Example secrets stay local. Local workflows should not depend on CI-created dummy secret files.

## Generated Output

Treat generated or build output as disposable artifacts.

- `lib/**`
- `expo-config-plugin/build/**`
- `docs/.next/**`
- `docs/.source/**`
- native codegen output refreshed by `pnpm codegen`

## Related Documents

- Validation and release flow: [workflows.md](workflows.md)
- TypeScript surface guidance: [areas/source-surface.md](areas/source-surface.md)
- Native implementation guidance: [areas/native-platforms.md](areas/native-platforms.md)
- Example app, docs, and plugin details: [areas/supporting-packages.md](areas/supporting-packages.md)
- Repo-specific implementation idioms: [patterns.md](patterns.md)
