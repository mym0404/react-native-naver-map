# Supporting Packages

## Example App

`example/` is the manual runtime verification app for library behavior.

- App entry: `example/index.js`, `example/src/App.tsx`
- The example app is a React Native CLI app, not an Expo app.
- `example/package.json` declares `react` and `react-native` through `catalog:`.
- The root library package also declares `react` and `react-native` through `catalog:` in `devDependencies`, so the library repo and the example app share one workspace-managed React Native baseline.
- The shared catalog currently pins React Native `0.85.1` and React `19.2.3`.
- Native example tooling resolves React Native through the hoisted workspace installation and the React Native Gradle/CocoaPods integration, not through a separate example-local copy.
- When a React Native native package changes in the workspace or example app, update the hoisted install with `pnpm install` and then run `pnpm pod` to refresh iOS pod resolution and `example/ios/Podfile.lock`.
- `example/` source imports `@mj-studio/react-native-naver-map` directly, but the app does not list that package in `example/package.json`.
- This is intentional in the current repo shape: `example/metro.config.js` maps the JS package name to the repository root, and `example/react-native.config.js` maps the native package root for autolinking.
- Keep `example/react-native.config.js` focused on the local library package. Third-party app dependencies such as `react-native-permissions` and `@react-native-community/slider` should resolve from the hoisted root install through normal React Native discovery, not hardcoded `example/node_modules` paths.
- Feature checks: `example/src/screens/`
- Demo-only UI: `example/src/components/`
- Android example config lives under `example/android/`
- iOS example config lives under `example/ios/`
- Prefer root wrapper commands such as `pnpm dev`, `pnpm ios`, and `pnpm android`.
- Keep example-specific behavior inside `example/`; do not turn demo code into public library API.
- Treat map API keys and secret config files as local-only values.
- Example behavior is a verification aid, not a compatibility guarantee by itself.
- Keep example setup expectations aligned with `CONTRIBUTING.md`.

## Docs Site

`docs/` is a standalone Next.js + Fumadocs site for user-facing documentation.

- Structure:
  - `docs/content/docs/`: MDX content and metadata
  - `docs/src/`: Next app routes, rendering, and search API
  - `docs/source.config.ts`: docs source config
  - `docs/package.json`: docs-local scripts and dependencies
- Content lives in `docs/content/docs/**/*.mdx`.
- Routing and rendering live in `docs/src/`.
- Search API lives in `docs/src/app/api/search/route.ts`.
- Navigation and bilingual ordering live in `meta.json` and `meta.ko.json` files.
- Use docs-local tooling for docs work: `pnpm build:docs` from root or `pnpm dev` inside `docs/`.
- The docs package runs `fumadocs-mdx` on postinstall to refresh generated docs source artifacts.
- Keep `docs/.next/**` and `docs/.source/**` as generated output when present.
- Docs content should stay in MDX under `docs/content/docs/`.
- Translation pages use the `.ko.mdx` suffix.
- New docs pages should include `title`, `description`, and `icon` frontmatter, and content should start at `##`, not `#`.
- Use `meta.json` and `meta.ko.json` to control navigation order and bilingual structure.

## Expo Config Plugin

`expo-config-plugin/` manages Expo install-time integration for Naver Map keys and permissions.

- Expo support in this repo is provided through the config plugin and docs, not through the `example/` app.

- Edit plugin behavior in `expo-config-plugin/src/index.ts`.
- `expo-config-plugin/tsconfig.json` compiles `src/` into `build/`.
- Build output goes to `expo-config-plugin/build/`.
- `app.plugin.js` loads the compiled output from `expo-config-plugin/build`.
- After plugin source changes, rebuild with `pnpm build:expo-config-plugin`.
- Keep iOS and Android config key mapping logically paired.
- Keep plugin defaults explicit and documented for both platforms.
- Changes here affect install-time configuration, not just runtime rendering.
- Prefer conservative option evolution and keep config names backward compatible when possible.

## Repo Scripts

`script/` contains repo automation for codegen, native lint and format, and release flow.

- `script/codegen.mjs`: codegen orchestration
- `script/clang-lint.sh`, `script/clang-format.sh`: iOS and Objective-C lint and format
- `script/ktlint-lint.sh`, `script/ktlint-format.sh`: Kotlin lint and format
- `script/release.sh`: release orchestration

## Guardrails

- Keep script behavior deterministic and CI-safe where possible.
- Preserve the root package script contract when changing script entrypoints.
- Keep shell tooling scoped to the file globs used by Lefthook where that contract already exists.
- Any release-flow change must preserve validation before publish.
- Avoid hardcoded machine-local paths.
- Avoid long-running dev-server behavior in repo scripts.
- Keep shell scripts readable and short.
- Align script names with package-script intent for discoverability.
- Prefer explicit failure messages when prerequisites are missing.
- Avoid adding script behavior that mutates unrelated workspace state.
- For release-script edits, dry-run the expected command sequence locally when practical.

## Related Documents

- Validation and release flow: `../workflows.md`
- Repo invariants: `../architecture.md`
- Detailed implementation patterns: `../patterns.md`
