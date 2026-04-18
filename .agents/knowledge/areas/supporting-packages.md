# Supporting Packages

## Example App

`example/` is the manual runtime verification app for library behavior.

- App entrypoints live in [example/index.js](../../../example/index.js) and [example/src/App.tsx](../../../example/src/App.tsx).
- The example app is a React Native CLI app, not an Expo app.
- [example/package.json](../../../example/package.json) shares the root React Native baseline through the workspace catalog in [pnpm-workspace.yaml](../../../pnpm-workspace.yaml).
- `example/` imports `@mj-studio/react-native-naver-map` directly, but the package is intentionally wired through [example/metro.config.js](../../../example/metro.config.js) and [example/react-native.config.js](../../../example/react-native.config.js) instead of a normal dependency entry.
- Keep example-specific behavior inside [example/src/](../../../example/src/). Demo code should not leak into the public API surface.
- Feature verification screens live in [example/src/screens/](../../../example/src/screens/).
- Use root wrapper commands such as `pnpm dev`, `pnpm ios`, and `pnpm android` instead of ad-hoc nested commands.
- Map API keys and secret config files are local-only values.

## Docs Site

`docs/` is a standalone Next.js + Fumadocs site for user-facing documentation.

- MDX content lives in [docs/content/docs/](../../../docs/content/docs/).
- App routes and rendering live in [docs/src/](../../../docs/src/).
- Search API lives in [docs/src/app/api/search/route.ts](../../../docs/src/app/api/search/route.ts).
- Navigation order and bilingual structure are controlled by `meta.json` and `meta.ko.json` files inside the content tree.
- Translation pages use the `.ko.mdx` suffix.
- New docs pages should include `title`, `description`, and `icon` frontmatter, and content should start at `##`, not `#`.
- Use `pnpm build:docs` after docs changes or `pnpm docs:dev` during local iteration.
- Treat `docs/.next/**` and `docs/.source/**` as generated output.

## Expo Config Plugin

`expo-config-plugin/` handles Expo install-time integration for Naver Map keys and permissions.

- Edit plugin behavior in [expo-config-plugin/src/index.ts](../../../expo-config-plugin/src/index.ts).
- Build output lives in `expo-config-plugin/build/`.
- [app.plugin.js](../../../app.plugin.js) loads the compiled plugin output.
- Run `pnpm build:expo-config-plugin` after plugin source changes.
- Keep Android and iOS config key mapping logically paired and backward compatible when possible.

## Repo Scripts

[script/](../../../script/) contains repo automation for codegen, native lint/format, and release flow.

- [script/codegen.mjs](../../../script/codegen.mjs): codegen orchestration
- [script/clang-lint.sh](../../../script/clang-lint.sh) and [script/clang-format.sh](../../../script/clang-format.sh): Objective-C and C-family lint/format helpers
- [script/ktlint-lint.sh](../../../script/ktlint-lint.sh) and [script/ktlint-format.sh](../../../script/ktlint-format.sh): Kotlin lint/format helpers
- [script/release.sh](../../../script/release.sh): release orchestration

## Guardrails

- Preserve the root package script contract when changing script entrypoints.
- Keep shell tooling scoped to the file globs already used by [lefthook.yml](../../../lefthook.yml).
- Release-flow changes must preserve validation before publish.
- Avoid hardcoded machine-local paths and unrelated workspace mutations.

## Related Documents

- Validation and release flow: [../workflows.md](../workflows.md)
- Repo shape and invariants: [../architecture.md](../architecture.md)
- Repo-specific implementation idioms: [../patterns.md](../patterns.md)
