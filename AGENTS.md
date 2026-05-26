# AGENTS.md

## Project Overview

React Native Naver Map monorepo for `@mj-studio/react-native-naver-map`, a Fabric-only React Native library. The repository owns the public TypeScript API, iOS and Android native implementations, the manual example app, the Fumadocs documentation site, and the Expo config plugin.

## Tech Stack

- React Native `0.85.1` and React `19.2.3` through the `pnpm` workspace catalog.
- TypeScript, React Native Builder Bob, React Native codegen, Biome, Lefthook, Turbo, Kotlin, Objective-C++, CocoaPods, Gradle, Next.js, Fumadocs, and Tailwind CSS.
- `pnpm` uses hoisted `node_modules` with public hoists for React Native native tooling.

## Project Structure

```text
.
# publishable root package and workspace-wide scripts
├── src/                         # public TS API, wrappers, specs, types, utilities
├── ios/                         # Fabric iOS implementation and native utilities
├── android/                     # Fabric Android managers, views, overlays, utilities
├── example/                     # React Native CLI app for manual runtime checks
├── docs/                        # Next.js + Fumadocs documentation site
├── expo-config-plugin/          # Expo config plugin source; build output is generated
├── script/                      # codegen, native lint/format, release helpers
├── .agents/knowledge/           # evergreen repo-local agent knowledge
├── package.json                 # root scripts, package exports, Bob and codegen config
├── pnpm-workspace.yaml          # workspace packages, catalog versions, hoisting rules
├── lefthook.yml                 # default validation and formatting command wiring
└── turbo.json                   # cached native CI task inputs
```

Generated outputs are build artifacts, not source: `lib/**`, `docs/.next/**`, `docs/.source/**`, `expo-config-plugin/build/**`, and native codegen output.

## Always-On

- v2.x is New Architecture only. Do not add Bridge-era UI fallbacks.
- `src/spec/` is the canonical JS/native contract. Spec changes require matching iOS and Android updates plus `pnpm codegen`.
- Keep cross-platform behavior aligned unless a change is explicitly platform-scoped.
- Public API changes should stay visible from `src/index.tsx`.
- Example secrets stay local and must not be committed.

## Working Guidelines

Agents should work in this repository by making assumptions visible, choosing the simplest correct implementation, keeping edits narrow, and validating the result with observable checks.

### Before Editing

- State assumptions before implementation when they affect scope, behavior, risk, or data handling.
- If a request has multiple meaningful interpretations, ask a narrow question instead of choosing silently.
- If a simpler approach satisfies the request, prefer it and explain the tradeoff when needed.
- Stop and ask when a missing decision can change the final result or create irreversible work.

### Implementation Scope

- Write the minimum code needed for the requested behavior.
- Do not add features, abstractions, configurability, fallback paths, or impossible-case error handling that was not requested.
- Touch only files and lines required for the task.
- Match the local style and ownership boundaries of the touched source area.
- Do not refactor unrelated code, reformat adjacent sections, or delete unrelated dead code.

### Change Hygiene

- Remove only imports, variables, functions, or temporary artifacts made unused by the current change.
- If an attempted change is wrong or unnecessary, remove its artifacts before taking another approach.
- Every changed line should trace directly to the user's request or the verification required for that request.

### Verification

- Define observable success criteria before multi-step work.
- For multi-step tasks, use a short plan that includes the verification check for each meaningful step.
- Prefer repo-native validation commands and checks that cover the changed surface.
- Continue until the criteria are met, validation cannot reasonably continue, or a blocker requires the user's decision.

## Runtime And Architecture

- Start runtime tracing at `src/index.tsx`, then follow wrapper components in `src/component/`, spec contracts in `src/spec/`, and matching native managers or views under `ios/` and `android/`.
- Read `.agents/knowledge/architecture.md` for repository shape, invariants, SDK/tooling baseline, generated-output boundaries, and local wiring constraints.

## Verification Commands

- Default validation: `pnpm run t`.
- `pnpm run t` runs Lefthook `check`: Biome for staged JS/TS files, Objective-C lint, Kotlin lint, package typecheck, example typecheck, Expo plugin build, and Bob package build.
- Docs checks are opt-in because `lefthook.yml` currently comments out docs build and docs typecheck. Use `pnpm build:docs` for docs changes.
- Contract changes: run `pnpm codegen`, inspect generated native selectors or abstract methods, then run `pnpm run t`.
- Native module, Fabric command, or native runtime changes need platform builds for the touched surfaces; use `pnpm ci:ios`/`pnpm ci:android` or the matching Turbo commands.
- Runtime confidence comes from `example/` smoke checks when wrapper behavior or screen-visible behavior changes.
- Read `.agents/knowledge/workflows.md` for command coverage, release flow, secret requirements, and validation blind spots.

## Design System

- The docs site uses Fumadocs UI, Tailwind CSS, and Lucide icons.
- The example app uses React Native screens as manual map behavior checks, not as a polished design-system surface.
- Read `.agents/knowledge/design.md` before changing docs UI, example UI, or user-visible documentation components.

## Knowledge Router

- `.agents/knowledge/architecture.md`: repository shape, invariants, SDK/tooling baseline, generated-output boundaries.
- `.agents/knowledge/workflows.md`: validation, codegen, build, runtime checks, release flow.
- `.agents/knowledge/design.md`: docs and example UI conventions.
- `.agents/knowledge/source-surface.md`: `src/`, wrapper, public API, and spec guidance.
- `.agents/knowledge/native-platforms.md`: iOS and Android implementation patterns.
- `.agents/knowledge/rn-native-module.md`: React Native TurboModule, Fabric, codegen, thread, and native SDK object guidance.
- `.agents/knowledge/supporting-packages.md`: `example/`, `docs/`, `expo-config-plugin/`, and `script/`.
- `.agents/knowledge/patterns.md`: reusable implementation patterns for specs, commands, JSDoc, colors, native lifecycle, events, and image loading.

## Knowledge System

- Root `AGENTS.md` is the only entry router; `.agents/knowledge/*` stores evergreen repository knowledge.
- Update `AGENTS.md` and the relevant `.agents/knowledge/*` documents in the same change whenever project structure, runtime entrypoints, verification commands, ownership boundaries, or documented behavior changes.
- Task-local scope, success criteria, verification criteria, temporary constraints, preferences, and examples are not durable repository knowledge unless the user explicitly makes them general or the repository changes make them current truth.
- Repository knowledge describes the current state. It must not be used by itself to reject or discourage intentional functional or structural changes.
