# Workflows

## Verification Commands

- `pnpm run t`: after library, native, example, or Expo plugin changes, and before handoff. This runs Biome, native lint scripts, TypeScript checks for root and example, Expo plugin build, and `bob build`.
- `pnpm build:docs`: after docs site or MDX changes. Root default validation intentionally skips `docs/**`.
- `pnpm codegen && pnpm run t`: after `src/spec/` or any JS/native contract change.
- `pnpm ci:android`: after Android native build-path changes or when the direct example Android build matters more than cached iteration.
- `pnpm ci:ios`: after iOS native build-path changes or when the direct example iOS build matters more than cached iteration.
- `pnpm turbo:android` or `pnpm turbo:ios`: when cached native iteration is useful and you still want the CI build path.
- `pnpm typecheck`: when a fast root TypeScript-only check is enough for the current edit.
- `pnpm format`: when you intentionally want repo formatting across the file types covered by Lefthook.

## Development Commands

- `pnpm dev`: start Metro for the example app
- `pnpm ios`: run the example app on iOS
- `pnpm android`: run the example app on Android
- `pnpm studio`: open Android Studio for `example/android`
- `pnpm xcode`: open `example/ios/example.xcworkspace`
- `pnpm docs:dev`: start the docs dev server from the root wrapper

## Codegen And Contract Changes

Use this flow when `src/spec/` changes or when a JS/native contract changes.

1. Update the relevant spec file in `src/spec/`.
2. Run `pnpm codegen`.
3. Apply matching iOS and Android updates.
4. Run `pnpm run t`.

## Native Dependency Sync

- If a React Native native package changes in the repository or example app, run `pnpm install` and then `pnpm pod` so the hoisted install state and `example/ios/Podfile.lock` stay aligned.
- Use `pnpm pod:update` only when the pod resolution itself needs to move forward.

## Build And Release

- `pnpm build`: when you need the full package build, docs build, and Expo plugin build together
- `pnpm prepack`: same build surface used before publish
- `pnpm release`: release entrypoint through [script/release.sh](../../script/release.sh)
- The release flow validates with `pnpm run t` and `pnpm prepack` before invoking `release-it`.

## Runtime Verification

- Use [example/src/screens/](../../example/src/screens/) for manual behavior checks after API, wrapper, or native changes.
- When wrapper or public API behavior changes, review the relevant docs page under [docs/content/docs/](../../docs/content/docs/) and update example screens when needed.
- Realistic example verification needs local Naver credentials:
  - Android: `example/android/app/src/main/res/values/secret.xml`
  - iOS: `example/ios/Secret.xcconfig`

## Related Documents

- Repo shape and invariants: [architecture.md](architecture.md)
- TypeScript surface guidance: [areas/source-surface.md](areas/source-surface.md)
- Native implementation guidance: [areas/native-platforms.md](areas/native-platforms.md)
- Example app, docs, and plugin details: [areas/supporting-packages.md](areas/supporting-packages.md)
