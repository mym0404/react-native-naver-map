# SRC KNOWLEDGE BASE

## OVERVIEW
`src/` owns the public TypeScript surface and the JS-to-native contract for Fabric components.

## STRUCTURE
```text
src/
├── index.tsx      # Public exports (API boundary)
├── component/     # JS wrapper components
├── spec/          # React Native codegen specs
├── types/         # Public domain types
├── internal/      # Internal helpers, constants, assertions
└── util/          # Public utility surface
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Expose new public symbol | `src/index.tsx` | Keep export surface intentional |
| Add native prop/command | `src/spec/` | Update spec first, then native code |
| Update JS wrapper behavior | `src/component/` | Keep shape conversion consistent |
| Add/modify public type | `src/types/` | Treat as user-facing contract |
| Shared helper changes | `src/internal/` | Avoid leaking internals to API |

## CONVENTIONS
- Prefer named exports; avoid default export for new TS modules.
- Keep public API edits localized in `src/index.tsx`.
- Treat `src/spec/*` as canonical interface definitions.
- Convert color props via RN color processing before native handoff.
- Keep component wrappers thin; avoid embedding platform business logic in TS wrappers.

## ANTI-PATTERNS
- Changing `src/component` props without matching `src/spec` and native updates.
- Editing generated declarations under `lib/**` instead of `src/**`.
- Introducing `any`/type suppression for contract mismatches.
- Exporting unstable internals directly from `src/index.tsx`.

## VALIDATION
- Spec changes: run `pnpm codegen`.
- Source changes: run `pnpm run t`.
