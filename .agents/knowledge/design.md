# Design

## Scope

This repository has two user-visible UI surfaces: the `docs/` site and the `example/` React Native app. The docs site is the public documentation experience. The example app is a manual runtime verification surface for map behavior.

## Docs Site

- `docs/` uses Next.js, Fumadocs UI, Tailwind CSS, and Lucide icons.
- Content lives in `docs/content/docs/**/*.mdx`.
- App routes and shared rendering live in `docs/src/`.
- Global styles are in `docs/src/app/global.css`, which imports Tailwind and Fumadocs presets.
- Docs layout uses Fumadocs primitives such as `RootProvider`, `DocsLayout`, MDX components, cards, callouts, tabs, and steps.
- Bilingual navigation is controlled by `meta.json` and `meta.ko.json` files.
- Translation pages use the `.ko.mdx` suffix.
- New docs pages should include `title`, `description`, and `icon` frontmatter, and content should start at `##`, not `#`.
- Prefer docs-local components in `docs/src/lib/components/` before adding new one-off MDX UI.

## Example App

- `example/` is a React Native CLI app used for manual behavior checks.
- The main app shell starts at `example/src/App.tsx`.
- Runtime screens live in `example/src/screens/`.
- Demo-only shared UI lives in `example/src/components/`.
- Behavior screens should wrap the whole screen in `SafeAreaView` from `react-native-safe-area-context` with `flex: 1` and a black background before rendering `Header`.
- Keep `Header` as the first child inside the screen-level safe area wrapper so the title and back control are not hidden by the status bar, notch, or Dynamic Island.
- Put `ScreenLayout` below `Header`; map overlays and controls should be children or absolute siblings inside the same screen-level wrapper.
- Prefer the shared example controls from `example/src/component/components.tsx`, such as `Btn`, `Toggle`, and `Range`, through `ScreenLayout.controls`.
- Do not use React Native's default `Button` or a separate custom control panel in one screen when the existing shared controls can express the same behavior.
- Keep example UI changes focused on making map behavior clear and testable.
- Do not promote demo-only UI state or controls into the public library API.

## Validation

- Docs changes: run `pnpm build:docs` when the docs site, MDX rendering, navigation metadata, or docs-only components change.
- Example UI or wrapper behavior changes: run `pnpm run t` and smoke-check the relevant `example/src/screens/` path when runtime behavior is affected.
- Markdown-only repository knowledge edits do not need browser validation.
