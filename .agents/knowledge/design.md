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
- Many behavior screens use a black full-screen map container through `SafeAreaView` and inline React Native styles.
- Keep example UI changes focused on making map behavior clear and testable.
- Do not promote demo-only UI state or controls into the public library API.

## Validation

- Docs changes: run `pnpm build:docs` when the docs site, MDX rendering, navigation metadata, or docs-only components change.
- Example UI or wrapper behavior changes: run `pnpm run t` and smoke-check the relevant `example/src/screens/` path when runtime behavior is affected.
- Markdown-only repository knowledge edits do not need browser validation.
